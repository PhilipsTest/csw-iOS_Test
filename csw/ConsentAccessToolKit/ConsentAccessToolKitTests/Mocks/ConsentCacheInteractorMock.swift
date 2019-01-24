//
//  ConsentCacheInteractorMock.swift
//  ConsentAccessToolKitTests
//
//  Copyright © 2018 Philips. All rights reserved.
//
import PlatformInterfaces
@testable import ConsentAccessToolKit

class ConsentCacheInteractorMock : ConsentCacheProtocol {
    var storedConsentTimesCalled = 0
    var captured = Captured()
    var consentStatusToReturn : CachedConsentStatus?
    
    struct Captured {
        var consentTypePosted: String = ""
        var statusPosted: ConsentStates? = nil
        var versionPosted: Int = -1
        var consentFetchedFor = ""
        var clearedCacheFor = ""
    }
    
    func storeState(forConsentType consentType: String, status: ConsentStates, version: Int,timestamp:Date) -> Bool {
        storedConsentTimesCalled = storedConsentTimesCalled + 1
        self.captured.consentTypePosted = consentType
        self.captured.statusPosted = status
        self.captured.versionPosted = version
        return true
    }
    
    func fetchState(forConsentType consentType: String) -> CachedConsentStatus? {
        self.captured.consentFetchedFor = consentType
        return consentStatusToReturn
    }
    
    func clearCache(forConsentType consentType: String){
        self.captured.clearedCacheFor = consentType
    }
}
