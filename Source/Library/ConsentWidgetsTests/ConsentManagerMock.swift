//
//  ConsentManagerMock.swift
//  ConsentWidgetsTests
//
//  Copyright © 2018 Philips. All rights reserved.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder.
//

import Foundation
import AppInfra
import PlatformInterfaces

class ConsentManagerMock: NSObject, AIConsentManagerProtocol {
    var consentDefinitionStatusesToReturn: [ConsentDefinitionStatus] = []
    var consentDefinitionStatusToReturn: ConsentDefinitionStatus!
    var consentDefinitionToReturn: ConsentDefinition!
    var errorToReturn: NSError?
    
    func registerHandler(handler: ConsentHandlerProtocol, forConsentTypes: [String]) throws {
    }
    
    func deregisterHandler(forConsentTypes: [String]) {
    }
    
    func getConsentDefinition(forConsentType: String) -> ConsentDefinition?{
        
        return consentDefinitionToReturn
    }

    func storeConsentState(consent consentDefinition: ConsentDefinition, withStatus status: Bool, completion: @escaping (Bool, NSError?) -> Void) {
        completion(errorToReturn == nil, errorToReturn)
    }
    
    func fetchConsentStates(forConsentDefinitions consentDefinitions: [ConsentDefinition], completion: @escaping ([ConsentDefinitionStatus]?, NSError?) -> Void) {
        guard errorToReturn == nil else {
            completion(nil, errorToReturn)
            return
        }
        completion(consentDefinitionStatusesToReturn, errorToReturn)
    }
    
    func fetchConsentState(forConsentDefinition consentDefinition: ConsentDefinition, completion: @escaping (ConsentDefinitionStatus?, NSError?) -> Void) {
        guard errorToReturn == nil else {
            completion(nil, errorToReturn)
            return
        }
        completion(consentDefinitionStatusToReturn, errorToReturn)
    }
}
