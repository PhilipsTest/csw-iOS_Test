//
//  CATKBaseClassTests.swift
//  ConsentAccessToolKitTests
//
//  Created by Abhishek Chatterjee on 10/10/17.
//  Copyright © 2017 Abhishek Chatterjee. All rights reserved.
//

import XCTest

@testable import ConsentAccessToolKit

class CATKBaseClassTests: XCTestCase {
    var catkInputs: CATKInputs?

    override func setUp() {
        super.setUp()
  
        self.changeConfigurationMethod()
        self.changeLoggingConfigurationMethod()

        self.catkInputs = CATKInputs(logging: AppInfraLoggingMock(),
                                     restClient: AppInfraRestClientMock(),
                                     serviceDiscovery: TestAIServiceDiscoveryProtocol(),
                                     internationalization: AppInfraLocalisationMock(),
                                     appConfig: AppConfig(consentCacheTTL: 3, hsdpAppName: "testApp", hsdpPropName: "propositionTest"),
                                     consentManager: ConsentManagerMock(),
                                     userData: UserDataMock())
    }

    private static var __once: () = {
        let originalSelector: Selector = NSSelectorFromString("readAppConfigurationFromFile")
        let swizzledSelector: Selector = NSSelectorFromString("fakeAppConfigurationFromFile")

        let originalMethod = class_getInstanceMethod(NSClassFromString("AIAppConfiguration"), originalSelector)
        let swizzledMethod = class_getInstanceMethod(NSClassFromString("CATKFakeSelectorClass"), swizzledSelector)

        method_exchangeImplementations(originalMethod!, swizzledMethod!)

        let originalSelector1: Selector = NSSelectorFromString("getPropertyForKey:group:error:")
        let originalMethod1 = class_getInstanceMethod(NSClassFromString("AIAppConfiguration"), originalSelector1)

        let originalSelector2: Selector = NSSelectorFromString("getDefaultPropertyForKey:group:error:")
        let originalMethod2 = class_getInstanceMethod(NSClassFromString("AIAppConfiguration"), originalSelector2)
    }()

    private static var __once1: () = {
        let originalSelector: Selector = NSSelectorFromString("getConfiguration")
        let swizzledSelector: Selector = NSSelectorFromString("fakeLoggingConfigDictionary")

        let originalMethod = class_getInstanceMethod(NSClassFromString("AILogging"), originalSelector)
        let swizzledMethod = class_getInstanceMethod(NSClassFromString("CATKFakeSelectorClass"), swizzledSelector)

        method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }()

    func changeConfigurationMethod() {
        _ = CATKBaseClassTests.__once
    }

    func changeLoggingConfigurationMethod() {
        _ = CATKBaseClassTests.__once1
    }
}
