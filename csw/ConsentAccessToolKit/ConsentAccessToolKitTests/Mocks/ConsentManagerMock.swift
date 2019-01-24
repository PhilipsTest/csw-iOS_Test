//
//  ConsentManagerMock.swift
//  ConsentAccessToolKitTests
//
/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import AppInfra
import PlatformInterfaces

class ConsentManagerMock: NSObject, AIConsentManagerProtocol {
    var map: [String: ConsentHandlerProtocol] = [:]
    var consentDefinitionToReturn: ConsentDefinition!

    func registerHandler(handler: ConsentHandlerProtocol, forConsentTypes: [String]) throws {
        for consentType in forConsentTypes {
            map.updateValue(handler, forKey: consentType)
        }
    }
    
    func deregisterHandler(forConsentTypes: [String]) {
        
    }
    
    func getConsentDefinition(forConsentType: String) -> ConsentDefinition?{
        
        return consentDefinitionToReturn
    }

    func storeConsentState(consent consentDefinition: ConsentDefinition, withStatus status: Bool, completion: @escaping (_ result: Bool, _ error: NSError?) -> Void) {
        
    }
    
    func fetchConsentStates(forConsentDefinitions consentDefinitions: [ConsentDefinition], completion: @escaping (_ list:[ConsentDefinitionStatus]?, _ error: NSError?) -> Void) {
        
    }
    
    func fetchConsentState(forConsentDefinition consentDefinition: ConsentDefinition, completion: @escaping (_ status: ConsentDefinitionStatus?, _ error: NSError?) -> Void) {
        
    }
    
    
}

extension ConsentManagerMock {
    
    func getHandlerForType(consentType: String) -> ConsentHandlerProtocol? {
        return map[consentType]
    }
}
