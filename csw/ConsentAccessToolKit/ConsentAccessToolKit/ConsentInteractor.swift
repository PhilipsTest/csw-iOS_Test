/*
 
 ConsentInteractor.swift
 ConsentWidgets
 
 Copyright © 2017 Philips. All rights reserved.
 */

import PlatformInterfaces

public class ConsentInteractor: NSObject, ConsentHandlerProtocol {
    private var consentsClient: ConsentsClientProtocol
    private var catkInputs : CATKInputs
    
    private var consentCacheInteractor: ConsentCacheProtocol
    
    enum Constants {
         static let versionMismatchErrorCode = 1252
    }
    
    public init(consentsClient: ConsentsClientProtocol,
                catkInputs: CATKInputs) {
        self.consentsClient = consentsClient
        self.catkInputs = catkInputs
        self.consentCacheInteractor = ConsentCacheInteractor(catkInputs: catkInputs)
    }
    
    convenience init(consentsClient: ConsentsClientProtocol,
                     catkInputs: CATKInputs,
                     consentCacheInteractor: ConsentCacheProtocol) {
        self.init(consentsClient: consentsClient, catkInputs: catkInputs)
        self.consentCacheInteractor = consentCacheInteractor
    }
    
    public func fetchConsentTypeState(for consentType: String, completion: @escaping (_ consent: ConsentStatus?, _ error: NSError?) -> Void) {
        if !ConsentServiceURHandler.sharedInstance.isUserLoggedIn() {
            completion(nil, userNotLoggedInError())
            return
        }
        let cachedConsentStatus = self.consentCacheInteractor.fetchState(forConsentType: consentType)
        if (cachedConsentStatus != nil && (cachedConsentStatus!.expiresOn > Date() || !self.catkInputs.restClient.isInternetReachable())) {
            completion(cachedConsentStatus!.consentStatus, nil)
        } else {
            self.fetchConsentFromBackend(consentType: consentType, completion: { status, error in
                if let consentStatus = status {
                    _ = self.consentCacheInteractor.storeState(forConsentType: consentType, status: consentStatus.status, version: consentStatus.version, timestamp: consentStatus.timestamp)
                }
                
                completion(status, error)
            })
        }
    }
    
    public func storeConsentState(for consentType: String, withStatus status: Bool, withVersion version: Int, completion: @escaping (_ success: Bool, _ error: NSError? ) -> Void) {
        self.storeConsentInBackend(consentType: consentType, withStatus: status, withVersion: version) { (success, error) in
            if success {
                _ = self.consentCacheInteractor.storeState(forConsentType: consentType, status: self.typecastToConsentStatus(status), version: version, timestamp: self.catkInputs.time.getUTCTime())
            }
            if (error != nil && error!.code == Constants.versionMismatchErrorCode) {
                self.consentCacheInteractor.clearCache(forConsentType: consentType)
            }
            completion(success, error)
        }
    }
    
    private func getConsentToPost(_ consentType: String, _ status: Bool, _ version: Int, _ locale: String) -> CATKConsent {
        return CATKConsent(consentType: consentType, subject: ConsentServiceURHandler.sharedInstance.hsdpUUID(), documentVersion:
            String(version), status: typecastToConsentStatus(status), language: locale, country: (self.catkInputs.serviceDiscovery.getHomeCountry())!, dateTime:CATKUtility.convertDatetoString(date:Date(timeIntervalSince1970: 0)))
    }
    
    private func fetchConsentFromBackend(consentType: String, completion: @escaping (_ consent: ConsentStatus?, _ error: NSError?) -> Void) {
        self.consentsClient.fetchLatestConsentsOfType(type: consentType) { (catkConsent, error) in
            let consentTimestamp:Date!
            guard error == nil else {
                completion(nil, error)
                return
            }
            guard let consent = catkConsent as? CATKConsent else {
                completion(ConsentStatus(status: ConsentStates.inactive, version: 0), nil)
                return
            }
            guard let version = Int(consent.documentVersion) else {
                let errorToReturn = NSError(domain: CATKConstants.ConsentServiceErrorDomain.FetchConsentTypeError, code: CATKConstants.ConsentServiceErrorCode.FetchConsentTypeVersionErrorCode, userInfo: [NSLocalizedDescriptionKey: "CATK_PROBLEM_OCCURED".localized])
                completion(nil, errorToReturn)
                return
            }
            guard let timeStamp = consent.dateTime else{
                completion(ConsentStatus(status: consent.status, version: version), nil)
                return
            }
            consentTimestamp = CATKUtility.convertStringtoDate(strDate:timeStamp)
            completion(ConsentStatus(status: consent.status, version: version, timestamp:consentTimestamp), nil)
        }
    }
    
    private func storeConsentInBackend(consentType: String, withStatus status: Bool, withVersion version: Int, completion: @escaping (_ success: Bool, _ error: NSError? ) -> Void) {
        guard self.catkInputs.restClient.isInternetReachable() else {
            let errorToReturn = NSError(domain: CATKConstants.ConsentServiceErrorDomain.StoreConsentTypeError, code: CATKConstants.ConsentServiceErrorCode.StoreConsentTypeNoInternetErrorCode, userInfo: [NSLocalizedDescriptionKey : "CATK_NO_INTERNET_CONNECTION_KEY".localized])
            completion(false, errorToReturn)
            return
        }
        
        guard let locale = self.catkInputs.internationalization?.getBCP47UILocale() else {
            let errorToReturn = NSError(domain: CATKConstants.ConsentServiceErrorDomain.StoreConsentTypeError, code: CATKConstants.ConsentServiceErrorCode.StoreConsentTypeLocaleErrorCode, userInfo: [NSLocalizedDescriptionKey : "CATK_PROBLEM_OCCURED".localized])
            completion(false, errorToReturn)
            return
        }
        self.consentsClient.addConsents(consent: getConsentToPost(consentType, status, version, locale), completion: completion)
    }
    
    private func userNotLoggedInError() -> NSError {
        return NSError(domain: CATKConstants.ConsentServiceErrorDomain.FetchConsentTypeError, code: CATKConstants.ConsentServiceErrorCode.UserNotLoggedInErrorCode, userInfo: nil)
    }
}

private extension ConsentInteractor {
    func typecastToConsentStatus(_ status:Bool) -> ConsentStates {
        return  status ? ConsentStates.active : ConsentStates.rejected
    }
}
