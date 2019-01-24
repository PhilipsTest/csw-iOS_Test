//
//  ConsentWidgetsViewControllerTests.swift
//  ConsentWidgets
//
//  Created by Abhishek Chatterjee on 23/10/17.
//  Copyright © 2017 Niharika Bundela. All rights reserved.
//

import XCTest
import PhilipsUIKitDLS
import PlatformInterfaces
import AppInfra
@testable import ConsentWidgets

public class ConsentWidgetsViewControllerTests: XCTestCase {
    var sut: ConsentWidgetsViewController!
    var consentSwitch: UIDSwitch!
    var presenter: ConsentPresenterMock!
    var restClient = RESTClientMock()
    var revokeConsentAlertControllerMock = UIDAlertControllerMock()
    var consentLoaderInteractorMock: ConsentLoaderInteractorMock!
    let privacyDelegate = ConsentWidgetPrivacyNoticeImplementer()
    let taggingMock = MockAppTagging()
    
    override public func setUp() {
        super.setUp()
        let appInfra = AIAppInfra()
        sut = ConsentWidgetsViewController()
        sut.progressIndicator = UIDProgressIndicator()
        appInfra.restClient = restClient
        sut.appInfra = appInfra
        
        consentLoaderInteractorMock = ConsentLoaderInteractorMock(appInfra: sut.appInfra)
        presenter = ConsentPresenterMock(consentDefinitions: [], consentsLoaderInteractor: consentLoaderInteractorMock, taggingInterface: taggingMock)
        sut.consentPresenter = presenter
        sut.privacyDelegate = privacyDelegate
        presenter.consentsView = sut
        
        consentSwitch = UIDSwitch()
        consentSwitch.setOn(true, animated: false)
    }
    
    public func testConsentTableView_HasNumberOfRows_EqualToNumberOfConsentTypes() {
        givenConsentsToDisplayCountIs(2)
        thenNumberOfConsentTableRowsIs(expectedNumberOfConsentTableRows: 2)
    }
    
    public func testConsentTableViewReload() {
        givenConsentsToDisplayCountIs(5)
        whenConsentViewReloadIsCalled()
        thenNumberOfConsentTableRowsIs(expectedNumberOfConsentTableRows: 5)
        givenConsentsToDisplayCountIs(3)
        whenConsentViewReloadIsCalled()
        thenNumberOfConsentTableRowsIs(expectedNumberOfConsentTableRows: 8)
    }
    
    public func testPrivacyNoticeDelegateInvocation() {
        givenConsentsToDisplayCountIs(5)
        whenPrivacyLinkIsClicked()
        thenDelegateWasInvoked()
    }
    
    public func testViewDidLoad() {
        givenThereIsInternetConnection()
        whenViewDidLoad()
        thenAttachViewIsCalled()
        thenLoadConsentsIsCalled()
    }

    public func testViewWillAppear() {
        whenViewWillAppear();
        thenTrackPageIsCalled();
    }
    
    public func testPostConsent_WhenMomentConsentIsToggled() {
        givenThereIsInternetConnection()
        givenConsentsAreDisplayed()
        whenMomentConsentIsToggled()
        thenProgressIndicatorIsShown(isShown: true)
        thenPresenterIsCalledForPost()
    }
    
    public func testPostConsent_SetsTheToggleBackWhenThereIsNoInternet_ToggledOn() {
        givenNoInternetConnection()
        givenConsentsAreDisplayed(withStatus: false)
        whenMomentConsentIsToggled()
        thenStatusOfConsentsViewDataModel(viewDataModel: sut.consentsToDisplay.first!, withStatus: false)
    }
    
    public func testUserIsAskedWhenRevokingConsent() {
        givenThereIsInternetConnection()
        givenConsentToDisplayHasRevokeMessage()
        self.sut.revokeConsentAlertController = self.revokeConsentAlertControllerMock
        whenMomentConsentIsToggledOff()
        thenRevokeConsentAlertIsShown()
    }
    
    public func testUserIsNotAskedWhenRevokingConsentWithoutRevokeMessageProvided() {
        givenThereIsInternetConnection()
        givenConsentsAreDisplayed()
        self.sut.revokeConsentAlertController = self.revokeConsentAlertControllerMock
        whenMomentConsentIsToggled()
        thenRevokeConsentAlertIsNotShown()
    }
    
    private func givenConsentToDisplayHasRevokeMessage() {
        sut.consentsToDisplay = [getConsentViewModelFor("moment", true, false, revokeMessage: "Revoke message")]
    }
    
    private func thenDelegateWasInvoked() {
        XCTAssert(self.privacyDelegate.wasDelegateInvoked == true)
    }
    
    private func whenPrivacyLinkIsClicked() {
        self.sut.handlePrivacyLinkTap()
    }
    
    private func givenNoInternetConnection() {
        self.presenter.shouldPostReturnError = true
    }
    
    private func givenConsentsAreDisplayed(withStatus: Bool = true) {
        sut.consentsToDisplay = [getConsentViewModelFor("moment", withStatus, false, revokeMessage: "")]
    }
    
    private func thenStatusOfConsentsViewDataModel(viewDataModel: ConsentViewDataModel, withStatus: Bool) {
        XCTAssert(viewDataModel.status == withStatus)
    }
    
    private func givenThereIsInternetConnection() {
        restClient.status = true
    }
    
    private func givenConsentsToDisplayCountIs(_ count : Int) {
        for _ in 1...count {
            self.sut.consentsToDisplay.append(getConsentViewModelFor("sometype", true, false, revokeMessage: ""))
        }
    }
    
    private func whenViewDidLoad() {
        sut.viewDidLoad()
    }

    private func whenViewWillAppear() {
        sut.viewWillAppear(false)
    }
    
    private func whenMomentConsentIsToggled() {
        sut.handleToggleOfWidget(widget: consentSwitch)
    }
    
    private func whenMomentConsentIsToggledOff() {
        consentSwitch.setOn(false, animated: false)
        sut.handleToggleOfWidget(widget: consentSwitch)
    }
    
    private func whenConsentViewReloadIsCalled() {
        self.sut.reloadConsentsView()
    }
    
    private func thenProgressIndicatorIsShown(isShown: Bool) {
        XCTAssertEqual(!isShown, sut.progressIndicator?.isHidden)
    }
    
    private func thenPresenterIsCalledForPost(){
        XCTAssertTrue(presenter.postCalled)
    }
    
    private func thenPresenterIsNotCalledForPost() {
        XCTAssertFalse(presenter.postCalled)
    }
    
    private func thenNumberOfConsentTableRowsIs(expectedNumberOfConsentTableRows: Int) {
        XCTAssertEqual(expectedNumberOfConsentTableRows, sut.tableView(UITableView(), numberOfRowsInSection: 1))
    }
    
    private func thenLoadConsentsIsNotCalled() {
        XCTAssertFalse(presenter.loadAllConsentStatusIsCalled)
    }
    
    private func thenLoadConsentsIsCalled() {
        XCTAssertTrue(presenter.loadAllConsentStatusIsCalled)
    }
    
    private func thenAttachViewIsCalled() {
        XCTAssertTrue(presenter.attachViewIsCalled)
    }

    private func thenTrackPageIsCalled() {
        XCTAssertTrue(presenter.trackPageIsCalled)
    }
    
    private func thenToggleStatusIsOff() {
        XCTAssertTrue(!consentSwitch.isOn)
    }
    
    private func thenToggleStatusIsOn() {
        XCTAssertTrue(consentSwitch.isOn)
    }
    
    private func thenRevokeConsentAlertIsShown() {
        XCTAssertTrue(self.revokeConsentAlertControllerMock.addActionTimesCalled == 2)
    }
    
    private func thenRevokeConsentAlertIsNotShown() {
        XCTAssertTrue(self.revokeConsentAlertControllerMock.addActionTimesCalled == 0)
    }
    
    private func getConsentViewModelFor(_ type: String,_ status: Bool, _ isEnabled: Bool, revokeMessage: String?) -> ConsentViewDataModel {
        guard let message = revokeMessage, message.isEmpty == false else {
            return ConsentViewDataModel(consentDefinition: ConsentDefinition(types: [type], text: type + " consent text", helpText: "sample help text", version: 1, locale: "en-US"), consentText: type + " consent text",  status: status, isEnabled: isEnabled)
        }
        return ConsentViewDataModel(consentDefinition: ConsentDefinition(type: type, text: type + " consent text", helpText: "sample help text", version: 1, locale: "en-US", revokeMessage: message), consentText: type + " consent text",  status: status, isEnabled: isEnabled)
    }
}
