/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PlatformInterfaces


struct ConsentsClientErrors {
    static let hsdpLoginErrorCode               = 111000
    static let postDataEmptyErrorCode           = 111001
    static let emptyBaseUrlErrorCode            = 111002
}

struct ConsentsClientErrorDomain {
    static let hsdpLoginError                   = "HSDP Login Error"
    static let emptyBaseUrlError                = "Empty base url from service discovery"
    static let emptyPostDataError               = "Empty Post Data"
    
}

public typealias ConsentServiceCompletionHandler = (_ serverResponseObject: ConsentServiceResponseHolder) -> Void

public protocol ConsentsClientProtocol {
    func addConsents(consent: CATKConsent, completion handler: PostConsentCompletionHandler?)
    func fetchLatestConsentsOfType(type: String, completion handler: @escaping GetConsentCompletionHandler)
    func fetchLatestConsentsOfTypes(types: [String], completion handler: @escaping GetConsentCompletionHandler)
}

open class ConsentsClient: NSObject, ConsentsClientProtocol {
    
    fileprivate var responseHandler = CATKConsentServiceResponseHandler()
    fileprivate var communicator: ConsentServiceServerCommunicationProtocol!
    fileprivate var catkInputs: CATKInputs!
    fileprivate var requestsWaitingForTokenRefresh: [(() -> Void)] = []
    fileprivate var refreshTokenErrorHandler: (() -> Void)?
    internal var fetchConsentRetryCount:Int = 0
    
    let accessTokenExpiredErrorCode = 1008
    
    public init(communicator: ConsentServiceServerCommunicationProtocol, catkInputs: CATKInputs) {
        super.init()
        self.communicator = communicator
        self.catkInputs = catkInputs
        ConsentServiceURHandler.sharedInstance.userData?.addUserDataInterfaceListener(self)
        self.fetchConsentRetryCount = 0
    }
    
    public func addConsents(consent: CATKConsent, completion handler: PostConsentCompletionHandler?) {
        getBaseUrl({[weak self] (baseUrl, error) in
            guard error == nil else {
                handler?(false, error)
                return
            }
            guard let postData = self?.createPostDataForPostingConsent(consent: consent) else {
                self?.postConsentErrorHandler(handler: handler,
                                              errorDomain: ConsentsClientErrorDomain.emptyPostDataError,
                                              errorCode: ConsentsClientErrors.postDataEmptyErrorCode)
                return
            }
            guard let baseUrl = baseUrl else {
                self?.postConsentErrorHandler(handler: handler,
                                              errorDomain: ConsentsClientErrorDomain.emptyBaseUrlError,
                                              errorCode: ConsentsClientErrors.emptyBaseUrlErrorCode)
                return
            }
            self?.executePostConsentRequest(baseUrl: baseUrl, url: "consent", body: postData, handler: handler)
        })
    }
    private func postConsentErrorHandler(handler: PostConsentCompletionHandler?,errorDomain:String,errorCode:Int){
        let errorToReturn = NSError(domain: errorDomain, code: errorCode, userInfo: nil)
        handler?(false, errorToReturn)
    }
    public func fetchLatestConsentsOfType(type: String, completion handler: @escaping GetConsentCompletionHandler) {
        fetchLatestConsents(completion: { consents, completionError in
            let responseObject = (consents as? NSArray)?.filter {($0 as? CATKConsent)?.consentType == type}.first
            handler(responseObject as AnyObject?, completionError)
        })
    }
    
    public func fetchLatestConsentsOfTypes(types consentTypes: [String], completion handler: @escaping GetConsentCompletionHandler) {
        guard consentTypes.count > 0 else {
            handler([] as AnyObject?, nil)
            return
        }
        fetchLatestConsents(completion: { consents, error in
            var filteredConsents : [CATKConsent] = []
            guard error == nil else {
                handler(nil, error)
                return
            }
            for consentType in consentTypes {
                let consentOfType = self.filterConsentTypes(consents: consents as! [CATKConsent], consentType: consentType)
                if let consent = consentOfType {
                    filteredConsents.append(consent)
                }
            }
            handler(filteredConsents as AnyObject?, nil)
            
        });
    }
    private func fetchErrorHandler(handler: @escaping GetConsentCompletionHandler,errorDomain:String,errorCode:Int){
        let errorToReturn = NSError(domain: errorDomain, code: errorCode, userInfo: nil)
        handler(nil,errorToReturn)
    }
    public func fetchLatestConsents(completion handler: @escaping GetConsentCompletionHandler) {
        guard let hsdpUuid = ConsentServiceURHandler.sharedInstance.hsdpUUID() else {
            fetchErrorHandler(handler: handler,
                              errorDomain: ConsentsClientErrorDomain.hsdpLoginError,
                              errorCode: ConsentsClientErrors.hsdpLoginErrorCode)
            return
        }
        let requestUrlString = String(format: "consent/%@?applicationName=%@&propositionName=%@", hsdpUuid, self.catkInputs.appConfig.hsdpApplicationName, self.catkInputs.appConfig.hsdpPropositionName)
        getBaseUrl({baseUrl, errorGettingUrl in
            guard errorGettingUrl == nil else {
                handler(nil, errorGettingUrl)
                return
            }
            guard let baseUrl = baseUrl else {
                self.fetchErrorHandler(handler: handler,
                                       errorDomain: ConsentsClientErrorDomain.emptyBaseUrlError,
                                       errorCode: ConsentsClientErrors.emptyBaseUrlErrorCode)
                
                return
            }
            let request = self.createGetRequest(baseURL: baseUrl, url: requestUrlString)
            self.communicator.connectToServerWithRequest(request) {(inServerResponse) in
                self.responseHandler.handleResponseForFetchLatestConsent(inServerResponse, completion: { consents, error in
                    guard error == nil else {
                        self.checkAndRetry(retry:{
                            self.fetchLatestConsents(completion: handler)
                        }, onFailure:{
                            handler(nil, self.createTokenRefreshFailedError())
                        }, errorCode: error!.code,
                           getHandler: handler,
                           postHandler: nil,
                           forGet: true,
                           error: error)
                        return
                    }
                    handler(consents, nil)
                })
            }
        })
    }
    
    private func checkAndRetry(retry: @escaping (()->Void),
                               onFailure: @escaping (()->Void),
                               errorCode: Int,
                               getHandler:  GetConsentCompletionHandler?,
                               postHandler: PostConsentCompletionHandler?,
                               forGet : Bool,
                               error: NSError?){
        if (self.isRetryRequired(errorCode: error!.code)) {
            if(self.fetchConsentRetryCount<2){
                self.refreshAnd(retry:retry,onFailure:onFailure)
            } else{
                forGet ? getHandler?(nil, self.createTokenRefreshFailedError()) : postHandler?(false, self.createTokenRefreshFailedError())
            }
        } else {
            forGet ? getHandler?(nil, error) : postHandler?(false, error)
        }
    }
    
    fileprivate func createTokenRefreshFailedError() -> NSError {
        return NSError(domain: "TokenRefreshFailed", code: 104, userInfo: nil)
    }
    
    fileprivate func executePostConsentRequest(baseUrl: String, url: String, body: Data, handler: PostConsentCompletionHandler?) {
        let request = self.createPostRequest(baseURL: baseUrl, url: "consent", body: body)
        self.communicator.connectToServerWithRequest(request as URLRequest) {(inServerResponse) in
            self.responseHandler.handleResponseForPostConsent(inServerResponse, completion: { consents, error in
                guard error == nil else{
                    self.checkAndRetry(retry:{
                        self.executePostConsentRequest(baseUrl: baseUrl, url: url, body: body, handler: handler)
                    }, onFailure:{
                        handler!(false, self.createTokenRefreshFailedError())
                    }, errorCode: error!.code,
                       getHandler: nil,
                       postHandler: handler,
                       forGet: false,
                       error: error)
                    return
                }
                handler?(true, nil)
            })
        }
    }
    
    fileprivate func resetTokenRefreshHandlers() {
        self.refreshTokenErrorHandler = nil
        self.requestsWaitingForTokenRefresh.removeAll()
    }
    
    fileprivate func refreshAnd(retry: @escaping (()->Void), onFailure: @escaping (()->Void)) {
        self.fetchConsentRetryCount += 1
        self.requestsWaitingForTokenRefresh.append(retry)
        self.refreshTokenErrorHandler = onFailure
        self.refreshAccessToken()
    }
    
    fileprivate func refreshAccessToken() {
        ConsentServiceURHandler.sharedInstance.userData?.refreshSession()
    }
    
    fileprivate func isRetryRequired(errorCode: Int) -> Bool {
        return errorCode == self.accessTokenExpiredErrorCode
    }
    
    fileprivate func filterConsentTypes(consents: [CATKConsent], consentType: String) -> CATKConsent?  {
        return consents.filter {$0.consentType == consentType}.first
    }
    
    fileprivate func createGetRequest(baseURL: String, url: String) -> URLRequest {
        let urlBuilder = ConsentServiceUrlBuilder(baseURL: baseURL)
        return urlBuilder.appendPathComponent(url)
            .setHTTPMethod("GET")
            .setHTTPHeaders(self.getHeaders())
            .getURLRequest()
    }
    
    fileprivate func createPostRequest(baseURL: String, url: String, body: Data) -> URLRequest {
        let urlBuilder = ConsentServiceUrlBuilder(baseURL: baseURL)
        return urlBuilder.appendPathComponent(url)
            .setHTTPMethod("POST")
            .setHTTPHeaders(self.getHeaders())
            .setBody(body)
            .getURLRequest()
    }
    
    fileprivate func getBaseUrl(_ completionHandler: @escaping(String?, NSError?)->Void) {
        self.catkInputs.serviceDiscovery.getServiceUrl(withCountryPreference: "css.consentservice") { (value, error) in
            guard error == nil else{
                if let errorFromServiceDiscovery = error {
                    self.catkInputs.logging.log(.info, eventId: "Init ConsentClient", message: "Services discovery for consent service failed with error \(errorFromServiceDiscovery) for base URL")
                } else {
                    self.catkInputs.logging.log(.info, eventId: "Init ConsentClient", message: "Services discovery for consent service returned false for base URL")
                }
                completionHandler(nil, NSError(domain: "ServiceDiscovery", code: 500, userInfo: nil))
                return
            }
                 completionHandler(value, nil)
        }
    }
    
    private func getHeaders() -> Dictionary<String, String> {
        return [
            "Content-Type": "application/json",
            "api-version": "1",
            "Authorization":  String(format: "bearer %@", ConsentServiceURHandler.sharedInstance.hsdpAccessToken()!),
            "performerId": ConsentServiceURHandler.sharedInstance.hsdpUUID()!
        ]
    }
    
    fileprivate func createPostDataForPostingConsent(consent: CATKConsent) -> Data? {
        guard let consentData = ConsentConverter.convertToConsentDTO(consent: consent, applicationName: self.catkInputs.appConfig.hsdpApplicationName, propositionName: self.catkInputs.appConfig.hsdpPropositionName) else {
            return nil
        }
        do {
            return try JSONSerialization.data(withJSONObject: consentData, options: [])
        } catch _ as NSError {
        }
        return nil
    }
    
    fileprivate func convertResponseToConsent(response : [Any]) -> [CATKConsent] {
        var consentArray: [CATKConsent] = []
        for responseDictionary in response {
            let rawConsent = responseDictionary as! Dictionary<String, Any>
            consentArray.append(ConsentConverter.convertToCATKConsent(consentDTO: rawConsent))
        }
        return consentArray
    }
}

extension ConsentsClient : USRUserDataDelegate {
    public func refreshSessionSuccess() {
        if requestsWaitingForTokenRefresh.count > 0 {
            for request in requestsWaitingForTokenRefresh {
                request()
            }
            self.resetTokenRefreshHandlers()
        }
    }
    public func refreshSessionFailed(_ error: Error){
        guard refreshTokenErrorHandler == nil else {
            self.refreshTokenErrorHandler!()
            self.resetTokenRefreshHandlers()
            return
        }
    }
}

