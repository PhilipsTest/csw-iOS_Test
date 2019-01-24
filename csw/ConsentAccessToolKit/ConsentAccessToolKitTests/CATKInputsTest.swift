
import XCTest
@testable import ConsentAccessToolKit

class CATKInputsTest: XCTestCase {
    var catkInputs : CATKInputs?

    func testCatkInputsInit_InitsUserData() {
        whenInitializingCatkInputs()
        thenUserDataIsInitialized()
    }

    fileprivate func whenInitializingCatkInputs() {
        catkInputs = CATKInputs(logging: AppInfraLoggingMock(),
                                 restClient: AppInfraRestClientMock(),
                                 serviceDiscovery: TestAIServiceDiscoveryProtocol(),
                                 internationalization: AppInfraLocalisationMock(),
                                 appConfig: AppConfig(consentCacheTTL: 3, hsdpAppName: "testApp", hsdpPropName: "propositionTest"),
                                 consentManager: ConsentManagerMock(),
                                 userData: UserDataMock())
    }
    
    fileprivate func thenUserDataIsInitialized() {
        XCTAssertNotNil(ConsentServiceURHandler.sharedInstance.userData)
    }
}
