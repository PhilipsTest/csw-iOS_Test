//
//  ConsentViewDataModelTests.swift
//  ConsentWidgetsTests
//
//  Copyright © 2017 Philips. All rights reserved.
//

import XCTest
import PlatformInterfaces
@testable import ConsentWidgets

class ConsentViewDataModelTests: XCTestCase {
    
    func testConsentViewModelCreationWithConsentDefinition_ActiveStatus_Enabled() {
        let consentDefinition = ConsentDefinition(types: ["moment","coaching"], text: "text", helpText: "helpText", version: 1, locale: "en_US")
        let viewModel = ConsentViewDataModel(consentDefinition: consentDefinition, consentText: "consentText", status: true, isEnabled: true)
        XCTAssertNotNil(viewModel, "View model returned is nil")
    }
    
    func testConsentViewModelCreationWithConsentDefinition_InactiveStatus_Enabled() {
        let consentDefinition = ConsentDefinition(types: ["moment","coaching"], text: "text", helpText: "helpText", version: 1, locale: "en_US")
        let viewModel = ConsentViewDataModel(consentDefinition: consentDefinition, consentText: "consentText", status: false, isEnabled: true)
        XCTAssertNotNil(viewModel, "View model returned is nil")
    }
    
    func testConsentViewModelCreationWithConsentDefinition_ActiveStatus_Disabled() {
        let consentDefinition = ConsentDefinition(types: ["moment","coaching"], text: "text", helpText: "helpText", version: 1, locale: "en_US")
        let viewModel = ConsentViewDataModel(consentDefinition: consentDefinition, consentText: "consentText", status: true, isEnabled: false)
        XCTAssertNotNil(viewModel, "View model returned is nil")
    }
    
    func testConsentViewModelCreationWithConsentDefinition_InactiveStatus_Disabled() {
        let consentDefinition = ConsentDefinition(types: ["moment","coaching"], text: "text", helpText: "helpText", version: 1, locale: "en_US")
        let viewModel = ConsentViewDataModel(consentDefinition: consentDefinition, consentText: "consentText", status: false, isEnabled: false)
        XCTAssertNotNil(viewModel, "View model returned is nil")
    }
}
