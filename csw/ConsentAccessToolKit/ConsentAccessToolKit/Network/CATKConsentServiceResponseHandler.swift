//
//  CATKNetworkErrorResponseHandler.swift
//  ConsentAccessToolKit
//
//  Created by Abhishek Chatterjee on 31/10/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import UIKit

struct CATKConsentClientErrorContainer {
    static let unknownErrorCode = -1
}

class CATKConsentServiceResponseHandler: NSObject, CATKNetworkResponseHandlerProtocol {
    
    let errorCodeKey = "errorCode"
    let descriptionKey = "description"
    let unknownErrorMessage = "An unknown error occurred"
    
    
    func handleResponseForFetchLatestConsent(_ response: ConsentServiceResponseHolder, completion: GetConsentCompletionHandler) {
        let error = checkForServerError(response, expectedStatusCode: 200);
        if error != nil {
            completion(nil, error)
        } else {
            do {
                completion(try getConsentsFromResponse(response), nil)
            } catch let unknownError as NSError {
                completion(nil, unknownError)
            }
        }
    }
    
    func handleResponseForPostConsent(_ response: ConsentServiceResponseHolder, completion: PostConsentCompletionHandler) {
        let error = checkForServerError(response, expectedStatusCode: 201);
        if error != nil {
            completion(false, error)
        } else {
            completion(true, nil)
        }
    }
    
    private func checkForServerError(_ response: ConsentServiceResponseHolder, expectedStatusCode: Int) -> NSError? {
        if response.response?.statusCode != expectedStatusCode {
            return getErrorFromResponseData(response)
        }
        return nil
    }
    
    private func getConsentsFromResponse(_ response: ConsentServiceResponseHolder) throws -> AnyObject {
        var responseArray: [CATKConsent] = []
        let statusCode = self.getStatusCode(fromResponse: response)
        do {
            let deserializedResponse : [Dictionary<String, Any>] = try self.deserializeJsonArray(response.data!)
            for responseDictionary in deserializedResponse {
                responseArray.append(ConsentConverter.convertToCATKConsent(consentDTO: responseDictionary))
            }
            return responseArray as AnyObject
        } catch _ as NSError {
           throw getUnknownErrorMessage(withStatusCode: statusCode)
        }
    }
    
    private func getErrorFromResponseData(_ response: ConsentServiceResponseHolder) -> NSError? {
        let statusCode = self.getStatusCode(fromResponse: response)
        if let responseData = response.data {
            var value : Dictionary<String, Any>?
            do {
                value = try self.deserializeJson(responseData)
                return getErrorFromIncidentResponse(responseBody: value!, statusCode: statusCode)
            } catch _ as NSError {
                return getUnknownErrorMessage(withStatusCode: statusCode)
            }
        }

        if let localizedDescription = response.error?.localizedDescription {
            return getUnknownErrorMessage(withStatusCode: statusCode, withLocalizedDescription: localizedDescription)
        }
        return getUnknownErrorMessage(withStatusCode: statusCode)
    }
    
    private func getStatusCode(fromResponse responseHolder: ConsentServiceResponseHolder) -> Int {
        // Check if the error was due to client network problems, if yes then directly get hold of error and return the status code of that error
        if let clientError = responseHolder.error {
            return clientError.code
        }
        
        //If the error was not due to client network problems then it is an error in the server response which we need to fetch from response
        return getServerErrorCode(fromResponse: responseHolder)
    }
    
    private func getServerErrorCode(fromResponse responseHolder: ConsentServiceResponseHolder) -> Int {
        
        guard let dataToParse = responseHolder.data  else { return CATKConsentClientErrorContainer.unknownErrorCode }
        var deserializedResponse : [String : Any]?
        do {
            deserializedResponse = try self.deserializeJson(dataToParse)
        } catch _ as NSError {
            return errorContained(withinHTTPResponse: responseHolder)
        }
        guard let errorCode = deserializedResponse?[errorCodeKey] as? Int else { return errorContained(withinHTTPResponse: responseHolder) }
        return errorCode
    }
    
    private func errorContained(withinHTTPResponse responseHolder: ConsentServiceResponseHolder) -> Int {
        if let errorCodeToReturn = responseHolder.response?.statusCode {
            return errorCodeToReturn
        }
        return CATKConsentClientErrorContainer.unknownErrorCode
    }
    
    private func getErrorFromIncidentResponse(responseBody: Dictionary<String, Any>, statusCode: Int) -> NSError {
        if responseBody[errorCodeKey] != nil {
            let errorCode = responseBody[errorCodeKey] as! Int;
            let description = responseBody[descriptionKey] as! String;
            return NSError(domain: description, code: errorCode, userInfo: nil)
        }
        return getUnknownErrorMessage(withStatusCode: statusCode)
    }
    
    private func getUnknownErrorMessage(withStatusCode code : Int, withLocalizedDescription: String? = nil) -> NSError {
        guard let localizedDescription = withLocalizedDescription else {
            return NSError(domain: unknownErrorMessage, code: code, userInfo: nil)
        }
        return NSError(domain: unknownErrorMessage, code: code, userInfo: [NSLocalizedDescriptionKey : localizedDescription])
    }
    
    private func deserializeJsonArray(_ data : Data) throws -> [Dictionary<String, Any>] {
        guard let deserializedResponse : [Dictionary<String, Any>] = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [Dictionary<String, Any>] else{
            throw NSError()
        }
        return deserializedResponse
    }
    
    private func deserializeJson(_ data : Data) throws -> Dictionary<String, Any>? {
       return try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? Dictionary<String, Any>
    }
}
