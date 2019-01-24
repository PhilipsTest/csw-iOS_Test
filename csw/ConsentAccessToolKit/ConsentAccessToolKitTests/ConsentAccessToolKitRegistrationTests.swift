//
//  ConsentAccessToolKitRegistrationTests.swift
//  ConsentAccessToolKitTests
//
/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest

@testable import ConsentAccessToolKit

class ConsentAccessToolKitRegistrationTests: XCTestCase {
    var catkInputs: CATKInputs!

    override func setUp() {
        super.setUp()
        Bundle.loadSwizzler()
        
        self.catkInputs = CATKInputs(logging: AppInfraLoggingMock(),
                                     restClient: AppInfraRestClientMock(),
                                     serviceDiscovery: TestAIServiceDiscoveryProtocol(),
                                     internationalization: AppInfraLocalisationMock(),
                                     appConfig: AppConfig(consentCacheTTL: 3, hsdpAppName: "testApp", hsdpPropName: "propositionTest"),
                                     consentManager: ConsentManagerMock(),
                                     userData: UserDataMock())
    }
    
    func testInitialisationWithRegisteredTypes() {
        let accessToolKit = ConsentAccessToolKit()
        //let consentManagerMock = ConsentManagerMock()
        accessToolKit.registerComponents(catkInputs: self.catkInputs)
        if let consentManagerMock = self.catkInputs.consentManager as? ConsentManagerMock{
            XCTAssertNotNil(consentManagerMock.getHandlerForType(consentType: accessToolKit.getMomentConsentType()))
            XCTAssertNotNil(consentManagerMock.getHandlerForType(consentType: accessToolKit.getCoachingConsentType()))
            XCTAssertNotNil(consentManagerMock.getHandlerForType(consentType: accessToolKit.getBinaryConsentType()))
            XCTAssertNotNil(consentManagerMock.getHandlerForType(consentType: accessToolKit.getResearchConsentType()))
            XCTAssertNotNil(consentManagerMock.getHandlerForType(consentType: accessToolKit.getAnalyticsConsentType()))
            XCTAssertNotNil(consentManagerMock.getHandlerForType(consentType: accessToolKit.getDeviceTaggingClickstreamConsentType()))
        }else{
            XCTFail()
        }
        
    }
    
    func testInitialisationWithUnRegisteredTypes() {
        let accessToolKit = ConsentAccessToolKit()
        let consentManagerMock = ConsentManagerMock()
        accessToolKit.registerComponents(catkInputs: self.catkInputs)
        XCTAssertNil(consentManagerMock.getHandlerForType(consentType: "moment1"))
        XCTAssertNil(consentManagerMock.getHandlerForType(consentType: "coaching1"))
        XCTAssertNil(consentManagerMock.getHandlerForType(consentType: "binary1"))
        XCTAssertNil(consentManagerMock.getHandlerForType(consentType: "research1"))
        XCTAssertNil(consentManagerMock.getHandlerForType(consentType: "analytics1"))
    }
    
    func testConsentTypesFetching() {
        let accessToolKit = ConsentAccessToolKit()
        XCTAssertEqual(accessToolKit.getMomentConsentType(), "moment")
        XCTAssertEqual(accessToolKit.getCoachingConsentType(), "coaching")
        XCTAssertEqual(accessToolKit.getBinaryConsentType(), "binary")
        XCTAssertEqual(accessToolKit.getResearchConsentType(), "research")
        XCTAssertEqual(accessToolKit.getAnalyticsConsentType(), "analytics")
        XCTAssertEqual(accessToolKit.getDeviceTaggingClickstreamConsentType(), "devicetaggingclickstream")
    }
}
