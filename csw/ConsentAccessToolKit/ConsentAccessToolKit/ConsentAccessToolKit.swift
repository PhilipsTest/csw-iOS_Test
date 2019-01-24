//
//  ConsentAccessToolKit.swift
//  ConsentAccessToolKit
//
/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

struct ConsentAccessToolKitTypes {
    static let momentConsent = "moment"
    static let coachingConsent = "coaching"
    static let binaryConsent = "binary"
    static let researchConsent = "research"
    static let analyticsConsent = "analytics"
    static let deviceTaggingClickstreamConsent = "devicetaggingclickstream"
}

public class ConsentAccessToolKit: NSObject {
    public func registerComponents(catkInputs: CATKInputs) {
        self.registerHandlers(catkInputs: catkInputs)
    }
    
    private func registerHandlers(catkInputs: CATKInputs) {
        let communicator = ConsentServiceNetworkCommunicator(with: catkInputs)
        let consentsClient = ConsentsClient(communicator: communicator, catkInputs: catkInputs)
        let consentInteractor = ConsentInteractor(consentsClient: consentsClient, catkInputs: catkInputs)
        try? catkInputs.consentManager.registerHandler(handler: consentInteractor, forConsentTypes:
        [ConsentAccessToolKitTypes.momentConsent, ConsentAccessToolKitTypes.coachingConsent, ConsentAccessToolKitTypes.binaryConsent, ConsentAccessToolKitTypes.researchConsent, ConsentAccessToolKitTypes.analyticsConsent, ConsentAccessToolKitTypes.deviceTaggingClickstreamConsent])
    }
    
    public func getMomentConsentType() -> String {
        return ConsentAccessToolKitTypes.momentConsent
    }
    
    public func getCoachingConsentType() -> String {
        return ConsentAccessToolKitTypes.coachingConsent
    }
    
    public func getBinaryConsentType() -> String {
        return ConsentAccessToolKitTypes.binaryConsent
    }
    
    public func getResearchConsentType() -> String {
        return ConsentAccessToolKitTypes.researchConsent
    }
    
    public func getAnalyticsConsentType() -> String {
        return ConsentAccessToolKitTypes.analyticsConsent
    }
    
    public func getDeviceTaggingClickstreamConsentType() -> String {
        return ConsentAccessToolKitTypes.deviceTaggingClickstreamConsent
    }
}
