//
// JustInTimeConsentInterface.swift
// Copyright © Koninklijke Philips N.V., 2017
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import UIKit
import PlatformInterfaces
import AppInfra

@objc public class JustInTimeUIConfig: NSObject {
    var title:String!
    var acceptButtonTitle:String!
    var cancelButtonTitle:String!
    var userBenefitsTitle:String!
    var userBenefitsDescription:String!
    
    @objc public init(inTitle:String,inAcceptButtonTite:String,inCancelButtonTitle:String){
        self.title = inTitle
        self.acceptButtonTitle = inAcceptButtonTite
        self.cancelButtonTitle = inCancelButtonTitle
        super.init()
    }
    @objc public convenience init(title:String,acceptButtonTitle:String,cancelButtonTitle:String,userBenefitsTitle:String,userBenefitsDescription:String){
        self.init(inTitle: title, inAcceptButtonTite: acceptButtonTitle, inCancelButtonTitle: cancelButtonTitle)
        self.userBenefitsTitle = userBenefitsTitle
        self.userBenefitsDescription = userBenefitsDescription
    }
}
@objc public protocol JustInTimeViewControllerProtocol:NSObjectProtocol{
    func getJustInTimeConsentViewController(justInTimeConsentDelegate: JustInTimeConsentViewProtocol) -> UIViewController
}
@objc public protocol JustInTimeConsentViewProtocol:NSObjectProtocol{
    func justInTimeConsentAccepted()
    func justInTimeConsentCancelled()
    @objc optional func justInTimeConsentDismissed()
}
@objc public class JustInTimeConsentInterface: NSObject,JustInTimeViewControllerProtocol{
    private(set) var consentDefinition: ConsentDefinition
    private(set) var justInTimeUIConfig: JustInTimeUIConfig
    private(set) var appInfra:AIAppInfra
    
    @objc public init(withConsentDefinition: ConsentDefinition, withUIConfig:JustInTimeUIConfig, withAppInfra:AIAppInfra) {
        self.consentDefinition = withConsentDefinition
        self.justInTimeUIConfig = withUIConfig
        self.appInfra = withAppInfra
        super.init()
    }
    
    @objc public func getJustInTimeConsentViewController(justInTimeConsentDelegate: JustInTimeConsentViewProtocol) -> UIViewController{
        let helper = JustInTimeConsentInterfaceHelper(withConsentDefinition: self.consentDefinition, withUIConfig:self.justInTimeUIConfig, withAppInfra:self.appInfra)
        return helper.getJustInTimeConsentViewController(justInTimeConsentDelegate: justInTimeConsentDelegate)
    }
}
