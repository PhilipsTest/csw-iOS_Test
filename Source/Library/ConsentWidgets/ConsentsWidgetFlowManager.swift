//
//  ConsentsWidgetFlowManager.swift
//  ConsentWidgets
//
//  Copyright © Koninklijke Philips N.V., 2017
//  All rights are reserved. Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder.
//

import Foundation
import PhilipsUIKitDLS
import AppInfra

protocol ConsentWidgetFlow {
    static func moveToWhatDoesThisMeanControllerWith(helpText: String, title: String?, navigationController: UINavigationController?)
}

class ConsentWidgetFlowManager: ConsentWidgetFlow {
    
    static func moveToWhatDoesThisMeanControllerWith(helpText: String, title: String?, navigationController: UINavigationController?) {
        if let vc = ConsentWidgetInterfaceUIHelper.getHelpTextViewController() {
            vc.textToDisplay = helpText
            if let title = title {
                vc.title = title
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
