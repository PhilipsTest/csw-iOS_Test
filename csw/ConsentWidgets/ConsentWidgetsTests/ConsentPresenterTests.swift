//
//  ConsentPresenterTests.swift
//  ConsentWidgetsTests
//
//  Copyright © 2018 Philips. All rights reserved.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder.
//

import XCTest
import PlatformInterfaces
@testable import ConsentWidgets
import AppInfra

class ConsentPresenterTests: XCTestCase {
    var consentDefinitionStatusListOrdering: [ConsentDefinitionStatus]? = []
    let momentConsentDefinition = ConsentDefinition(type: "moment", text: "SampleText", helpText: "SampleHelpText", version: 1, locale: "en-US")
    let insightConsentDefinition = ConsentDefinition(type: "insight", text: "SampleText", helpText: "SampleHelpText", version: 1, locale: "en-US")
    let clickStreamConsentDefinition = ConsentDefinition(type: "clickstream", text: "SampleText", helpText: "SampleHelpText", version: 1, locale: "en-US")
    let multipleConsentTypesDefinition = ConsentDefinition(types: ["moment", "coaching"], text: "SampleText", helpText: "SampleHelpText", version: 1, locale: "en-US")

    override public func setUp() {
        super.setUp()
        self.appInfra = AIAppInfra()
        self.consentLoaderInteractor = ConsentLoaderInteractorMock(appInfra: appInfra)
        self.navigationControllerMock = UINavigationControllerMock.init(rootViewController: consentView)
        self.taggingMock = MockAppTagging()
        self.appInfra.tagging = self.taggingMock
        super.continueAfterFailure = false
    }
    
    override public func tearDown() {
        self.consentView.consentsToDisplay?.removeAll()
        super.tearDown()
    }
    
    private func givenConsentPresenterConfigured(withConsentDefinitions: [ConsentDefinition]) {
        self.consentPresenter = ConsentPresenter(consentDefinitions: withConsentDefinitions, consentsLoaderInteractor: consentLoaderInteractor, taggingInterface: taggingMock)
        self.consentPresenter.attachView(consentsView: consentView)
        self.consentPresenter.consentsLoaderInteractor = consentLoaderInteractor
    }

    func testInit_CreatesAppTaggingInterface() {
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition])
        thenTrackingObjectWasInvoked(withComponentId: "CSW", withComponentVersion: "1.0.0")
    }
    
    func testFetchAllLatestConsents_UpdatesStatusOfAllConsents_ReturnedByServer() {
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition, insightConsentDefinition])
        givenConsentLoaderInteractorReturns(consentDefinitionStatusList: [ConsentDefinitionStatus(status: ConsentStates.active, versionStatus: ConsentVersionStates.inSync, consentDefinition: momentConsentDefinition), ConsentDefinitionStatus(status: ConsentStates.active, versionStatus: ConsentVersionStates.appVersionIsHigher, consentDefinition: insightConsentDefinition)])
        whenLoadingAllLatestConsents()
        thenProgressIndicatorWasShown()
        thenConsentsViewWasUpdatedWith([getConsentViewModelFor(momentConsentDefinition, status: true, isEnabled: true), getConsentViewModelFor(insightConsentDefinition, status: true, isEnabled: true)])
        thenProgressIndicatorWasHidden()
    }
    
    func testFetchAllLatestConsents_UpdatesStatusOfInactiveConsents_ReturnedByServer() {
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition, insightConsentDefinition])
        givenConsentLoaderInteractorReturns(consentDefinitionStatusList: [ConsentDefinitionStatus(status: ConsentStates.inactive, versionStatus: ConsentVersionStates.inSync, consentDefinition: momentConsentDefinition), ConsentDefinitionStatus(status: ConsentStates.active, versionStatus: ConsentVersionStates.appVersionIsHigher, consentDefinition: insightConsentDefinition)])
        whenLoadingAllLatestConsents()
        thenProgressIndicatorWasShown()
        thenConsentsViewWasUpdatedWith([getConsentViewModelFor(momentConsentDefinition, status: false, isEnabled: true), getConsentViewModelFor(insightConsentDefinition, status: true, isEnabled: true)])
        thenProgressIndicatorWasHidden()
    }
    
    func testFetchAllLatestConsents_UpdatesStatusOfActiveConsents_ReturnedByServer_InSyncVersion() {
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition, insightConsentDefinition])
        givenConsentLoaderInteractorReturns(consentDefinitionStatusList: [ConsentDefinitionStatus(status: ConsentStates.active, versionStatus: ConsentVersionStates.inSync, consentDefinition: momentConsentDefinition), ConsentDefinitionStatus(status: ConsentStates.active, versionStatus: ConsentVersionStates.inSync, consentDefinition: insightConsentDefinition)])
        whenLoadingAllLatestConsents()
        thenProgressIndicatorWasShown()
        thenConsentsViewWasUpdatedWith([getConsentViewModelFor(momentConsentDefinition, status: true, isEnabled: true), getConsentViewModelFor(insightConsentDefinition, status: true, isEnabled: true)])
        thenProgressIndicatorWasHidden()
    }
    
    func testFetchAllLatestConsents_UpdatesStatusOfInactiveConsents_ReturnedByServer_InSyncVersion() {
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition, insightConsentDefinition])
        givenConsentLoaderInteractorReturns(consentDefinitionStatusList: [ConsentDefinitionStatus(status: ConsentStates.inactive, versionStatus: ConsentVersionStates.inSync, consentDefinition: momentConsentDefinition), ConsentDefinitionStatus(status: ConsentStates.inactive, versionStatus: ConsentVersionStates.inSync, consentDefinition: insightConsentDefinition)])
        whenLoadingAllLatestConsents()
        thenProgressIndicatorWasShown()
        thenConsentsViewWasUpdatedWith([getConsentViewModelFor(momentConsentDefinition, status: false, isEnabled: true), getConsentViewModelFor(insightConsentDefinition, status: false, isEnabled: true)])
        thenProgressIndicatorWasHidden()
    }
    
    func testFetchAllLatestConsents_UpdatesStatusOfInactiveConsents_ReturnedByServer_AppVersionIsHigher() {
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition, insightConsentDefinition])
        givenConsentLoaderInteractorReturns(consentDefinitionStatusList: [ConsentDefinitionStatus(status: ConsentStates.inactive, versionStatus: ConsentVersionStates.appVersionIsHigher, consentDefinition: momentConsentDefinition), ConsentDefinitionStatus(status: ConsentStates.inactive, versionStatus: ConsentVersionStates.appVersionIsHigher, consentDefinition: insightConsentDefinition)])
        whenLoadingAllLatestConsents()
        thenProgressIndicatorWasShown()
        thenConsentsViewWasUpdatedWith([getConsentViewModelFor(momentConsentDefinition, status: false, isEnabled: true), getConsentViewModelFor(insightConsentDefinition, status: false, isEnabled: true)])
        thenProgressIndicatorWasHidden()
    }
    
    func testFetchAllLatestConsents_UpdatesStatusOfInactiveConsents_ReturnedByServer_AppVersionIsLower() {
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition, insightConsentDefinition])
        givenConsentLoaderInteractorReturns(consentDefinitionStatusList: [ConsentDefinitionStatus(status: ConsentStates.inactive, versionStatus: ConsentVersionStates.appVersionIsLower, consentDefinition: momentConsentDefinition), ConsentDefinitionStatus(status: ConsentStates.inactive, versionStatus: ConsentVersionStates.appVersionIsLower, consentDefinition: insightConsentDefinition)])
        whenLoadingAllLatestConsents()
        thenProgressIndicatorWasShown()
        thenConsentsViewWasUpdatedWith([getConsentViewModelFor(momentConsentDefinition, status: false, isEnabled: false), getConsentViewModelFor(insightConsentDefinition, status: false, isEnabled: false)])
        thenProgressIndicatorWasHidden()
    }
    
    func testFetchAllLatestConsents_UpdatesStatusOfInactiveConsents_ReturnedByServer_AppVersionIsLower_AndHigher() {
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition, insightConsentDefinition])
        givenConsentLoaderInteractorReturns(consentDefinitionStatusList: [ConsentDefinitionStatus(status: ConsentStates.inactive, versionStatus: ConsentVersionStates.appVersionIsLower, consentDefinition: momentConsentDefinition), ConsentDefinitionStatus(status: ConsentStates.inactive, versionStatus: ConsentVersionStates.appVersionIsHigher, consentDefinition: insightConsentDefinition)])
        whenLoadingAllLatestConsents()
        thenProgressIndicatorWasShown()
        thenConsentsViewWasUpdatedWith([getConsentViewModelFor(momentConsentDefinition, status: false, isEnabled: false), getConsentViewModelFor(insightConsentDefinition, status: false, isEnabled: true)])
        thenProgressIndicatorWasHidden()
    }
    
    func testFetchAllLatestConsents_UpdatesStatusOfRejectedConsents_ReturnedByServer_InSyncVersion() {
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition, insightConsentDefinition])
        givenConsentLoaderInteractorReturns(consentDefinitionStatusList: [ConsentDefinitionStatus(status: ConsentStates.rejected, versionStatus: ConsentVersionStates.inSync, consentDefinition: momentConsentDefinition), ConsentDefinitionStatus(status: ConsentStates.rejected, versionStatus: ConsentVersionStates.inSync, consentDefinition: insightConsentDefinition)])
        whenLoadingAllLatestConsents()
        thenProgressIndicatorWasShown()
        thenConsentsViewWasUpdatedWith([getConsentViewModelFor(momentConsentDefinition, status: false, isEnabled: true), getConsentViewModelFor(insightConsentDefinition, status: false, isEnabled: true)])
        thenProgressIndicatorWasHidden()
    }
    
    func testFetchAllLatestConsents_UpdatesStatusOfRejectedConsents_ReturnedByServer_AppVersionIsHigher() {
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition, insightConsentDefinition])
        givenConsentLoaderInteractorReturns(consentDefinitionStatusList: [ConsentDefinitionStatus(status: ConsentStates.rejected, versionStatus: ConsentVersionStates.appVersionIsHigher, consentDefinition: momentConsentDefinition), ConsentDefinitionStatus(status: ConsentStates.rejected, versionStatus: ConsentVersionStates.appVersionIsHigher, consentDefinition: insightConsentDefinition)])
        whenLoadingAllLatestConsents()
        thenProgressIndicatorWasShown()
        thenConsentsViewWasUpdatedWith([getConsentViewModelFor(momentConsentDefinition, status: false, isEnabled: true), getConsentViewModelFor(insightConsentDefinition, status: false, isEnabled: true)])
        thenProgressIndicatorWasHidden()
    }
    
    func testFetchAllLatestConsents_UpdatesStatusOfRejectedeConsents_ReturnedByServer_AppVersionIsLower() {
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition, insightConsentDefinition])
        givenConsentLoaderInteractorReturns(consentDefinitionStatusList: [ConsentDefinitionStatus(status: ConsentStates.rejected, versionStatus: ConsentVersionStates.appVersionIsLower, consentDefinition: momentConsentDefinition), ConsentDefinitionStatus(status: ConsentStates.rejected, versionStatus: ConsentVersionStates.appVersionIsLower, consentDefinition: insightConsentDefinition)])
        whenLoadingAllLatestConsents()
        thenProgressIndicatorWasShown()
        thenConsentsViewWasUpdatedWith([getConsentViewModelFor(momentConsentDefinition, status: false, isEnabled: false), getConsentViewModelFor(insightConsentDefinition, status: false, isEnabled: false)])
        thenProgressIndicatorWasHidden()
    }
    
    func testFetchAllLatestConsents_UpdatesStatusOfRejectedConsents_ReturnedByServer_AppVersionIsLower_AndHigher() {
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition, insightConsentDefinition])
        givenConsentLoaderInteractorReturns(consentDefinitionStatusList: [ConsentDefinitionStatus(status: ConsentStates.rejected, versionStatus: ConsentVersionStates.appVersionIsLower, consentDefinition: momentConsentDefinition), ConsentDefinitionStatus(status: ConsentStates.rejected, versionStatus: ConsentVersionStates.appVersionIsHigher, consentDefinition: insightConsentDefinition)])
        whenLoadingAllLatestConsents()
        thenProgressIndicatorWasShown()
        thenConsentsViewWasUpdatedWith([getConsentViewModelFor(momentConsentDefinition, status: false, isEnabled: false), getConsentViewModelFor(insightConsentDefinition, status: false, isEnabled: true)])
        thenProgressIndicatorWasHidden()
    }

    func testFetchAllLatestConsents_UpdatesStatusOfAllConsents_WithTheCorrectSequence() {
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition, insightConsentDefinition])
        givenConsentLoaderInteractorReturns(consentDefinitionStatusList: [ConsentDefinitionStatus(status: ConsentStates.inactive, versionStatus: ConsentVersionStates.inSync, consentDefinition: momentConsentDefinition), ConsentDefinitionStatus(status: ConsentStates.active, versionStatus: ConsentVersionStates.inSync, consentDefinition: insightConsentDefinition)])
        whenLoadingAllLatestConsents()
        thenConsentsViewWasUpdatedWith([getConsentViewModelFor(momentConsentDefinition, status: false, isEnabled: true),
                                        getConsentViewModelFor(insightConsentDefinition, status: true, isEnabled: true)])
    }
    
    func testFetchAllLatestConsents_UpdatesStatusOfAllConsents_WithTheCorrectSequence_WhenReturnedCountIsDifferent() {
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition, insightConsentDefinition])
        givenConsentLoaderInteractorReturns(consentDefinitionStatusList: [ConsentDefinitionStatus(status: ConsentStates.active, versionStatus: ConsentVersionStates.inSync, consentDefinition: insightConsentDefinition)])
        whenLoadingAllLatestConsents()
        thenConsentsViewWasUpdatedWith([])
    }
    
    func testFetchAllLatestConsents_UpdatesViewWithConnectivityError_WhenErrorIsReturned() {
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition, clickStreamConsentDefinition])
        givenConsentLoaderInteractorReturnsError(500, "some error")
        whenLoadingAllLatestConsents()
        thenProgressIndicatorWasShown()
        thenErrorIsShownToTheView(withErrorTitle: "csw_problem_occurred_error_title".localized, andMessage: "csw_generic_network_error".localized, actionText: "csw_ok".localized, popControllerCallCount: 1)
        thenProgressIndicatorWasHidden()
    }
    
    func testFetchAllConsents_UpdatesViewWithError_WhenErrorCodeIs3002() {
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition, clickStreamConsentDefinition])
        givenConsentLoaderInteractorReturnsError(3002, "some error", "testing3002")
        whenLoadingAllLatestConsents()
        thenProgressIndicatorWasShown()
        thenErrorIsShownToTheView(withErrorTitle: "csw_problem_occurred_error_title".localized, andMessage: "testing3002", actionText: "csw_ok".localized, popControllerCallCount: 1)
        thenProgressIndicatorWasHidden()
    }
    
    func testFetchAllConsents_UpdatesViewWithError_WhenErrorCodeIs3003() {
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition, clickStreamConsentDefinition])
        givenConsentLoaderInteractorReturnsError(3002, "some error", "testing3003")
        whenLoadingAllLatestConsents()
        thenProgressIndicatorWasShown()
        thenErrorIsShownToTheView(withErrorTitle: "csw_problem_occurred_error_title".localized, andMessage: "testing3003", actionText: "csw_ok".localized, popControllerCallCount: 1)
        thenProgressIndicatorWasHidden()
    }
    
    func testFetchAllConsents_UpdatesViewWithError_WhenErrorCodeIs3004() {
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition, clickStreamConsentDefinition])
        givenConsentLoaderInteractorReturnsError(3002, "some error", "testing3004")
        whenLoadingAllLatestConsents()
        thenProgressIndicatorWasShown()
        thenErrorIsShownToTheView(withErrorTitle: "csw_problem_occurred_error_title".localized, andMessage: "testing3004", actionText: "csw_ok".localized, popControllerCallCount: 1)
        thenProgressIndicatorWasHidden()
    }
    
    func testFetchAllLatestConsents_WithRevokingReturnsError() {
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition, clickStreamConsentDefinition])
        givenConsentLoaderInteractorPostReturns(success: false, error: NSError(domain: "Sampel", code: 100000, userInfo: nil) )
        whenLoadingAllLatestConsents()
        thenProgressIndicatorWasShown()
        thenProgressIndicatorWasHidden()
    }
    
    func testFetchAllLatestConsents_UpdatesViewWithError_When1008ErrorIsReturned() {
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition, clickStreamConsentDefinition])
        givenConsentLoaderInteractorReturnsError(1008, "some error")
        whenLoadingAllLatestConsents()
        thenProgressIndicatorWasShown()
        thenErrorIsShownToTheView(withErrorTitle: "csw_problem_occurred_error_title".localized, andMessage: "csw_invalid_access_token_error_message".localized, actionText: "csw_ok".localized, popControllerCallCount: 1)
        thenProgressIndicatorWasHidden()
    }
    
    func testFetchConsentsResultOrdering_AsPerOrderInWhichConsentsWereSent() {
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition, insightConsentDefinition, clickStreamConsentDefinition])
        givenConsentLoaderInteractorReturns(consentDefinitionStatusList: [ConsentDefinitionStatus(status: ConsentStates.active, versionStatus: ConsentVersionStates.inSync, consentDefinition: clickStreamConsentDefinition), ConsentDefinitionStatus(status: ConsentStates.active, versionStatus: ConsentVersionStates.inSync, consentDefinition: insightConsentDefinition), ConsentDefinitionStatus(status: ConsentStates.active, versionStatus: ConsentVersionStates.inSync, consentDefinition: momentConsentDefinition)])
        whenLoadingAllLatestConsents()
        thenConsentViewModelsAreReturnedInOrder([getConsentViewModelFor(momentConsentDefinition, status: true, isEnabled: true),
                                        getConsentViewModelFor(insightConsentDefinition, status: true, isEnabled: true),
                                        getConsentViewModelFor(clickStreamConsentDefinition, status: true, isEnabled: true)])
    }
    
    func testFetchConsentResult_InvalidAccessTokenError() {
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition, insightConsentDefinition, clickStreamConsentDefinition])
        givenConsentLoaderInteractorReturnsError(1009, "some error")
        whenLoadingAllLatestConsents()
        thenProgressIndicatorWasShown()
        thenErrorIsShownToTheView(withErrorTitle: "csw_problem_occurred_error_title".localized, andMessage: "csw_user_session_expired".localized, actionText: "csw_ok".localized, popControllerCallCount: 1)
        thenProgressIndicatorWasHidden()
    }
    
    func testPostConsent() {
        givenConsentLoaderInteractorPostReturns(success: true, error: nil)
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition])
        whenPostingConsent(consent: getConsentViewModelFor(momentConsentDefinition, status: true, isEnabled: true))
        thenProgressIndicatorWasShown()
        thenConsentWasPostedWith(consentDefinition: momentConsentDefinition, status: true)
        thenProgressIndicatorWasHidden()
    }
    
    func testPostConsentTracksConsentAccepted() {
        givenConsentLoaderInteractorPostReturns(success: true, error: nil)
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition])
        whenPostingConsent(consent: getConsentViewModelFor(momentConsentDefinition, status: true, isEnabled: true))
        thenTrackActionWasInvokedWith(expectedAction: "sendData", expectedTypes: "moment", expectedStatus: "consentAccepted")
    }

    func testPostConsentTracksConsentRejected() {
        givenConsentLoaderInteractorPostReturns(success: true, error: nil)
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition])
        whenPostingConsent(consent: getConsentViewModelFor(momentConsentDefinition, status: false, isEnabled: true))
        thenTrackActionWasInvokedWith(expectedAction: "sendData", expectedTypes: "moment", expectedStatus: "consentRejected")
    }

    func testPostConsentTracksMultiConsentType() {
        givenConsentLoaderInteractorPostReturns(success: true, error: nil)
        givenConsentPresenterConfigured(withConsentDefinitions: [multipleConsentTypesDefinition])
        whenPostingConsent(consent: getConsentViewModelFor(multipleConsentTypesDefinition, status: true, isEnabled: true))
        thenTrackActionWasInvokedWith(expectedAction: "sendData", expectedTypes: "moment|coaching", expectedStatus: "consentAccepted")
    }

    func testPostConsentDoesNotTracksWhenServerReturnsFalse() {
        givenConsentLoaderInteractorPostReturns(success: false, error: nil)
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition])
        whenPostingConsent(consent: getConsentViewModelFor(momentConsentDefinition, status: true, isEnabled: true))
        thenTrackActionWasNotInvoked()
    }

    func testPostConsent_ShowsAndHidesProgressIndicator_WhenErrorIsReturned() {
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition])
        givenConsentLoaderInteractorReturnsError(500, "some error")
        whenPostingConsent(consent: getConsentViewModelFor(momentConsentDefinition, status: true, isEnabled: true))
        thenProgressIndicatorWasShown()
        thenProgressIndicatorWasHidden()
    }
    
    func testPostConsent_UpdatesViewWithConnectivityError_WhenErrorIsReturned() {
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition])
        givenConsentLoaderInteractorPostReturns(success: false, error: NSError(domain: "Sample", code: 3000, userInfo: nil) )
        whenPostingConsent(consent: getConsentViewModelFor(momentConsentDefinition, status: true, isEnabled: true))
        thenErrorIsShownToTheView(withErrorTitle: "csw_problem_occurred_error_title".localized, andMessage: "csw_generic_network_error".localized, actionText: "csw_ok".localized, popControllerCallCount: 0)
        thenConsentViewIsReloaded()
    }
    
    public func testPostConsent_UpdatesViewWithConnectivityError_WhenNoInternetErrorIsReturned() {
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition])
        givenConsentLoaderInteractorPostReturns(success: false, error: NSError(domain: "Sample", code: NSURLErrorNotConnectedToInternet, userInfo: nil) )
        whenPostingConsent(consent: getConsentViewModelFor(momentConsentDefinition, status: true, isEnabled: true))
        thenErrorIsShownToTheView(withErrorTitle: "csw_offline_title".localized, andMessage: "csw_offline_message".localized, actionText: "csw_ok".localized, popControllerCallCount: 0)
        thenConsentViewIsReloaded()
    }
    
    func testPostConsent_UpdatesViewWithError_When1009ErrorIsReturned() {
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition])
        givenConsentLoaderInteractorPostReturns(success: false, error: NSError(domain: "Sample", code: 1009, userInfo: nil) )
        whenPostingConsent(consent: getConsentViewModelFor(momentConsentDefinition, status: true, isEnabled: true))
        thenErrorIsShownToTheView(withErrorTitle: "csw_problem_occurred_error_title".localized, andMessage: "csw_user_session_expired".localized, actionText: "csw_ok".localized, popControllerCallCount: 0)
        thenConsentViewIsReloaded()
    }
    
    func testPostConsent_ResetsConsentViewModelStatus_WhenErrorIsReturned() {
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition])
        givenConsentLoaderInteractorPostReturns(success: false, error: NSError(domain: "Sample", code: 3000, userInfo: nil) )
        let consentViewModel = getConsentViewModelFor(momentConsentDefinition, status: true, isEnabled: true)
        whenPostingConsent(consent: consentViewModel)
        thenDataViewModel(consentViewModel, isResetToStatus: false)
    }
    
    func testPostConsent_DisablesConsentWhenAppVersionIsLowerErrorReturned() {
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition])
        givenConsentLoaderInteractorPostReturns(success: true, error: NSError(domain: "Lower version", code: 1252, userInfo: nil))
        let consentViewModel = getConsentViewModelFor(momentConsentDefinition, status: true, isEnabled: true)
        whenPostingConsent(consent: consentViewModel)
        thenDataViewModel(consentViewModel, isEnabled: false)
    }
    
    func testPostConsent_DoesNotDisableToggleWhenOtherErrorCodesAreReturned() {
        givenConsentPresenterConfigured(withConsentDefinitions: [momentConsentDefinition])
        givenConsentLoaderInteractorPostReturns(success: true, error: NSError(domain: "Some error", code: 1223, userInfo: nil))
        let consentViewModel = getConsentViewModelFor(momentConsentDefinition, status: true, isEnabled: true)
        whenPostingConsent(consent: consentViewModel)
        thenDataViewModel(consentViewModel, isEnabled: true)
    }

    func testTrackPage() {
        givenConsentPresenterConfigured(withConsentDefinitions: [])
        whenTrackingPage()
        thenTrackPageWasInvokedWith(expectedPage: ConsentPresenterConstants.consentCenterString)
    }
    
    func testRevokeConsentPopUpIsDismissedWithOkResponse() {
        let revokeAction = true
        let revokeMessage = "Test revoke message"
        givenConsentPresenterConfigured(withConsentDefinitions: [])
        whenTaggingRevokePopUpResponseWith(action: revokeAction)
        thenTaggingWasInvokedWithResponse(action: revokeAction)
    }
    
    func testRevokeConsentPopUpIsDismissedWithCancelResponse() {
        let revokeAction = false
        let revokeMessage = "Test revoke message"
        givenConsentPresenterConfigured(withConsentDefinitions: [])
        whenTaggingRevokePopUpResponseWith(action: revokeAction)
        thenTaggingWasInvokedWithResponse(action: revokeAction)
    }

    private func givenConsentLoaderInteractorReturns(consentDefinitionStatusList : [ConsentDefinitionStatus]) {
        consentLoaderInteractor.consentDefinitionStatusListToReturn = consentDefinitionStatusList
        self.consentDefinitionStatusListOrdering = consentDefinitionStatusList
    }
    
    private func givenConsentLoaderInteractorReturnsError(_ errorCode : Int, _ errorMessage : String, _ localisedString: String? = nil) {
        guard let stringDescriptionForError = localisedString else {
            consentLoaderInteractor.errorToReturn = NSError(domain: errorMessage, code: errorCode, userInfo: nil)
            return
        }
        consentLoaderInteractor.errorToReturn = NSError(domain: errorMessage, code: errorCode, userInfo: [NSLocalizedDescriptionKey : stringDescriptionForError])
    }
    
    private func givenConsentLoaderInteractorPostReturns(success : Bool, error : NSError? ) {
        self.consentLoaderInteractor.postSuccess = success
        self.consentLoaderInteractor.postErrorToReturn = error
    }
    
    private func whenLoadingAllLatestConsents() {
        self.consentPresenter.loadAllConsentStatus()
    }
    
    private func whenPostingConsent(consent: ConsentViewDataModel) {
        self.consentPresenter.postConsent(data: consent)
    }

    private func whenTrackingPage() {
        consentPresenter.trackPage()
    }
    
    private func whenTaggingRevokePopUpResponseWith(action: Bool) {
        self.consentPresenter.revokeConsentDidFinishWith(action: action)
    }

    private func thenConsentsViewWasUpdatedWith(_ expectedConsentsToDisplay : [ConsentViewDataModel]) {
        XCTAssertNotNil(self.consentView.consentsToDisplay)
        XCTAssertEqual(expectedConsentsToDisplay.count, self.consentView.consentsToDisplay?.count)
        for (index,consentViewModel) in expectedConsentsToDisplay.enumerated() {
            XCTAssertEqual(consentViewModel.status, self.consentView.consentsToDisplay?[index].status)
        }
    }
    
    private func thenConsentViewModelsAreReturnedInOrder(_ expectedConsentViewModels: [ConsentViewDataModel]) {
        XCTAssertNotNil(expectedConsentViewModels)
        XCTAssertNotNil(self.consentView.consentsToDisplay)
        XCTAssertEqual(expectedConsentViewModels.count, self.consentView.consentsToDisplay?.count)
        for (index,consentViewModel) in expectedConsentViewModels.enumerated() {
            XCTAssertEqual(consentViewModel.status, self.consentView.consentsToDisplay?[index].status)
            XCTAssertEqual(consentViewModel.consentDefinition, self.consentView.consentsToDisplay?[index].consentDefinition)
        }
    }
    
    private func thenConsentViewIsReloaded() {
        XCTAssertTrue(self.consentView.viewReloaded)
    }

    private func thenConsentWasPostedWith(consentDefinition expectedConsentDefinition: ConsentDefinition,  status expectedStatus: Bool) {
        XCTAssertEqual(expectedStatus, consentLoaderInteractor.statusOfConsentToPost)

        if let consent = consentLoaderInteractor.consentDefinitionToPost {
            XCTAssertEqual(expectedConsentDefinition.version, consent.version)
            XCTAssertEqual(expectedConsentDefinition.locale, consent.locale)

            XCTAssertEqual(expectedConsentDefinition.getTypes().count, consent.getTypes().count)
            for expectedType in expectedConsentDefinition.getTypes() {
                XCTAssertTrue(consent.getTypes().contains(expectedType))
            }

        } else {
            XCTFail("Did not find expected ConsentDefinition")
        }
    }
    
    private func thenErrorIsShownToTheView(withErrorTitle errorTitle : String, andMessage errorMessage : String, actionText : String, popControllerCallCount : Int) {
        XCTAssertTrue(self.consentView.showErrorCalled)
        XCTAssertEqual(errorTitle, self.consentView.errorTitle)
        XCTAssertEqual(errorMessage, self.consentView.errorMessage)
        XCTAssertEqual(actionText, self.consentView.actionText)
        XCTAssertEqual(popControllerCallCount, self.navigationControllerMock.popViewControllerCallCount)
    }
    
    private func thenProgressIndicatorWasShown() {
        XCTAssertTrue(self.consentView.progressIndicatorShown)
    }
    
    private func thenProgressIndicatorWasHidden() {
        XCTAssertTrue(self.consentView.progressIndicatorHidden)
    }
    
    private func thenDataViewModel(_ data: ConsentViewDataModel, isResetToStatus status: Bool) {
        XCTAssertEqual(data.status, status)
    }
    
    private func thenDataViewModel(_ data: ConsentViewDataModel, isEnabled enabled: Bool) {
        XCTAssertEqual(data.isEnabled, enabled)
    }

    private func thenTrackingObjectWasInvoked(withComponentId: String, withComponentVersion: String) {
        XCTAssertEqual(self.taggingMock.componentId, withComponentId)
        XCTAssertEqual(self.taggingMock.componentVersion, withComponentVersion)
    }
    
    private func thenTrackActionWasInvokedWith(expectedAction actionName: String, expectedTypes consentTypes: String, expectedStatus status: String) {
        var expectedDictInfo = [AnyHashable : Any]()
        expectedDictInfo["specialEvents"] = status
        expectedDictInfo["consentType"] = consentTypes
        XCTAssertEqual(expectedDictInfo as NSObject, self.taggingMock.dictInfo as NSObject)
        XCTAssertEqual(actionName, self.taggingMock.trackedAction)
    }

    private func thenTrackActionWasNotInvoked() {
        XCTAssertNil(self.taggingMock.trackedAction)
        
        XCTAssertEqual(self.taggingMock.dictInfo.keys.count, 0)
        XCTAssertEqual(self.taggingMock.dictInfo.values.count, 0)
    }

    private func thenTrackPageWasInvokedWith(expectedPage pageName: String) {
        XCTAssertEqual(pageName, self.taggingMock.trackedPage)
    }
    
    private func thenTaggingWasInvokedWithResponse(action: Bool) {
        let expectedAction  = action ? TaggingHelperConstants.Action.yes : TaggingHelperConstants.Action.cancel
        XCTAssertTrue(self.taggingMock.wasTrackActionInvoked)
        XCTAssertEqual(self.taggingMock.trackedAction, TaggingHelperConstants.consentActionName)
        XCTAssertEqual(self.taggingMock.dictInfo[TaggingHelperConstants.inAppNotification], "Revoke consent popup")
        XCTAssertEqual(self.taggingMock.dictInfo[TaggingHelperConstants.inAppNotificationResponse], expectedAction)
    }

    private func getConsentViewModelFor(_ consentDefinition: ConsentDefinition, status: Bool, isEnabled: Bool) -> ConsentViewDataModel {
        return ConsentViewDataModel(consentDefinition: consentDefinition, consentText: consentDefinition.text, status: status, isEnabled: isEnabled)
    }
    
    let expectation = XCTestExpectation(description: "Wait for call to finish")
    var consentLoaderInteractor: ConsentLoaderInteractorMock!
    var consentPresenter : ConsentPresenter!
    var consentView = ConsentsViewMock()
    var navigationControllerMock : UINavigationControllerMock!
    let APP_NAME = "app"
    let PROP_NAME = "prop"
    var appInfra : AIAppInfra!
    var taggingMock: MockAppTagging!
}
    

class UINavigationControllerMock : UINavigationController {
    var popViewControllerCallCount = 0
   override func popViewController(animated: Bool) -> UIViewController? {
        popViewControllerCallCount += 1
        return nil
    }
}
