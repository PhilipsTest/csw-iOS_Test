//
// JustInTimeConsentInterfaceHelper.swift
// Copyright © Koninklijke Philips N.V., 2017
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import UIKit
import PlatformInterfaces
import AppInfra

class JustInTimeConsentInterfaceHelper: NSObject {
    private(set) var consentDefinition: ConsentDefinition
    private(set) var justInTimeUIConfig: JustInTimeUIConfig
    private(set) var appInfra:AIAppInfra
    
    init(withConsentDefinition: ConsentDefinition, withUIConfig:JustInTimeUIConfig, withAppInfra:AIAppInfra) {
        self.consentDefinition = withConsentDefinition
        self.justInTimeUIConfig = withUIConfig
        self.appInfra = withAppInfra
    }
    
    func getJustInTimeConsentViewController(justInTimeConsentDelegate: JustInTimeConsentViewProtocol) -> UIViewController {
        let helper = ConsentWidgetInterfaceUIHelper()
        let justInTimeVC =  helper.storyBoard().instantiateViewController(withIdentifier: ViewControllerStoryBoardIds.JustInTimeConsentViewControllerStoryBoardId)
        if let controllerToReturn = justInTimeVC as? JustInTimeConsentViewController {
            controllerToReturn.justInTimeUIConfig = self.justInTimeUIConfig
            controllerToReturn.setJustInTimeConsentDelegate(delegate: justInTimeConsentDelegate)
            controllerToReturn.setConsentDefinition(consentDefinition:consentDefinition)
            controllerToReturn.setAppInfra(inAppInfra: appInfra)
        }
        return justInTimeVC
    }
}
