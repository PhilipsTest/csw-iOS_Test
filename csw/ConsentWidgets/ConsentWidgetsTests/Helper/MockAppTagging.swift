//
//  MockAppTagging.swift
//  ConsentWidgetsTests
//
//  Created by Ravi Kiran HR on 05/04/18.
//  Copyright © 2018 Philips. All rights reserved.
//

import Foundation
import UAPPFramework
import PlatformInterfaces


public class MockAppTagging : NSObject,AIAppTaggingProtocol{
    public var componentId : String? = nil
    public var componentVersion : String? = nil
    public var trackedAction : String? = nil
    public var trackedPage : String? = nil
    public var wasTrackActionInvoked = false
    public var wasTrackPageInvoked = false
    public var dictInfo : [String : String] = [:]
    
    public func createInstance(forComponent componentId: String, componentVersion: String) -> AIAppTaggingProtocol {
        self.componentId = componentId
        self.componentVersion = componentVersion
        return self
    }
    
    public func setPrivacyConsent(_ privacyStatus: AIATPrivacyStatus) {
        
    }
    
    public func getPrivacyConsent() -> AIATPrivacyStatus {
        return AIATPrivacyStatus.optIn
    }
    
    public func trackPage(withInfo pageName: String, paramKey key: String?, andParamValue value: Any?) {
        
    }
    
    public func trackPage(withInfo pageName: String, params paramDict: [AnyHashable : Any]?) {
        trackedPage = pageName
        wasTrackPageInvoked = true
        guard let dictPassed = paramDict else {
            return
        }
        
        for (key,value) in dictPassed {
            dictInfo.updateValue(value as! String, forKey: key as! String)
        }
    }
    
    public func trackAction(withInfo actionName: String, paramKey key: String?, andParamValue value: Any?) {
        
    }
    
    public func trackAction(withInfo actionName: String, params paramDict: [AnyHashable : Any]?) {
        wasTrackActionInvoked = true
        trackedAction = actionName
        guard let dictPassed = paramDict else {
            return
        }
        
        for (key,value) in dictPassed {
            dictInfo.updateValue(value as! String, forKey: key as! String)
        }
        
    }
    
    public func trackVideoStart(_ videoName: String) {
        
    }
    
    public func trackVideoEnd(_ videoName: String) {
        
    }
    
    public func trackSocialSharing(_ socialMedia: AIATSocialMedia, withItem sharedItem: String) {
        
    }
    
    public func setPreviousPage(_ pageName: String) {
        
    }
    
    public func trackTimedActionStart(_ action: String?, data: [AnyHashable : Any]?) {
        
    }
    
    public func trackTimedActionEnd(_ action: String?, logic block: ((TimeInterval, TimeInterval, NSMutableDictionary?) -> Bool)? = nil) {
        
    }
    
    public func trackLinkExternal(_ url: String?) {
        
    }
    
    public func trackFileDownload(_ filename: String?) {
        
    }
    
    public func setPrivacyConsentForSensitiveData(_ consent: Bool) {
        
    }
    
    public func getPrivacyConsentForSensitiveData() -> Bool {
        return true
    }
    
    public func getTrackingIdentifier() -> String {
        
        return "ajksakjsdkljasdkljsdjkl"
    }
    
    public func getClickStreamConsentHandler() -> ConsentHandlerProtocol {
        
        return ConsentHandlerMock()
    }
    
    public func getClickStreamConsentIdentifier() -> String {
        return "klsjdkasjdklj"
    }
   
}

class ConsentHandlerMock: NSObject, ConsentHandlerProtocol {
    func fetchConsentTypeState(for consentType: String, completion: @escaping (ConsentStatus?, NSError?) -> Void) {
        
    }
    
    func storeConsentState(for consentType: String, withStatus status: Bool, withVersion version: Int, completion: @escaping (Bool, NSError?) -> Void) {
        
    }
    
    
}
