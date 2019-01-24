/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import AppInfra

public class AppInfraLocalisationMock: NSObject, AIInternationalizationProtocol {
    public func getUILocale() -> Locale! {
       return Locale(identifier: "en")
    }
    
    public func getUILocaleString() -> String! {
        return "en-US"
    }
    
    public func getBCP47UILocale() -> String! {
        return "en-US"
    }
    
    
}
