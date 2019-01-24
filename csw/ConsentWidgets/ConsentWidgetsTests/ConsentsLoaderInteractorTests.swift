
import XCTest
import PlatformInterfaces
import AppInfra
@testable import ConsentWidgets

class ConsentsLoaderInteractorTests: XCTestCase {
    var consentLoader: ConsentsLoaderInteractor!
    var consentDefinitions: [ConsentDefinition]!
    var returnedConsentDefinitionStatuses: [ConsentDefinitionStatus]!
    var errorReturned: NSError!
    var appInfra: AIAppInfra!
    var consentManagerMock = ConsentManagerMock()
    var postResult = false
    let momentConsentDefinition = ConsentDefinition(type: "moment", text: "sampleTest", helpText: "sampleHelpText", version: 1, locale: "en-US")
    let insightConsentDefinition = ConsentDefinition(type: "insight", text: "sampleTest", helpText: "sampleHelpText", version: 1, locale: "en-US")
    let researchConsentDefinition = ConsentDefinition(type: "research", text: "sampleTest", helpText: "sampleHelpText", version: 1, locale: "en-US")
    
    public override func setUp() {
        super.setUp()
        appInfra = AIAppInfra()
        self.consentDefinitions = [momentConsentDefinition,insightConsentDefinition,researchConsentDefinition]
        self.consentLoader = ConsentsLoaderInteractor(appInfra: appInfra)
    }
    
    func testFetchConsentStatesWithError_EmptyConsentDefintionsStatuses() {
        let error = NSError(domain: "Sampel", code: 1000, userInfo: nil)
        givenConfigureConsentManager(consentDefinitionStatuses: [], error: error)
        whenFetchConsents()
        thenErrorReturned(error: error)
    }
    
    func testFetchConsentStatesWithError_WithConsentDefintionsStatuses() {
        let error = NSError(domain: "Sampel", code: 1000, userInfo: nil)
        let definitionStausAppVersionHigher = ConsentDefinitionStatus(status: ConsentStates.active, versionStatus: ConsentVersionStates.appVersionIsHigher, consentDefinition: momentConsentDefinition)
        let definitionStausAppVersionLower = ConsentDefinitionStatus(status: ConsentStates.active, versionStatus: ConsentVersionStates.appVersionIsLower, consentDefinition: insightConsentDefinition)
        givenConfigureConsentManager(consentDefinitionStatuses: [definitionStausAppVersionHigher,definitionStausAppVersionLower], error: error)
        whenFetchConsents()
        thenErrorReturned(error: error)
    }
    
    func testFetchConsentStates_WithConsentDefintionsStatuses() {
        let definitionStausAppVersionHigher = ConsentDefinitionStatus(status: ConsentStates.active, versionStatus: ConsentVersionStates.appVersionIsHigher, consentDefinition: momentConsentDefinition)
        let definitionStausAppVersionLower = ConsentDefinitionStatus(status: ConsentStates.active, versionStatus: ConsentVersionStates.appVersionIsLower, consentDefinition: insightConsentDefinition)
        givenConfigureConsentManager(consentDefinitionStatuses: [definitionStausAppVersionHigher,definitionStausAppVersionLower], error: nil)
        whenFetchConsents()
        thenConsentStatusesReturned(consentDefinitionStatuses: [definitionStausAppVersionHigher,definitionStausAppVersionLower])
    }
    
    func testStoreConsentStateWithError_statusActive() {
        let momentConsentDefinition = ConsentDefinition(type: "moment", text: "sampleTest", helpText: "sampleHelpText", version: 1, locale: "en-US")
        let error = NSError(domain: "Sampel", code: 1000, userInfo: nil)
        givenConfigureConsentManager(error: error)
        whenStoreConsent(consentDefinition: momentConsentDefinition, status: true)
        thenErrorReturned(error: error)
        thenStatusReturned(result: false)
    }
    
    func testStoreConsentStateWithError_statusInActive() {
        let momentConsentDefinition = ConsentDefinition(type: "moment", text: "sampleTest", helpText: "sampleHelpText", version: 1, locale: "en-US")
        let error = NSError(domain: "Sampel", code: 1000, userInfo: nil)
        givenConfigureConsentManager(error: error)
        whenStoreConsent(consentDefinition: momentConsentDefinition, status: false)
        thenErrorReturned(error: error)
        thenStatusReturned(result: false)
    }
    
    func testStoreConsentStateWithoutError_statusInActive() {
        let momentConsentDefinition = ConsentDefinition(type: "moment", text: "sampleTest", helpText: "sampleHelpText", version: 1, locale: "en-US")
        givenConfigureConsentManager(error: nil)
        whenStoreConsent(consentDefinition: momentConsentDefinition, status: false)
        thenStatusReturned(result: true)
    }
    
    func testStoreConsentStateWithoutError_statusActive() {
        let momentConsentDefinition = ConsentDefinition(type: "moment", text: "sampleTest", helpText: "sampleHelpText", version: 1, locale: "en-US")
        givenConfigureConsentManager(error: nil)
        whenStoreConsent(consentDefinition: momentConsentDefinition, status: true)
        thenStatusReturned(result: true)
    }
    
    private func givenConfigureConsentManager(consentDefinitionStatuses: [ConsentDefinitionStatus], error: NSError?) {
        self.consentManagerMock.consentDefinitionStatusesToReturn = consentDefinitionStatuses
        self.consentManagerMock.errorToReturn = error
        self.appInfra.consentManager = self.consentManagerMock
    }
    
    private func givenConfigureConsentManager(error: NSError?) {
        self.consentManagerMock.errorToReturn = error
        self.appInfra.consentManager = self.consentManagerMock
    }
    
    private func givenConfigureConsentManager(consentDefinitionStatus: ConsentDefinitionStatus, error: NSError?) {
        self.consentManagerMock.consentDefinitionStatusToReturn = consentDefinitionStatus
        self.consentManagerMock.errorToReturn = error
        self.appInfra.consentManager = self.consentManagerMock
    }
    
    private func whenFetchConsents() {
        self.consentLoader.fetchAllConsents(consentDefinitions: self.consentDefinitions) { (consentDefinitionStatuses, error) in
            self.returnedConsentDefinitionStatuses = consentDefinitionStatuses
            self.errorReturned = error
        }
    }
    
    private func whenStoreConsent(consentDefinition: ConsentDefinition, status: Bool) {
        self.consentLoader.storeConsentState(withConsentDefinition: consentDefinition, withStatus: status) { (result, error) in
            self.postResult = result
            self.errorReturned = error
        }
    }
    
    private func thenConsentStatusesReturned(consentDefinitionStatuses: [ConsentDefinitionStatus]) {
        XCTAssert(consentDefinitionStatuses.count == self.returnedConsentDefinitionStatuses.count)
        for (index,definitionStatus) in consentDefinitionStatuses.enumerated() {
            let definitionStatusReturned = self.returnedConsentDefinitionStatuses[index]
            XCTAssert(definitionStatusReturned.status == definitionStatus.status)
            XCTAssert(definitionStatusReturned.versionStatus == definitionStatus.versionStatus)
        }
    }
    
    private func thenErrorReturned(error: NSError) {
        XCTAssert(error.code == self.errorReturned.code)
        XCTAssert(error.domain == self.errorReturned.domain)
    }
    
    private func thenStatusReturned(result: Bool) {
        XCTAssert(self.postResult == result)
    }
    
}
