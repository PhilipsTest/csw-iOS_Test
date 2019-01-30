//
//  JustInTimeConsentControllerHelper.swift
//  ConsentWidgets
//  Copyright © Koninklijke Philips N.V., 2017
//  All rights are reserved. Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder.
//

import Foundation
import PlatformInterfaces
import AppInfra

struct JustInTimeApiServiceConstants {
    static let timeoutInterval = 100.0
}

class JustInTimeConsentAPIService {
    private var appInfra: AIAppInfra!
    private var dispatchQueueForStoring = DispatchQueue(label: "com.ConsentWidgets.JustIntTimeConsentAPIService.StoringQueue")
    
    init(appInfra: AIAppInfra) {
        self.appInfra = appInfra
    }
    
    func postConsent(consentDefinition: ConsentDefinition, withStatus: Bool, completion: @escaping (Bool, NSError?) -> Void) {
        self.appInfra?.consentManager?.storeConsentState(consent: consentDefinition, withStatus: withStatus, completion: completion)
    }
}
