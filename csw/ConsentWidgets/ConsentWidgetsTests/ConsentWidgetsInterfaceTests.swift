//
//  ConsentWidgetViewControllerTests.swift
//  ConsentWidgets
//
//  Created by Abhishek Chatterjee on 20/10/17.
//  Copyright © 2017 Niharika Bundela. All rights reserved.
//

import XCTest
import UAPPFramework
import PlatformInterfaces

@testable import ConsentWidgets

class ConsentWidgetsInterfaceTests: XCTestCase {
    var consentWidgetsInterface: ConsentWidgetsInterface?
    var viewController: ConsentWidgetsViewController?
    var consentDefinition = ConsentDefinition(type: "test", text: "test", helpText: "test", version: 1, locale: "en-US")
    var delegateImplementer = ConsentWidgetPrivacyNoticeImplementer()
    
    override public func setUp() {
        super.setUp()
        let dependencies = UAPPDependencies()
        dependencies.appInfra = AIAppInfra()
        dependencies.appInfra.appConfig = MockAppConfig()
        dependencies.appInfra.tagging = MockAppTagging()
        self.consentWidgetsInterface = ConsentWidgetsInterface(dependencies: dependencies, andSettings: nil)
    }
    
    func testInstantiateController() {
        let momentConsentDefinition = ConsentDefinition(type: "moment", text: "sample", helpText: "sample", version: 1, locale: "en-US")
        let insightConsentDefinition = ConsentDefinition(type: "insight", text: "sample", helpText: "sample", version: 1, locale: "en-US")
        let clickstreamConsentDefinition = ConsentDefinition(type: "clickstream", text: "sample", helpText: "sample", version: 1, locale: "en-US")

        let launchInput: ConsentWidgetsLaunchInput = ConsentWidgetsLaunchInput(consentDefinitions:[momentConsentDefinition, clickstreamConsentDefinition,  insightConsentDefinition], privacyDelegate: delegateImplementer)
        let completionHandler: (Error?) -> Swift.Void = { ( error) in }
        whenInstantiatingControllerWith(launchInput: launchInput, withErrorHandler: completionHandler)
        thenViewControllerWasInitialized()
    }
    
    private func getConsentDefinitionFor(types: [String]) -> ConsentDefinition {
        return ConsentDefinition(types: types, text: "type consent", helpText: "sample", version: 0, locale: "en-US")
    }
    
    private func whenInstantiatingControllerWith(launchInput : ConsentWidgetsLaunchInput, withErrorHandler : ((Error?) -> Void)? = nil ) {
        self.viewController = self.consentWidgetsInterface!.instantiateViewController(launchInput, withErrorHandler: withErrorHandler) as? ConsentWidgetsViewController
    }
    
    private func thenViewControllerWasInitialized() {
        XCTAssertNotNil(viewController)
        XCTAssertNotNil(viewController?.consentPresenter)
        XCTAssertNotNil(viewController?.consentPresenter.consentsLoaderInteractor)
        XCTAssertNotNil(viewController?.appInfra)
    }
}

class ConsentWidgetPrivacyNoticeImplementer: NSObject, ConsentWidgetCenterPrivacyProtocol {
    var wasDelegateInvoked: Bool = false
    
    func userClickedOnPrivacyURL() {
        self.wasDelegateInvoked = true
    }
}
