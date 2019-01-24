import XCTest
import PlatformInterfaces

@testable import ConsentAccessToolKit

class ConsentsClientTest: XCTestCase {
    
    let APPLICATION_NAME = "OneBackend"
    let PROPOSITION_NAME = "OneBackendProp"
    static let ACCESS_TOKEN = "AccessToken"
    static let REFRESHED_ACCESS_TOKEN = "RefreshedAccessToken"
    static let USER_ID = "UserID"
    
    var consentsClient: ConsentsClient!
    var testCommunicator: ConsentServiceNetworkCommunicatorMock!
    var serviceDiscovery :TestAIServiceDiscoveryProtocol!
    var returnedConsent : CATKConsent?
    var returnedConsents : [CATKConsent]? = []
    var errorCompletionCalled = false
    var completionCalled = false
    var returnedError: NSError?
    let consent = CATKConsent(consentType: "moment", subject: "uuid", documentVersion: "0", status: ConsentStates.active, language: "en-GB", country: "US", dateTime: "1970-01-01 05:46:40")
    let userData = TestUserData()
    
    override func setUp() {
        super.setUp()
        serviceDiscovery = TestAIServiceDiscoveryProtocol()
        
        let catkInputs = CATKInputs(logging: AppInfraLoggingMock(),
                                     restClient: AppInfraRestClientMock(),
                                     serviceDiscovery: serviceDiscovery,
                                     internationalization: AppInfraLocalisationMock(),
                                     appConfig: AppConfig(consentCacheTTL: 3, hsdpAppName: APPLICATION_NAME, hsdpPropName: PROPOSITION_NAME),
                                     consentManager: ConsentManagerMock(),
                                     userData: userData)
        
        
        testCommunicator = ConsentServiceNetworkCommunicatorMock(with: catkInputs)
        consentsClient = ConsentsClient(communicator: testCommunicator, catkInputs: catkInputs)
        userData.consentsClient = consentsClient
    }
    
    func testSubscribesForTokenRefreshEvents() {
        thenIsSubscribedForTokenRefreshEvents()
    }
    
    func testGetLatestConsentWithEmptyHSDPUUIDError() {
        userData.hsdpUUID = nil
        ConsentServiceURHandler.sharedInstance.userData = userData
        let asyncExpectation = expectation(description: "longRunningFunction")
        self.consentsClient.fetchLatestConsents(){consents, error in
            XCTAssertNil(consents, "Consents are retruned despite empty HSDPUUID")
            XCTAssertNotNil(error, "Error retruned is nil")
            XCTAssert(error?.code == ConsentsClientErrors.hsdpLoginErrorCode, "Error code returned is not matching")
            XCTAssert(error?.domain == ConsentsClientErrorDomain.hsdpLoginError, "Error domain returned is not matching")
            asyncExpectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 15) { error in
            if (error != nil) {
                let message = "Failed to complete Inserting after 15 seconds."
                self.recordFailure(withDescription: message, inFile: #file, atLine: #line, expected: true)
            }
        }
    }
    
    func testGetLatestConsent() {
        givenBackendReturns(types: ["moment", "insight", "someOtherType"])
        whenFetchingLatestConsents()
        thenARestCallIsMadeTo(expectedUrl: "www.test.com/consent/" + ConsentsClientTest.USER_ID + "?applicationName=" + APPLICATION_NAME + "&propositionName=" + PROPOSITION_NAME, times: 1)
        thenHeaderIsSent(name: "api-version", value: "1")
        thenHeaderIsSent(name: "Content-Type", value: "application/json")
        thenHeaderIsSent(name: "Authorization", value: "bearer " + ConsentsClientTest.ACCESS_TOKEN)
        thenHeaderIsSent(name: "performerId", value: ConsentsClientTest.USER_ID)
        thenConsentsAreReturned(expectedConsentTypes: ["moment", "insight", "someOtherType"])
        thenServiceDiscoveryIsConsultedForTimes(count: 1, with: "css.consentservice")
    }
    
    func testGetLatestConsent_returnsErrorWithHttpStatusCode() {
        givenBackendReturns(inData: "<invalid_JSON>", status: 404, error: nil)
        whenFetchingLatestConsents()
        thenErrorCompletionHandlerIsInvoked(withDomain: "An unknown error occurred", andCode: 404)
    }
    
    func testGetLatestConsent_returnsErrorWithServerResponseCode() {
        givenBackendReturns(inData: "{\"incidentID\":\"any\",\"errorCode\": 1000,\"description\":\"SomeErrorCode\"}", status: 401, error: NSError())
        whenFetchingLatestConsents()
        thenErrorCompletionHandlerIsInvoked(withDomain: "SomeErrorCode", andCode: 1000)
    }
    
    func testGetLatestConsent_returnsErrorWhenServerRespondsWith200_butUnexpectedJson() {
        givenBackendReturns(inData: "{}", status: 200, error: nil)
        whenFetchingLatestConsents()
        thenErrorCompletionHandlerIsInvoked(withDomain: "An unknown error occurred", andCode: 200)
    }
    
    func testGetLatestConsent_returnsErrorWhenServerRespondsWith200_butInvalidJson() {
        givenBackendReturns(inData: "<invalid_json>", status: 200, error: nil)
        whenFetchingLatestConsents()
        thenErrorCompletionHandlerIsInvoked(withDomain: "An unknown error occurred", andCode: 200)
    }
    
    func testGetLatestConsent_retriesOn1008ErrorCode() {
        givenBackendReturns(inData: "{\"incidentID\":\"any\",\"errorCode\": 1008,\"description\":\"Access Token Expired\"}", status: 401, error: nil)
        given(onTokenRefresh: {
            self.givenBackendReturns(types: ["moment", "insight", "someOtherType"])
        })
        whenFetchingLatestConsents()
        thenARestCallIsMadeTo(expectedUrl: "www.test.com/consent/" + ConsentsClientTest.USER_ID + "?applicationName=" + APPLICATION_NAME + "&propositionName=" + PROPOSITION_NAME, times: 2)
        thenHeaderIsSent(name: "Authorization", value: "bearer " + ConsentsClientTest.REFRESHED_ACCESS_TOKEN)
        thenTokenIsRefreshed()
        thenConsentsAreReturned(expectedConsentTypes: ["moment", "insight", "someOtherType"])
        thenErrorCompletionIsNotCalled()
    }
    
    func testGetLatestConsent_retriesOnlyTwiceOn1008ErrorCode() {
        givenBackendReturns(inData: "{\"incidentID\":\"any\",\"errorCode\": 1008,\"description\":\"Access Token Expired\"}", status: 401, error: nil)
        given(onTokenRefresh: {
            self.givenBackendReturns(inData: "{\"incidentID\":\"any\",\"errorCode\": 1008,\"description\":\"Access Token Expired\"}", status: 401, error: nil)
        })
        whenFetchingLatestConsents()
        thenTokenIsRefreshed()
        thenHeaderIsSent(name: "Authorization", value: "bearer " + ConsentsClientTest.REFRESHED_ACCESS_TOKEN)
        thenErrorCompletionHandlerIsInvoked(withDomain: "TokenRefreshFailed", andCode: 104)
        thenRetryCalledTwice()
    }
    
    func testGetLatestConsent_returnsErrorWhenTokenRefreshFails() {
        givenBackendReturns(inData: "{\"incidentID\":\"any\",\"errorCode\": 1008,\"description\":\"Invalid Access Token\"}", status: 401, error: nil)
        givenTokenRefreshFails()
        whenFetchingLatestConsents()
        thenARestCallIsMadeTo(expectedUrl: "www.test.com/consent/" + ConsentsClientTest.USER_ID + "?applicationName=" + APPLICATION_NAME + "&propositionName=" + PROPOSITION_NAME, times: 1)
        thenTokenIsRefreshed()
        thenErrorCompletionHandlerIsInvoked(withDomain: "TokenRefreshFailed", andCode: 104)
    }
    
    
    func testGetLatestConsentReturnsEmptyArray_WhenNoConsentsFound() {
        givenBackendReturns(types: [])
        whenFetchingLatestConsents()
        thenARestCallIsMadeTo(expectedUrl: "www.test.com/consent/" + ConsentsClientTest.USER_ID + "?applicationName=" + APPLICATION_NAME + "&propositionName=" + PROPOSITION_NAME, times: 1)
        thenConsentsAreReturned(expectedConsentTypes: [])
        thenServiceDiscoveryIsConsultedForTimes(count: 1, with: "css.consentservice")
    }
    
    func testGetLatestConsent_callsErrorCompletionHandler_WhenServiceDiscoveryFails() {
        givenServiceDiscoveryFails()
        whenFetchingLatestConsents()
        thenErrorCompletionHandlerIsInvoked(withDomain: "ServiceDiscovery", andCode: 500)
    }
    
    func testGetLatestConsentOfType_returnsConsentsOfThatType() {
        givenBackendReturns(types: ["moment", "insight", "someOtherType"])
        whenFetchingLatestConsentOfType(consentType: "moment")
        thenARestCallIsMadeTo(expectedUrl: "www.test.com/consent/" + ConsentsClientTest.USER_ID + "?applicationName=" + APPLICATION_NAME + "&propositionName=" + PROPOSITION_NAME, times: 1)
        thenHeaderIsSent(name: "api-version", value: "1")
        thenHeaderIsSent(name: "Content-Type", value: "application/json")
        thenHeaderIsSent(name: "Authorization", value: "bearer " + ConsentsClientTest.ACCESS_TOKEN)
        thenHeaderIsSent(name: "performerId", value: ConsentsClientTest.USER_ID)
        thenReturnedConsentIs(expectedConsent: "moment")
        thenServiceDiscoveryIsConsultedForTimes(count: 1, with: "css.consentservice")
    }
    
    func testGetLatestConsentOfType_returnsNilIfTypeNotFound() {
        givenBackendReturns(types: ["moment", "insight", "someOtherType"])
        whenFetchingLatestConsentOfType(consentType: "someNonExistingType")
        thenNoConsentIsReturned()
        thenARestCallIsMadeTo(expectedUrl: "www.test.com/consent/" + ConsentsClientTest.USER_ID + "?applicationName=" + APPLICATION_NAME + "&propositionName=" + PROPOSITION_NAME, times: 1)
        thenHeaderIsSent(name: "api-version", value: "1")
        thenHeaderIsSent(name: "Content-Type", value: "application/json")
        thenHeaderIsSent(name: "Authorization", value: "bearer " + ConsentsClientTest.ACCESS_TOKEN)
        thenHeaderIsSent(name: "performerId", value: ConsentsClientTest.USER_ID)
        thenServiceDiscoveryIsConsultedForTimes(count: 1, with: "css.consentservice")
    }
    
    func testGetLatestConsentOfType_returnsErrorWithHttpStatusCode() {
        givenBackendReturns(inData: "<invalid_JSON>", status: 404, error: nil)
        whenFetchingLatestConsentOfType(consentType: "insights")
        thenErrorCompletionHandlerIsInvoked(withDomain: "An unknown error occurred", andCode: 404)
    }
    
    func testGetLatestConsentOfType_returnsErrorWhenServerRespondsWith200_butUnexpectedJson() {
        givenBackendReturns(inData: "{}", status: 200, error: nil)
        whenFetchingLatestConsentOfType(consentType: "insights")
        thenErrorCompletionHandlerIsInvoked(withDomain: "An unknown error occurred", andCode: 200)
    }
    
    func testGetLatestConsentOfType_returnsErrorWhenServerRespondsWith200_butInvalidJson() {
        givenBackendReturns(inData: "<invalid_json>", status: 200, error: nil)
        whenFetchingLatestConsentOfType(consentType: "insights")
        thenErrorCompletionHandlerIsInvoked(withDomain: "An unknown error occurred", andCode: 200)
    }
    
    func testGetLatestConsentOfType_retriesOn1008ErrorCode() {
        givenBackendReturns(inData: "{\"incidentID\":\"any\",\"errorCode\": 1008,\"description\":\"Access Token Expired\"}", status: 401, error: nil)
        given(onTokenRefresh: {
            self.givenBackendReturns(types: ["moment", "insight", "someOtherType"])
        })
        whenFetchingLatestConsentOfType(consentType: "insight")
        thenARestCallIsMadeTo(expectedUrl: "www.test.com/consent/" + ConsentsClientTest.USER_ID + "?applicationName=" + APPLICATION_NAME + "&propositionName=" + PROPOSITION_NAME, times: 2)
        thenTokenIsRefreshed()
        thenReturnedConsentIs(expectedConsent: "insight")
        thenErrorCompletionIsNotCalled()
    }
    
    func testGetLatestConsentOfType_returnsErrorWhenTokenRefreshFails() {
        givenBackendReturns(inData: "{\"incidentID\":\"any\",\"errorCode\": 1008,\"description\":\"Invalid Access Token\"}", status: 401, error: nil)
        givenTokenRefreshFails()
        whenFetchingLatestConsentOfType(consentType: "insight")
        thenARestCallIsMadeTo(expectedUrl: "www.test.com/consent/" + ConsentsClientTest.USER_ID + "?applicationName=" + APPLICATION_NAME + "&propositionName=" + PROPOSITION_NAME, times: 1)
        thenTokenIsRefreshed()
        thenErrorCompletionHandlerIsInvoked(withDomain: "TokenRefreshFailed", andCode: 104)
    }
    
    func testGetLatestConsentOfType_returnsErrorWithServerResponseCode() {
        givenBackendReturns(inData: "{\"incidentID\":\"any\",\"errorCode\": 1000,\"description\":\"SomeErrorCode\"}", status: 401, error: NSError())
        whenFetchingLatestConsentOfType(consentType: "insights")
        thenErrorCompletionHandlerIsInvoked(withDomain: "SomeErrorCode", andCode: 1000)
    }
    
    func testGetLatestConsentOfTypes_ReturnsConsentsOfThoseTypes() {
        givenBackendReturns(types: ["moment", "insight", "someOtherType"])
        whenFetchingLatestConsentsOfTypes(consentTypes: ["insight", "moment"])
        thenARestCallIsMadeTo(expectedUrl: "www.test.com/consent/" + ConsentsClientTest.USER_ID + "?applicationName=" + APPLICATION_NAME + "&propositionName=" + PROPOSITION_NAME, times: 1)
        thenHeaderIsSent(name: "api-version", value: "1")
        thenHeaderIsSent(name: "Content-Type", value: "application/json")
        thenHeaderIsSent(name: "Authorization", value: "bearer " + ConsentsClientTest.ACCESS_TOKEN)
        thenHeaderIsSent(name: "performerId", value: ConsentsClientTest.USER_ID)
        thenConsentsAreReturned(expectedConsentTypes: ["insight", "moment"])
        thenServiceDiscoveryIsConsultedForTimes(count: 1, with: "css.consentservice")
    }
    
    func testGetLatestConsentOfTypes_ReturnsEmptyArrayIfTypesIsEmpty() {
        givenBackendReturns(types: ["moment", "insight", "someOtherType"])
        whenFetchingLatestConsentsOfTypes(consentTypes: [])
        thenConsentsAreReturned(expectedConsentTypes: [])
        thenARestCallIsNotMade()
        thenServiceDiscoveryIsNotConsulted()
    }
    
    func testGetLatestConsentOfTypesReturnsEmptyArrayWhenNoMatchFound() {
        givenBackendReturns(types: ["moment", "insight", "someOtherType"])
        whenFetchingLatestConsentsOfTypes(consentTypes: ["someOtherType1", "someOtherType2"])
        thenARestCallIsMadeTo(expectedUrl: "www.test.com/consent/" + ConsentsClientTest.USER_ID + "?applicationName=" + APPLICATION_NAME + "&propositionName=" + PROPOSITION_NAME, times: 1)
        thenConsentsAreReturned(expectedConsentTypes: [])
        thenServiceDiscoveryIsConsultedForTimes(count: 1, with: "css.consentservice")
    }
    
    func testGetLatestConsentOfTypes_returnsErrorWithHttpStatusCode() {
        givenBackendReturns(inData: "<invalid_JSON>", status: 404, error: nil)
        whenFetchingLatestConsentsOfTypes(consentTypes: ["insights"])
        thenErrorCompletionHandlerIsInvoked(withDomain: "An unknown error occurred", andCode: 404)
    }
    
    func testGetLatestConsentOfTypes_returnsErrorWhenServerRespondsWith200_butUnexpectedJson() {
        givenBackendReturns(inData: "{}", status: 200, error: nil)
        whenFetchingLatestConsentsOfTypes(consentTypes: ["insights"])
        thenErrorCompletionHandlerIsInvoked(withDomain: "An unknown error occurred", andCode: 200)
    }
    
    func testGetLatestConsentOfTypes_returnsErrorWhenServerRespondsWith200_butInvalidJson() {
        givenBackendReturns(inData: "<invalid>", status: 200, error: nil)
        whenFetchingLatestConsentsOfTypes(consentTypes: ["insights"])
        thenErrorCompletionHandlerIsInvoked(withDomain: "An unknown error occurred", andCode: 200)
    }
    
    func testGetLatestConsentOfTypes_returnsServerErrorWithoutData() {
        givenBackendReturnsEmptyData(status: 400, error: nil)
        whenFetchingLatestConsentsOfTypes(consentTypes: ["insights"])
        thenErrorCompletionHandlerIsInvoked(withDomain: "An unknown error occurred", andCode: CATKConsentClientErrorContainer.unknownErrorCode)
    }
    
    func testGetLatestConsentOfTypes_returnsErrorWithServerResponseCode() {
        givenBackendReturns(inData: "{\"incidentID\":\"any\",\"errorCode\": 1000,\"description\":\"SomeErrorCode\"}", status: 401, error: NSError())
        whenFetchingLatestConsentsOfTypes(consentTypes: ["insights"])
        thenErrorCompletionHandlerIsInvoked(withDomain: "SomeErrorCode", andCode: 1000)
    }
    
    func testGetLatestConsentOfTypes_retriesOn1008ErrorCode() {
        givenBackendReturns(inData: "{\"incidentID\":\"any\",\"errorCode\": 1008,\"description\":\"Access Token Expired\"}", status: 401, error: nil)
        given(onTokenRefresh: {
            self.givenBackendReturns(types: ["moment", "insight", "someOtherType"])
        })
        whenFetchingLatestConsentsOfTypes(consentTypes: ["insight"])
        thenARestCallIsMadeTo(expectedUrl: "www.test.com/consent/" + ConsentsClientTest.USER_ID + "?applicationName=" + APPLICATION_NAME + "&propositionName=" + PROPOSITION_NAME, times: 2)
        thenHeaderIsSent(name: "Authorization", value: "bearer " + ConsentsClientTest.REFRESHED_ACCESS_TOKEN)
        thenTokenIsRefreshed()
        thenConsentsAreReturned(expectedConsentTypes: ["insight"])
        thenErrorCompletionIsNotCalled()
    }
    
    func testGetLatestConsentOfTypes_returnsErrorWhenTokenRefreshFails() {
        givenBackendReturns(inData: "{\"incidentID\":\"any\",\"errorCode\": 1008,\"description\":\"Invalid Access Token\"}", status: 401, error: nil)
        givenTokenRefreshFails()
        whenFetchingLatestConsentsOfTypes(consentTypes: ["insight"])
        thenARestCallIsMadeTo(expectedUrl: "www.test.com/consent/" + ConsentsClientTest.USER_ID + "?applicationName=" + APPLICATION_NAME + "&propositionName=" + PROPOSITION_NAME, times: 1)
        thenTokenIsRefreshed()
        thenErrorCompletionHandlerIsInvoked(withDomain: "TokenRefreshFailed", andCode: 104)
    }
    
    func testPostsConsent() {
        givenBackendReturns(inData:  "", status: 201, error: nil)
        whenAddingConsents(consent: consent)
        thenARestCallIsMadeTo(expectedUrl: "www.test.com/consent", times: 1)
        thenServiceDiscoveryIsConsultedForTimes(count: 1, with: "css.consentservice")
        thenHeaderIsSent(name: "api-version", value: "1")
        thenHeaderIsSent(name: "Content-Type", value: "application/json")
        thenHeaderIsSent(name: "Authorization", value: "bearer " + ConsentsClientTest.ACCESS_TOKEN)
        thenHeaderIsSent(name: "performerId", value: ConsentsClientTest.USER_ID)
        thenBodyIsSent(with: "\"language\":\"en-GB\"")
        thenBodyIsSent(with: "\"status\":\"active\"")
        thenBodyIsSent(with: "\"resourceType\":\"Consent\"")
        thenBodyIsSent(with: "\"policyRule\":\"urn:com.philips.consent:moment\\/US\\/0\\/OneBackendProp\\/OneBackend\"")
        thenBodyIsSent(with: "\"subject\":\"uuid\"")
        thenCompletionHandlerIsCalled()
    }
    
    func testAddConsent_returnsErrorWithServerResponseCode() {
        givenBackendReturns(inData: "{\"incidentID\":\"any\",\"errorCode\": 1000,\"description\":\"SomeErrorCode\"}", status: 401, error: nil)
        whenAddingConsents(consent: consent)
        thenErrorCompletionHandlerIsInvoked(withDomain: "SomeErrorCode", andCode: 1000)
    }
    
    func testAddConsent_retriesOn1008ErrorCode() {
        givenBackendReturns(inData: "{\"incidentID\":\"any\",\"errorCode\": 1008,\"description\":\"Access Token Expired\"}", status: 401, error: nil)
        given(onTokenRefresh: {
            self.givenBackendReturns(inData: "", status: 201, error: nil)
        })
        whenAddingConsents(consent: consent)
        thenTokenIsRefreshed()
        thenARestCallIsMadeTo(expectedUrl: "www.test.com/consent", times: 2)
        thenHeaderIsSent(name: "Authorization", value: "bearer " + ConsentsClientTest.REFRESHED_ACCESS_TOKEN)
        thenErrorCompletionIsNotCalled()
    }
    
    func testAddConsent_retriesOnlyTwiceOn1008ErrorCode() {
        givenBackendReturns(inData: "{\"incidentID\":\"any\",\"errorCode\": 1008,\"description\":\"Access Token Expired\"}", status: 401, error: nil)
        given(onTokenRefresh: {
            self.givenBackendReturns(inData: "{\"incidentID\":\"any\",\"errorCode\": 1008,\"description\":\"Access Token Expired\"}", status: 401, error: nil)
        })
        whenAddingConsents(consent: consent)
        thenTokenIsRefreshed()
        thenHeaderIsSent(name: "Authorization", value: "bearer " + ConsentsClientTest.REFRESHED_ACCESS_TOKEN)
        thenErrorCompletionHandlerIsInvoked(withDomain: "TokenRefreshFailed", andCode: 104)
        thenRetryCalledTwice()
    }
    
    func testGetLatestConsent_callsErrorCompletionHandler_WhenServiceDiscoveryReturnsNilURL() {
        givenServiceDiscoveryReturnsEmptyURL()
        whenFetchingLatestConsents()
        thenErrorCompletionHandlerIsInvoked(withDomain: "Empty base url from service discovery", andCode: 111002)
    }
    
    func testAddConsent_returnsErrorWhenTokenRefreshFails() {
        givenBackendReturns(inData: "{\"incidentID\":\"any\",\"errorCode\": 1008,\"description\":\"Invalid Access Token\"}", status: 401, error: nil)
        givenTokenRefreshFails()
        whenAddingConsents(consent: consent)
        thenARestCallIsMadeTo(expectedUrl: "www.test.com/consent", times: 1)
        thenTokenIsRefreshed()
        thenErrorCompletionHandlerIsInvoked(withDomain: "TokenRefreshFailed", andCode: 104)
    }
    
    func testAddConsent_callsErrorCompletionHandler_WhenServiceDiscoveryReturnsNilURL() {
        givenServiceDiscoveryReturnsEmptyURL()
        whenAddingConsents(consent: consent)
        thenErrorCompletionHandlerIsInvoked(withDomain: "Empty base url from service discovery", andCode: 111002)
    }
    
    private func given(onTokenRefresh: @escaping() -> Void) {
        userData.onTokenRefresh = onTokenRefresh
    }
    
    private func givenServiceDiscoveryFails() {
        serviceDiscovery.failedserviceDiscovery = true
    }
    private func givenServiceDiscoveryReturnsEmptyURL() {
        serviceDiscovery.serviceDiscoveryReturnsEmptyURL = true
    }
    
    private func givenTokenRefreshFails() {
        userData.setTokenRefreshToFail()
    }
    
    private func givenBackendReturns(inData: String, status: Int, error: NSError?) {
        let response = HTTPURLResponse(url: URL(string: "http://google.com")!, statusCode: status, httpVersion: nil, headerFields: nil)
        testCommunicator.responseToReturn = ConsentServiceResponseHolder(inData: inData.data(using: .utf8)!, inResponse: response!, inError: error)
    }
    
    private func givenBackendReturnsEmptyData(status: Int, error: NSError?) {
        let response = HTTPURLResponse(url: URL(string: "http://google.com")!, statusCode: status, httpVersion: nil, headerFields: nil)
        testCommunicator.responseToReturn = ConsentServiceResponseHolder(inData: nil, inResponse: response!, inError: error)
    }
    
    private func givenBackendReturns(types : [String]) {
        var responseString = "["
        for type in types {
            responseString += "{\"dateTime\": \"2017-11-01T21:02:38.000Z\",\"language\":\"en-US\",\"status\":\"active\",\"resourceType\":\"Consent\",\"policyRule\":\"urn:com.philips.consent:" + type + "\\/US\\/0\\/propName\\/appName\",\"subject\":\"uuid\"},"
        }
        responseString += "]"
        let response = HTTPURLResponse(url: URL(string: "http://google.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        testCommunicator.responseToReturn = ConsentServiceResponseHolder(inData: responseString.data(using: .utf8)!, inResponse : response!, inError : nil)
    }
    
    private func whenFetchingLatestConsentOfType(consentType: String) {
        consentsClient.fetchLatestConsentsOfType(type: consentType,
                                                 completion: {consent, error in
                                                    if error != nil {
                                                        self.returnedError = error
                                                    }
                                                    self.returnedConsent = consent as! CATKConsent?
        })
    }
    
    private func whenFetchingLatestConsentsOfTypes(consentTypes: [String]) {
        self.consentsClient.fetchLatestConsentsOfTypes(types: consentTypes, completion: {consents, error in
            if error != nil {
                self.errorCompletionCalled = true
                self.returnedError = error
            } else {
                self.returnedConsents = consents as? [CATKConsent]
            }})
    }
    
    func whenFetchingLatestConsents() {
        consentsClient.fetchLatestConsents(
            completion: {consents, error in
                if error != nil {
                    self.errorCompletionCalled = true
                    self.returnedError = error
                } else {
                    self.returnedConsents = consents as? [CATKConsent]
                }
        })
    }
    
    private func whenAddingConsents(consent: CATKConsent) {
        self.consentsClient.addConsents(consent: consent, completion: { success, error in
            if (error != nil) {
                self.errorCompletionCalled = true
                self.returnedError = error;
            } else {
                self.completionCalled = true
            }
        })
    }
    
    private func thenErrorCompletionIsNotCalled() {
        XCTAssertFalse(errorCompletionCalled)
    }
    
    private func thenARestCallIsMadeTo(expectedUrl: String, times: Int) {
        XCTAssertEqual(expectedUrl, self.testCommunicator.executedRequest!.url?.absoluteString)
        XCTAssertEqual(times, self.testCommunicator.requestCount)
    }
    
    private func thenARestCallIsNotMade() {
        XCTAssertNil(self.testCommunicator.executedRequest)
        XCTAssertEqual(0, self.testCommunicator.requestCount)
    }
    
    private func thenHeaderIsSent(name: String, value: String) {
        let request = testCommunicator.executedRequest!
        XCTAssertEqual(value, request.allHTTPHeaderFields![name])
    }
    
    private func thenReturnedConsentIs(expectedConsent: String) {
        XCTAssertEqual(expectedConsent, returnedConsent?.consentType)
    }
    
    private func thenConsentsAreReturned(expectedConsentTypes: [String]) {
        XCTAssertEqual(expectedConsentTypes.count, returnedConsents?.count)
        guard expectedConsentTypes.count > 0 else { return }
        for i in 0...expectedConsentTypes.count-1 {
            XCTAssertEqual(expectedConsentTypes[i], returnedConsents?[i].consentType)
        }
    }
    
    private func thenIsSubscribedForTokenRefreshEvents() {
        XCTAssertTrue(userData.subscribedForTokenRefreshSuccessEvents)
    }
    
    private func thenBodyIsSent(with expectedBody : String){
        let request = testCommunicator.executedRequest!
        let decodedData = Data(base64Encoded: request.httpBody!.base64EncodedString())!
        let decodedString = String(data: decodedData, encoding: .utf8)!
        XCTAssertTrue(decodedString.contains(expectedBody))
    }
    
    private func thenCompletionHandlerIsCalled() {
        XCTAssertTrue(completionCalled)
    }
    
    private func thenNoConsentIsReturned() {
        XCTAssertNil(returnedConsent)
    }
    
    private func thenErrorCompletionHandlerIsInvoked(withDomain domain: String, andCode code: Int) {
        XCTAssertEqual(domain, self.returnedError!.domain)
        XCTAssertEqual(code, self.returnedError!.code)
    }
    
    private func thenServiceDiscoveryIsConsultedForTimes(count: Int, with: String) {
        XCTAssertEqual(count, serviceDiscovery.getServiceUrlInvokedCount)
        XCTAssertEqual(with, serviceDiscovery.getServiceUrlInvokedServiceId!)
    }
    
    private func thenServiceDiscoveryIsNotConsulted() {
        XCTAssertEqual(0, serviceDiscovery.getServiceUrlInvokedCount)
        XCTAssertNil(serviceDiscovery.getServiceUrlInvokedServiceId)
    }
    
    private func thenTokenIsRefreshed() {
        while !userData.tokenRefreshed {
            sleep(1)
        }
        XCTAssertTrue(userData.tokenRefreshed)
    }
    
    private func thenRetryCalledTwice(){
        XCTAssertEqual(2, consentsClient.fetchConsentRetryCount)
    }
    
    
    private func getJsonObject(type : String) -> Dictionary<String, String> {
        var jsonObject: Dictionary<String, String> = Dictionary<String,String>()
        jsonObject["dateTime"] = "2017-10-17T09:33:59.000Z"
        jsonObject["language"] = "af-ZA"
        jsonObject["policyRule"] = "urn:com.philips.consent:" + type + "/IN/0/OneBackendProp/OneBackend"
        jsonObject["resourceType"] = "Consent"
        jsonObject["status"] = "inactive"
        jsonObject["subject"] = "17f7ce85-403c-4824-a17f-3b551f325ce0"
        return jsonObject
    }
    
    class TestUserData : NSObject, UserDataInterface {
        public var consentsClient: ConsentsClient?
        public var tokenRefreshed = false
        public var subscribedForTokenRefreshSuccessEvents = true
        public var onTokenRefresh: (() -> Void)?
        private var accessToken = ConsentsClientTest.ACCESS_TOKEN
        private var tokenRefreshFails = false
        
        
        func logoutSession() {
            
        }
        
        func refreshSession() {
            accessToken = ConsentsClientTest.REFRESHED_ACCESS_TOKEN
            if (self.onTokenRefresh != nil) {
                self.onTokenRefresh!()
            }
            if (self.tokenRefreshFails) {
                self.consentsClient!.refreshSessionFailed(NSError(domain: "", code: 104, userInfo: nil))
            } else {
                self.consentsClient!.refreshSessionSuccess()
            }
            self.tokenRefreshed = true
        }
        
        func refetchUserDetails() {
            
        }
        
        func updateUserDetails(_ fields: Dictionary<String, AnyObject>) {
            
        }
        
        func userDetails(_ fields: Array<String>?) throws -> Dictionary<String, AnyObject> {
            return [:]
        }
        
        func authorizeLoginToHSDP(withCompletion completion: @escaping (Bool, Error?) -> Void) {
            
        }
        
        func isUserLoggedIn() -> Bool {
            return true
        }
        
        func loggedInState() -> URLoggedInState {
            return URLoggedInState.userLoggedIn
        }
        
        var janrainAccessToken: String?
        
        var hsdpAccessToken: String? {
            return accessToken
        }
        
        var janrainUUID: String?
        
        var hsdpUUID: String? = ConsentsClientTest.USER_ID
        
        func addUserDataInterfaceListener(_ listener: USRUserDataDelegate) {
            
        }
        
        func removeUserDataInterfaceListener(_ listener: USRUserDataDelegate) {
            
        }
        
        public func setTokenRefreshToFail() {
            self.tokenRefreshFails = true
        }
    }
}

