//
//  ConsentWidgetViewControllerHelper.swift
//  ConsentWidgets
//  Copyright © Koninklijke Philips N.V., 2017
//  All rights are reserved. Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder.
//

import Foundation
import PhilipsUIKitDLS

struct ConsentWidgetViewControllerHelper {
    
    static func getCompletePrivacyStringToDisplay(fromString: String, withStartKey: String = "{", withEndKey: String = "}") -> String? {
        var stringToReturn = fromString.replacingOccurrences(of: withEndKey, with: "")
        stringToReturn = stringToReturn.replacingOccurrences(of: withStartKey, with: "")
        return stringToReturn
    }
    
    static func getRangeOfHyperlinkedPartOfPrivacyString(fromString: String, withStartKey: String = "{", withEndKey: String = "}") -> NSRange? {
        guard let privacyNotice = fromString.slice(from: withStartKey, to: withEndKey) else { return nil }
        guard let completeString = ConsentWidgetViewControllerHelper.getCompletePrivacyStringToDisplay(fromString: fromString) else { return nil }
        return completeString.nsRange(of: privacyNotice)
    }
}
