//
//  JustInTimeConsentConfigurationDelegate.swift
//  ConsentWidgetsTests
//
//  Copyright © Koninklijke Philips N.V., 2017
//  All rights are reserved. Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder.
//

import Foundation
@testable import ConsentWidgets

class JustInTimeConsentUserActionMock: NSObject, JustInTimeConsentViewProtocol {
    var wasConsentAcceptedInvoked = false
    var wasConsentCanceledInvoked = false
    func justInTimeConsentAccepted() {
        wasConsentAcceptedInvoked = true
    }
    
    func justInTimeConsentCancelled() {
        wasConsentCanceledInvoked = true
    }

}
