//
//  TaggingHelper.swift
//  ConsentWidgets
//
//  Copyright © 2018 Philips. All rights reserved.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder.
//

import Foundation
import UAPPFramework

struct TaggingHelperConstants {
    static let consentType = "consentType"
    static let specialEvents = "specialEvents"
    static let consentActionName = "sendData"
    static let inAppNotification = "inAppNotification"
    static let inAppNotificationResponse = "inAppNotificationResponse"
    static let revokeConsentPopUp = "Revoke consent popup"
    
    struct Action {
        static let yes = "Yes"
        static let cancel = "Cancel"
    }
}

class TaggingHelper : NSObject {
    static func createTaggingInstance(taggingInterface:AIAppTaggingProtocol) -> AIAppTaggingProtocol? {
        let bundle = Bundle(for: self)
        var appTagging:AIAppTaggingProtocol
        if let appVersionString = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            appTagging = taggingInterface.createInstance(forComponent: "CSW", componentVersion: appVersionString)
            return appTagging
        }
        return nil
    }
    
    static func createTaggingInfoDict(consentStatus:Bool,consentTypes:[String]) ->[String:String]{
        var infoDict = [String:String]()
        let consentStatus =  consentStatus ? "consentAccepted" : "consentRejected"
        infoDict[TaggingHelperConstants.specialEvents] = consentStatus
        infoDict[TaggingHelperConstants.consentType] = TaggingHelper.createTaggingString(consentTypes: consentTypes)
        return infoDict
    }
    
    static func createTaggingString(consentTypes: [String]) -> String {
        return consentTypes.joined(separator: "|")
    }
    
    static func createPopUpTagginInfoDictionaryWith(action: Bool) ->[String:String] {
        let revokeAction = action ? TaggingHelperConstants.Action.yes : TaggingHelperConstants.Action.cancel
        return [TaggingHelperConstants.inAppNotification : TaggingHelperConstants.revokeConsentPopUp, TaggingHelperConstants.inAppNotificationResponse : revokeAction]
    }
}
