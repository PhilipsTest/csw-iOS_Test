//
//  ConsentInteractorTest.swift
//  ConsentWidgetsTests
//
//  Copyright © 2017 Philips. All rights reserved.
//

import XCTest
import ConsentAccessToolKit
import PlatformInterfaces
import AppInfra

@testable import ConsentAccessToolKit

class ConsentInteractorTest: XCTestCase {
    
    let rejectedMomentConsentV0 = ConsentInteractorTest.getCATKConsentOfType(type: "moment", status: ConsentStates.rejected, withVersion: "0", country: "NL")
    let inactiveMomentConsentV0 = ConsentInteractorTest.getCATKConsentOfType(type: "moment", status: ConsentStates.inactive, withVersion: "0", country: "NL")
    let activeMomentConsentV0 = ConsentInteractorTest.getCATKConsentOfType(type: "moment", status: ConsentStates.active, withVersion: "0", country: "NL")
    let activeMomentConsentV1 = ConsentInteractorTest.getCATKConsentOfType(type: "moment", status: ConsentStates.active, withVersion: "1", country: "NL")
    let activeInsightConsentV1 = ConsentInteractorTest.getCATKConsentOfType(type: "insight", status: ConsentStates.active, withVersion: "1", country: "NL")
    let activeInsightConsentV2 = ConsentInteractorTest.getCATKConsentOfType(type: "insight", status: ConsentStates.active, withVersion: "2", country: "NL")
    let momentConsentV0 = ConsentInteractorTest.getCATKConsentOfType(type: "moment", withVersion: "0", country: "NL")
    let insightConsentV0 = ConsentInteractorTest.getCATKConsentOfType(type: "insight", status: ConsentStates.active, withVersion: "0", country: "NL")
    let inactiveInsightConsentV0 = ConsentInteractorTest.getCATKConsentOfType(type: "insight", status: ConsentStates.inactive, withVersion: "0", country: "NL")
    let momentConsentV1 = ConsentInteractorTest.getCATKConsentOfType(type: "moment", withVersion: "1", country: "NL")
    let insightConsentV1 = ConsentInteractorTest.getCATKConsentOfType(type: "insight", withVersion: "1", country: "NL")
    let momentConsentVersionString = ConsentInteractorTest.getCATKConsentOfType(type: "moment", withVersion: "s", country: "NL")
    var consentsNotGiven: [ConsentDefinitionStatus]?
    var outdatedConsents: [ConsentDefinitionStatus]?
    var consentsNotGivenError: Bool = false
    
    let userData = TestUserData()
    let serviceDiscovery = TestAIServiceDiscoveryProtocol()
    var consentsClient : ConsentsClientMock!
    var consentInteractor : ConsentInteractor!
    var consentsReturned : [ConsentDefinitionStatus]?
    var consentReturned : ConsentStatus?
    var consentStatusListReturned: [ConsentDefinitionStatus]?
    var errorReturned : NSError?
    var error: NSError?
    var postCompletionHandlerCount = 0
    var postSuccess : Bool = false
    var consentCacheInteractorMock: ConsentCacheInteractorMock!
    let expectedDate = Date(timeIntervalSince1970: 12345)
    enum Constants {
        static let HOME_COUNTRY = "NL"
        static let VERSION_MISMATCH_ERROR = 1252
    }
    var catkInputs: CATKInputs!
    let localisationMock = AppInfraLocalisationMock()
    let restClientMock = AppInfraRestClientMock()
    
    override public func setUp() {
        super.setUp()
        
        self.catkInputs = CATKInputs(logging: AppInfraLoggingMock(),
                                     restClient: restClientMock,
                                     serviceDiscovery: serviceDiscovery,
                                     internationalization: localisationMock,
                                     appConfig: AppConfig(consentCacheTTL: 3, hsdpAppName: "testApp", hsdpPropName: "propositionTest"),
                                     consentManager: ConsentManagerMock(),
                                     userData: UserDataMock())
        
        ConsentServiceURHandler.sharedInstance.userData = userData
        consentsClient = ConsentsClientMock()
        continueAfterFailure = false
        postCompletionHandlerCount = 0
        error = NSError(domain: "oops!", code: 1039, userInfo: nil)
        self.consentCacheInteractorMock = ConsentCacheInteractorMock()
        self.consentInteractor = ConsentInteractor(consentsClient: consentsClient, catkInputs: catkInputs, consentCacheInteractor: consentCacheInteractorMock)
        
    }
    
    func testFetchConsentReturnsErrorWhenUserIsLoggedOut() {
        let expectedError = NSError(domain: CATKConstants.ConsentServiceErrorDomain.FetchConsentTypeError, code: CATKConstants.ConsentServiceErrorCode.UserNotLoggedInErrorCode, userInfo: nil)
        givenUserLoggedInStateIs(URLoggedInState.userNotLoggedIn)
        whenFetchingLatestConsent(forConsentType: "moment")
        thenCompletionHandlerIsCalledWith(expectedConsent: nil, expectedError: expectedError)
    }
    
    func testFetchConsentByTypeReturnsError() {
        let errorToReturn = NSError(domain: "Sample", code: 1000, userInfo: nil)
        givenConsentsClientReturns(consent: momentConsentV0, error: errorToReturn)
        whenFetchingLatestConsent(forConsentType: "moment")
        thenConsentDefinitionStatusCompletionHandlerIsCalledWith(expectedError: errorToReturn)
    }
    
    func testFetchConsentReturnsCATKConsentWithVersionProblem() {
        let errorToReturn = NSError(domain: CATKConstants.ConsentServiceErrorDomain.FetchConsentTypeError, code: CATKConstants.ConsentServiceErrorCode.FetchConsentTypeVersionErrorCode, userInfo: [NSLocalizedDescriptionKey: "CATK_PROBLEM_OCCURED".localized])
        givenConsentsClientReturns(consent: momentConsentVersionString, error: nil)
        whenFetchingLatestConsent(forConsentType: "moment")
        thenConsentDefinitionStatusCompletionHandlerIsCalledWith(expectedError: errorToReturn)
    }

    public func testFetchConsentByType() {
        givenConsentsClientReturns(consent: momentConsentV0, error: nil)
        whenFetchingLatestConsent(forConsentType: "moment")
        thenConsentIsFetchedWith(expectedType : "moment")
        thenCompletionHandlerIsCalledWith(expectedConsent : getConsentDefinitionState(status: momentConsentV0.status, versionStatus:0, timeStamp: expectedDate))
    }

    public func testFetchConsentByType_fetchesFromCache() {
        
        let cachedConsent = CachedConsentStatus(status: ConsentStates.active, version:0, expiresOn:  Date() + TimeInterval(3 * 60), timestamp: Date(timeIntervalSince1970: 0))
        givenConsentCacheInteractorReturns(cachedConsentStatus: cachedConsent)
        whenFetchingLatestConsent(forConsentType: "moment")
        thenConsentCacheFetchWasCalled(for: "moment")
        thenCompletionHandlerIsCalledWith(expectedConsent : getConsentDefinitionState(status: ConsentStates.active, versionStatus:0, timeStamp: expectedDate))
    }
    
    public func testFetchConsentByType_fetchesFromBackendIfCacheExpired() {
        let cachedConsent = CachedConsentStatus(status: ConsentStates.active, version:0, expiresOn:  Date(), timestamp: Date(timeIntervalSince1970: 0))
        givenConsentCacheInteractorReturns(cachedConsentStatus: cachedConsent)
        givenConsentsClientReturns(consent: momentConsentV0, error: nil)
        whenFetchingLatestConsent(forConsentType: "moment")
        thenConsentCacheFetchWasCalled(for: "moment")
        thenConsentIsFetchedWith(expectedType : "moment")
        thenCompletionHandlerIsCalledWith(expectedConsent : getConsentDefinitionState(status: momentConsentV0.status, versionStatus:0, timeStamp: expectedDate))
    }
    
    public func testFetchConsentByType_returnsFromCacheIfInternetUnreachable() {
        givenInternetReachable(status: false)
        let cachedConsent = CachedConsentStatus(status: ConsentStates.rejected, version:1, expiresOn: Date() - TimeInterval(5 * 60), timestamp: Date(timeIntervalSince1970: 0))
        givenConsentCacheInteractorReturns(cachedConsentStatus:cachedConsent)
        whenFetchingLatestConsent(forConsentType: "moment")
        thenConsentCacheFetchWasCalled(for: "moment")
        thenCompletionHandlerIsCalledWith(expectedConsent : getConsentDefinitionState(status: ConsentStates.rejected, versionStatus:1, timeStamp: expectedDate))
        thenFetchFromBackendIsNotCalled()
    }
    
    public func testFetchConsentByType_fetchesFromBackendIfCacheExpired_AndStoresInCache() {
        let cachedConsent = CachedConsentStatus(status: ConsentStates.rejected, version:1, expiresOn:  Date(), timestamp: Date(timeIntervalSince1970: 0))
        givenConsentCacheInteractorReturns(cachedConsentStatus: cachedConsent)
        givenConsentsClientReturns(consent: insightConsentV1, error: nil)
        whenFetchingLatestConsent(forConsentType: "insight")
        thenConsentCacheFetchWasCalled(for: "insight")
        thenConsentIsFetchedWith(expectedType : "insight")
        thenCompletionHandlerIsCalledWith(expectedConsent : getConsentDefinitionState(status: insightConsentV1.status, versionStatus:1, timeStamp: expectedDate))
        thenConsentCachePostWasCalled(with: "insight", status: ConsentStates.rejected, version: 1)
    }
    
    public func testFetchConsentByType_fetchesFromBackendIfCacheExpired_AndDoesNotStoreInCacheIfBackendReturnsNil() {
        let errorToReturn = NSError(domain: "Sample", code: 1000, userInfo: nil)
        givenConsentsClientReturns(consent: momentConsentV0, error: errorToReturn)
        let cachedConsent = CachedConsentStatus(status: ConsentStates.rejected, version:1, expiresOn:  Date(), timestamp: Date(timeIntervalSince1970: 0))
        givenConsentCacheInteractorReturns(cachedConsentStatus: cachedConsent)
        whenFetchingLatestConsent(forConsentType: "insight")
        thenConsentCacheFetchWasCalled(for: "insight")
        thenConsentIsFetchedWith(expectedType : "insight")
        thenConsentDefinitionStatusCompletionHandlerIsCalledWith(expectedError: errorToReturn)
        thenConsentCachePostWasNotCalled()
    }

    public func testFetchConsentByType_WithInactiveConsent() {
        givenConsentsClientReturns(consent: inactiveMomentConsentV0, error: nil)
        whenFetchingLatestConsent(forConsentType: "moment")
        thenConsentIsFetchedWith(expectedType : "moment")
        thenCompletionHandlerIsCalledWith(expectedConsent : getConsentDefinitionState(status: ConsentStates.inactive, versionStatus: 0, timeStamp: expectedDate))
    }
    
    public func testFetchConsentByType_WithRejectedConsent() {
        givenConsentsClientReturns(consent: rejectedMomentConsentV0, error: nil)
        whenFetchingLatestConsent(forConsentType: "moment")
        thenConsentIsFetchedWith(expectedType : "moment")
        thenCompletionHandlerIsCalledWith(expectedConsent : getConsentDefinitionState(status: ConsentStates.rejected, versionStatus: 0, timeStamp: expectedDate))
    }
    
    public func testFetchConsentByType_SetsFlagForDeprecatedConsents() {
        givenConsentsClientReturns(consent: momentConsentV1, error: nil)
        whenFetchingLatestConsent(forConsentType: "moment")
        thenConsentIsFetchedWith(expectedType : "moment")
        thenCompletionHandlerIsCalledWith(expectedConsent : getConsentDefinitionState(status: momentConsentV1.status, versionStatus: 1, timeStamp: expectedDate))
    }

    public func testFetchConsentByType_ReturnsInactiveWhenNoConsentOnBackend() {
        givenConsentsClientReturns(consent: nil, error: nil)
        whenFetchingLatestConsent(forConsentType: "moment")
        thenCompletionHandlerIsCalledWith(expectedConsent : getConsentDefinitionState(status: ConsentStates.inactive, versionStatus: 0, timeStamp: expectedDate))
    }

    public func testFetchConsentsByType_ErrorScenario() {
        givenConsentsClientReturns(consents: nil, error: NSError(domain: "domain", code: 100))
        whenFetchingLatestConsent(forConsentType: "moment")
        thenConsentIsFetchedWith(expectedType : "moment")
        thenCompletionHandlerIsCalledWith(expectedConsent: nil, expectedError:  NSError(domain: "domain", code: 100))
    }
    
    func testConsentTypePostingWithRejected() {
        givenServiceDiscoveryReturnsHomeCountry(Constants.HOME_COUNTRY)
        givenInternationalisation(setToObject: localisationMock)
        whenPosting(consentType: "moment", andStatus: false, version: 0)
        thenConsentIsPosted(expectedConsent: ConsentInteractorTest.getCATKConsentOfType(type: "moment", status: ConsentStates.rejected, withVersion: "0", country: Constants.HOME_COUNTRY))
    }
    
    func testConsentTypePostingWithActive() {
        givenServiceDiscoveryReturnsHomeCountry(Constants.HOME_COUNTRY)
        givenInternationalisation(setToObject: localisationMock)
        whenPosting(consentType: "moment", andStatus: true, version: 0)
        thenConsentIsPosted(expectedConsent: ConsentInteractorTest.getCATKConsentOfType(type: "moment", status: ConsentStates.active, withVersion: "0", country: Constants.HOME_COUNTRY))
    }
    
    func testConsentTypePostingWitActiveStatus_EmptyLocale() {
        let errorToReturn = NSError(domain: CATKConstants.ConsentServiceErrorDomain.StoreConsentTypeError, code: CATKConstants.ConsentServiceErrorCode.StoreConsentTypeLocaleErrorCode, userInfo: [NSLocalizedDescriptionKey : "CATK_PROBLEM_OCCURED".localized])
        givenServiceDiscoveryReturnsHomeCountry(Constants.HOME_COUNTRY)
        givenInternationalisation(setToObject: nil)
        whenPosting(consentType: "moment", andStatus: true, version: 0)
        thenConsentIsPosted(withError: errorToReturn)
    }
    
    func testConsentTypePostingWitRejectedStatus_EmptyLocale() {
        let errorToReturn = NSError(domain: CATKConstants.ConsentServiceErrorDomain.StoreConsentTypeError, code: CATKConstants.ConsentServiceErrorCode.StoreConsentTypeLocaleErrorCode, userInfo: [NSLocalizedDescriptionKey : "CATK_PROBLEM_OCCURED".localized])
        givenServiceDiscoveryReturnsHomeCountry(Constants.HOME_COUNTRY)
        givenInternationalisation(setToObject: nil)
        whenPosting(consentType: "moment", andStatus: false, version: 0)
        thenConsentIsPosted(withError: errorToReturn)
    }
    
    func testConsentTypePostingWithActiveStatus_ErrorScenario() {
        let errorToReturn = NSError(domain: CATKConstants.ConsentServiceErrorDomain.StoreConsentTypeError, code: CATKConstants.ConsentServiceErrorCode.StoreConsentTypeNoInternetErrorCode, userInfo: nil)
        givenClientReturnsOnPost(error: errorToReturn)
        givenServiceDiscoveryReturnsHomeCountry(Constants.HOME_COUNTRY)
        givenInternationalisation(setToObject: localisationMock)
        whenPosting(consentType: "moment", andStatus: true, version: 0)
        thenConsentIsPosted(withError: errorToReturn)
    }
    
    func testConsentTypePostingWithActiveStatus_NoInternetErrorScenario() {
        givenInternetReachable(status: false)
        let errorToReturn = NSError(domain: CATKConstants.ConsentServiceErrorDomain.StoreConsentTypeError, code: CATKConstants.ConsentServiceErrorCode.StoreConsentTypeNoInternetErrorCode, userInfo: [NSLocalizedDescriptionKey: "CATK_NO_INTERNET_CONNECTION_KEY".localized])
        givenClientReturnsOnPost(error: errorToReturn)
        givenServiceDiscoveryReturnsHomeCountry(Constants.HOME_COUNTRY)
        givenInternationalisation(setToObject: localisationMock)
        whenPosting(consentType: "moment", andStatus: true, version: 0)
        thenConsentIsPosted(withError: errorToReturn)
    }
    
    func testConsentTypePostingWithInActiveStatus_NoInternetErrorScenario() {
        givenInternetReachable(status: false)
        let errorToReturn = NSError(domain: CATKConstants.ConsentServiceErrorDomain.StoreConsentTypeError, code: CATKConstants.ConsentServiceErrorCode.StoreConsentTypeNoInternetErrorCode, userInfo: [NSLocalizedDescriptionKey: "CATK_NO_INTERNET_CONNECTION_KEY".localized])
        givenClientReturnsOnPost(error: errorToReturn)
        givenServiceDiscoveryReturnsHomeCountry(Constants.HOME_COUNTRY)
        givenInternationalisation(setToObject: localisationMock)
        whenPosting(consentType: "moment", andStatus: true, version: 0)
        thenConsentIsPosted(withError: errorToReturn)
    }
        
    func testConsentTypePostingWithRejectedStatus_ErrorScenario() {
        let errorToReturn = NSError(domain: CATKConstants.ConsentServiceErrorDomain.StoreConsentTypeError, code: CATKConstants.ConsentServiceErrorCode.StoreConsentTypeLocaleErrorCode, userInfo: nil)
        givenClientReturnsOnPost(error: errorToReturn)
        givenServiceDiscoveryReturnsHomeCountry(Constants.HOME_COUNTRY)
        givenInternationalisation(setToObject: localisationMock)
        whenPosting(consentType: "moment", andStatus: false, version: 0)
        thenConsentIsPosted(withError: errorToReturn)
    }
    
    func testConsentCacheIsStoredWhenBackendPostSuccessful() {
        givenServiceDiscoveryReturnsHomeCountry(Constants.HOME_COUNTRY)
        givenInternationalisation(setToObject: localisationMock)
        whenPosting(consentType: "moment", andStatus: true, version: 0)
        thenConsentIsPosted(expectedConsent: ConsentInteractorTest.getCATKConsentOfType(type: "moment", status: ConsentStates.active, withVersion: "0", country: Constants.HOME_COUNTRY))
        thenConsentCachePostWasCalled(with: "moment", status: ConsentStates.active, version: 0)
    }
    
    func testConsentCacheIsNotStoredWhenBackendPostIsUnSuccessful() {
        let errorToReturn = NSError(domain: CATKConstants.ConsentServiceErrorDomain.StoreConsentTypeError, code: CATKConstants.ConsentServiceErrorCode.StoreConsentTypeLocaleErrorCode, userInfo: nil)
        givenClientReturnsOnPost(error: errorToReturn)
        givenServiceDiscoveryReturnsHomeCountry(Constants.HOME_COUNTRY)
        givenInternationalisation(setToObject: localisationMock)
        whenPosting(consentType: "moment", andStatus: false, version: 0)
        thenConsentIsPosted(withError: errorToReturn)
        thenConsentCachePostWasNotCalled()
    }
    
    func testConsentCacheIsNotStoredWhenBackendPostIsUnSuccessful_WithVersionMismatchError() {
        let versionMismatchError = NSError(domain: CATKConstants.ConsentServiceErrorDomain.StoreConsentTypeError, code: Constants.VERSION_MISMATCH_ERROR, userInfo: nil)
        givenClientReturnsOnPost(error: versionMismatchError)
        givenServiceDiscoveryReturnsHomeCountry(Constants.HOME_COUNTRY)
        givenInternationalisation(setToObject: localisationMock)
        whenPosting(consentType: "moment", andStatus: false, version: 0)
        thenConsentIsPosted(withError: versionMismatchError)
        thenConsentCacheWasClearedFor(consentType: "moment")
    }
    
    public func testFetchConsentsWhichReturnsExpectedTimeStamp() {
        givenConsentsClientReturns(consent: momentConsentV0, error: nil)
        whenFetchingLatestConsent(forConsentType: "moment")
        thenConsentIsFetchedWith(expectedType : "moment")
        thenCompletionHandlerIsCalledWithDateType(expectedConsent: getConsentDefinitionStateWithTimeStamp(status:momentConsentV0.status, versionStatus: 0, timeStamp: Date(timeIntervalSince1970: 0)), expectedError: nil)
    }
    public func testFetchConsentByTypeWithConsentDate() {
        givenConsentsClientReturns(consent: momentConsentV0, error: nil)
        whenFetchingLatestConsent(forConsentType: "moment")
        thenConsentIsFetchedWith(expectedType : "moment")
        thenCompletionHandlerIsCalledWithTimeStamp(expectedConsent : getConsentDefinitionStateWithTimeStamp(status:momentConsentV0.status, versionStatus: 0, timeStamp: Date(timeIntervalSince1970: 0)))
    }
    
    private func givenUserLoggedInStateIs(_ loggedInState: URLoggedInState) {
        userData.loggedInStateToReturn = loggedInState
    }
  
    private func givenClientReturnsOnPost(error: NSError) {
        self.consentsClient.errorOnPost = error
        self.consentsClient.errorOnPostCount = 1
    }

    private func givenServiceDiscoveryReturnsHomeCountry(_ homeCountry: String) {
        serviceDiscovery.getHomeCountry_returns = homeCountry
    }
    
    private func givenInternationalisation(setToObject: AIInternationalizationProtocol?) {
        self.catkInputs.internationalization = setToObject
    }

    
    private func givenConsentsClientReturns(consents: [CATKConsent]?, error : NSError?) {
        if error != nil {
            self.consentsClient.fetchByTypesError = error
            return
        }
        for consent in consents! {
            self.consentsClient.fetchByTypesConsentsToReturn.append(consent)
        }
    }
    
    private func givenConsentsClientReturns(consent: CATKConsent?, error : NSError?) {
        if error != nil {
            self.consentsClient.fetchByTypesError = error
            return
        }
        self.consentsClient.fetchByTypeConsentToReturn = consent
    }
    
    private func givenConsentCacheInteractorReturns(cachedConsentStatus: CachedConsentStatus) {
        self.consentCacheInteractorMock.consentStatusToReturn = cachedConsentStatus
    }
    
    private func whenFetchingLatestConsent(forConsentType consentType : String){
        consentInteractor.fetchConsentTypeState(for: consentType) { consent, error in
            self.consentReturned = consent
            self.errorReturned = error
        }
    }
    
    private func whenPosting(consentType: String, andStatus status: Bool, version: Int){
        consentInteractor.storeConsentState(for: consentType, withStatus: status, withVersion: version, completion : { success, error in
            self.postSuccess = success
            self.errorReturned = error
        })
    }
    
    private func thenCompletionHandlerIsCalledWith(expectedConsent: ConsentStatus?, expectedError: NSError? = nil) {
        if expectedError == nil {
            XCTAssertNil(self.errorReturned)
        } else {
            XCTAssertEqual(expectedError, self.errorReturned)
        }
        if expectedConsent == nil {
            XCTAssertNil(self.consentReturned)
        } else {
            XCTAssertNotNil(self.consentReturned)
            assertConsentState(expectedConsent!, self.consentReturned!)
        }
    }
    
    private func thenCompletionHandlerIsCalledWithTimeStamp(expectedConsent: ConsentStatus?, expectedError: NSError? = nil) {
        if expectedError == nil {
            XCTAssertNil(self.errorReturned)
        } else {
            XCTAssertEqual(expectedError, self.errorReturned)
        }
        if expectedConsent == nil {
            XCTAssertNil(self.consentReturned)
        } else {
            XCTAssertNotNil(self.consentReturned)
            XCTAssertEqual(expectedConsent?.status.rawValue, self.consentReturned?.status.rawValue)
            XCTAssertEqual(expectedConsent?.version, self.consentReturned?.version)
            //XCTAssertEqual(expectedConsent?.timestamp,self.consentReturned?.timestamp )
            XCTAssertTrue(expectedConsent?.timestamp.compare((self.consentReturned?.timestamp)!) == ComparisonResult.orderedSame || expectedConsent?.timestamp.compare((self.consentReturned?.timestamp)!) == ComparisonResult.orderedAscending )
        }
    }

    private func thenConsentDefinitionStatusCompletionHandlerIsCalledWith(expectedError: NSError) {
        XCTAssertEqual(expectedError.domain, self.errorReturned?.domain)
        XCTAssertEqual(expectedError.code, self.errorReturned?.code)
        XCTAssertEqual(expectedError.localizedDescription, self.errorReturned?.localizedDescription)
    }
    
    private func thenConsentIsFetchedWith(expectedType: String){
        XCTAssertEqual(expectedType, consentsClient.fetchByTypeConsentType)
    }
    
    private func thenFetchFromBackendIsNotCalled() {
        XCTAssertNil(consentsClient.fetchByTypeConsentType)
    }
    
    private func thenConsentIsPosted(expectedConsent : CATKConsent) {
        assertConsent(expectedConsent: expectedConsent, lastPostedConsent: self.consentsClient.lastPostedConsent)
        XCTAssertTrue(self.postSuccess)
        XCTAssertNil(self.errorReturned)
    }

    private func thenConsentCachePostWasCalled(with expectedConsentType: String, status expectedStatus: ConsentStates, version expectedVersion: Int) {
        XCTAssertTrue(consentCacheInteractorMock.storedConsentTimesCalled == 1)
        XCTAssertEqual(consentCacheInteractorMock.captured.consentTypePosted, expectedConsentType)
        XCTAssertEqual(consentCacheInteractorMock.captured.statusPosted, expectedStatus)
        XCTAssertEqual(consentCacheInteractorMock.captured.versionPosted, expectedVersion)
    }
    
    private func thenConsentCachePostWasNotCalled() {
        XCTAssertTrue(consentCacheInteractorMock.storedConsentTimesCalled == 0)
    }
    
    private func thenConsentIsPosted(withError: NSError) {
        XCTAssertNotNil(self.errorReturned)
        XCTAssertEqual(self.errorReturned?.code, withError.code)
        XCTAssertEqual(self.errorReturned?.domain, withError.domain)
        XCTAssertNotNil(self.errorReturned?.localizedDescription)
        XCTAssertEqual(self.errorReturned?.localizedDescription, withError.localizedDescription)
    }
    
    private func thenConsentCacheFetchWasCalled(for expectedConsentType: String) {
        XCTAssertEqual(expectedConsentType, consentCacheInteractorMock.captured.consentFetchedFor)
    }
    
    private func thenConsentCacheWasClearedFor(consentType expectedConsentType: String){
        XCTAssertEqual(expectedConsentType, consentCacheInteractorMock.captured.clearedCacheFor)
    }
    
    private func thenCompletionHandlerIsCalledWithDateType(expectedConsent: ConsentStatus?, expectedError: NSError? = nil) {
        XCTAssertNotNil(expectedConsent?.timestamp)
    }
    
    private func givenInternetReachable(status: Bool = false) {
        self.restClientMock.internetReachable = status
    }
    
    private func assertConsent(expectedConsent: CATKConsent, lastPostedConsent: CATKConsent?) {
        XCTAssertNotNil(lastPostedConsent)
        XCTAssertEqual(expectedConsent.consentType, lastPostedConsent!.consentType)
        XCTAssertEqual(expectedConsent.country, lastPostedConsent!.country)
        XCTAssertEqual((expectedConsent.dateTime?.components(separatedBy: "T")[0]),(lastPostedConsent!.dateTime?.components(separatedBy: "T")[0]))
        XCTAssertEqual(expectedConsent.documentVersion, lastPostedConsent!.documentVersion)
        XCTAssertEqual(expectedConsent.language, lastPostedConsent!.language)
        XCTAssertEqual(expectedConsent.resourceType, lastPostedConsent!.resourceType)
        XCTAssertEqual(expectedConsent.status, lastPostedConsent!.status)
        XCTAssertEqual(expectedConsent.subject, lastPostedConsent!.subject)
    }
    
    private func assertConsentState(_ expected: ConsentStatus, _ actual: ConsentStatus){
        XCTAssertEqual(expected.status.rawValue, actual.status.rawValue)
        XCTAssertEqual(expected.version, actual.version)
    }
    
    private static func getCATKConsentOfType(type: String, status: ConsentStates = ConsentStates.rejected, withVersion: String, country: String) -> CATKConsent {

        return CATKConsent(consentType: type, subject: "user", documentVersion: withVersion, status: status, language: "en-US", country: country, dateTime: "1970-01-01T05:30:00.000Z")
    }
    
    private func getConsentDefinitionState(status: ConsentStates, versionStatus: Int, timeStamp:Date) -> ConsentStatus {
        return ConsentStatus(status: status, version: versionStatus, timestamp: timeStamp)
    }
    
    private func getConsentDefinitionStateWithTimeStamp(status: ConsentStates, versionStatus: Int,timeStamp:Date) -> ConsentStatus {
        return ConsentStatus(status: status, version: versionStatus, timestamp: timeStamp)
    }

}

class TestUserData : NSObject, UserDataInterface {
    var hsdpUUIDToReturn: String? = "user"
    var loggedInStateToReturn = URLoggedInState.userLoggedIn

    
    func logoutSession() {
        
    }
    
    func refreshSession() {
        
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
        return self.loggedInStateToReturn
    }
    
    var janrainAccessToken: String?
    
    var hsdpAccessToken: String?{
        return "accesstoken"
    }
    
    var janrainUUID: String?
    
    var hsdpUUID: String? {
        return self.hsdpUUIDToReturn
    }
    
    func addUserDataInterfaceListener(_ listener: USRUserDataDelegate) {
        
    }
    
    func removeUserDataInterfaceListener(_ listener: USRUserDataDelegate) {
        
    }
}
