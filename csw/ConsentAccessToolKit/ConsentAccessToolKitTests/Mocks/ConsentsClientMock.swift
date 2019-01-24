//
//  CATKNetworkSerivcesManagerMock.swift
//  ConsentWidgets
//
//  Created by Abhishek Chatterjee on 23/10/17.
//  Copyright © 2017 Niharika Bundela. All rights reserved.
//

import ConsentAccessToolKit

public class ConsentsClientMock: NSObject, ConsentsClientProtocol {
    
    var lastPostedConsent: CATKConsent?
    var postedConsents: [CATKConsent] = []
    var fetchByTypesConsentTypes : [String] = []
    var fetchByTypeConsentType : String?
    var fetchByTypesError : NSError?
    var errorOnPost : NSError?
    var errorOnPostCount: Int = 0
    
    var fetchByTypesConsentsToReturn : [CATKConsent] = []
    var fetchByTypeConsentToReturn : CATKConsent?
    var shouldReturnDifferentType = false

    public func addConsents(consent: CATKConsent, completion handler: PostConsentCompletionHandler?) {
        self.lastPostedConsent = consent
        self.postedConsents.append(consent)
        if errorOnPost != nil && errorOnPostCount > 0 {
            errorOnPostCount = errorOnPostCount - 1
            handler?(false, errorOnPost)
        }else{
            handler?(true, nil)
        }
    }
    
    public func fetchLatestConsentsOfType(type: String, completion handler: @escaping GetConsentCompletionHandler) {
        fetchByTypeConsentType = type
        if fetchByTypesError != nil {
            handler(nil, fetchByTypesError)
        } else if shouldReturnDifferentType {
            handler(fetchByTypesConsentsToReturn as AnyObject,nil)
        }else{
            handler(fetchByTypeConsentToReturn as AnyObject, nil)
        }
    }

    public func fetchLatestConsentsOfTypes(types: [String], completion handler: @escaping GetConsentCompletionHandler) {
        fetchByTypesConsentTypes.append(contentsOf: types)
        if fetchByTypesError != nil {
            handler(nil, fetchByTypesError)
        }else{
            handler(fetchByTypesConsentsToReturn as AnyObject, nil)
        }
    }
}
