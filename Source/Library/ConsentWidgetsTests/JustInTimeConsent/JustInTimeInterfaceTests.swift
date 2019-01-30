//
//  JustInTimeInterfaceTests.swift
//  ConsentWidgetsTests
//
//  Copyright © Koninklijke Philips N.V., 2017
//  All rights are reserved. Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder.
//

import XCTest
import PlatformInterfaces
import PhilipsUIKitDLS
import AppInfra

@testable import ConsentWidgets

class JustInTimeInterfaceTests: XCTestCase {
    var appInfra: AIAppInfra!

    override func setUp() {
        super.setUp()
        givenAppInfraIsSetToDefaultUnknown()
        appInfra = AIAppInfra(builder: nil)
    }
      
    func testJustInTimeInterfaceCreation() {
        let type1ConsentDefinition = getConsentDefinitionFor(types: ["type1"])
        let consentInteractor = returnConsentInteractorMock(withValue: true, withError: nil)
        let interfaceObject = self.getInterfaceObject(withConsentModel: type1ConsentDefinition, consentInteractor: consentInteractor)
        XCTAssertNotNil(interfaceObject, "Object creation failed")
        XCTAssert(type1ConsentDefinition == interfaceObject.consentDefinition)
    }
    
    func testJustInTimeConsentInterfaceHelperCreation() {
        let type1ConsentDefinition = getConsentDefinitionFor(types: ["type1"])
        let justInTimeUIModel = JustInTimeUIConfig(inTitle: "Sample", inAcceptButtonTite: "Accept", inCancelButtonTitle: "Cancel")
        let helperObject = JustInTimeConsentInterfaceHelper(withConsentDefinition: type1ConsentDefinition, withUIConfig: justInTimeUIModel, withAppInfra: appInfra)
        XCTAssertNotNil(helperObject, "Object creation failed")
        XCTAssert(type1ConsentDefinition == helperObject.consentDefinition)
    }
    
    private func givenAppInfraIsSetToDefaultUnknown(){
        Bundle.loadSwizzler()
        appInfra = AIAppInfra(builder: nil)
        ConsentWidgetsData.sharedInstance.appInfra = appInfra
        appInfra?.tagging.setPrivacyConsent(AIATPrivacyStatus.unknown)
    }
    
    private func getConsentDefinitionFor(types: [String]) -> ConsentDefinition {
        return ConsentDefinition(types: types, text: "type consent", helpText: "sample", version: 0, locale: "en-US")
    }
    
    private func returnConsentInteractorMock(withValue: Bool, withError: NSError?) -> ConsentHandlerProtocol {
        let consentInteractor = ConsentInteractorMock()
        consentInteractor.errorToReturn = withError
        consentInteractor.postSuccess = withValue
        return consentInteractor
    }
    
    private func getInterfaceObject(withConsentModel: ConsentDefinition, consentInteractor: ConsentHandlerProtocol) -> JustInTimeConsentInterface {
        let justInTimeUIModel = JustInTimeUIConfig(inTitle: "Sample", inAcceptButtonTite: "Accept", inCancelButtonTitle: "Cancel")
        let interfaceObject = JustInTimeConsentInterface(withConsentDefinition: withConsentModel, withUIConfig: justInTimeUIModel, withAppInfra: appInfra)
        return interfaceObject
    }
}
