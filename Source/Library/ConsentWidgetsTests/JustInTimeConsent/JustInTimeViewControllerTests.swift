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

class JustInViewControllerTests: XCTestCase {
    override func setUp() {
        super.setUp()
        givenAppInfraIsSetToDefaultUnknown()
        taggingMock = MockAppTagging()
        appInfra = AIAppInfra(builder: nil)
        appInfra.consentManager = consentManagerMock
        appInfra.tagging = taggingMock
        controllerToTest = JustInTimeConsentViewController()
        controllerToTest.setAppInfra(inAppInfra: appInfra)
    }
    
    func testTrackPageInvocation() {
        givenConsentDefinitionConfigured(withConsentDefinition: consentDefinitionWithType)
        whenJITViewControllerHasLoaded()
        thenTrackPageIsInvoked()
    }
    func testTrackPageWithExtectedPageName() {
        givenConsentDefinitionConfigured(withConsentDefinition: consentDefinitionWithType)
        whenJITViewControllerHasLoaded()
        thenTrackPageIsInvokedWithExpectedPageName()
    }
    func testTrackPageWithExtectedPageNameAndInfo() {
        givenConsentDefinitionConfigured(withConsentDefinition: consentDefinitionWithTypes)
        whenJITViewControllerHasLoaded()
        thenTrackPageIsInvokedWithExpectedInfoDict()
        thenTrackPageIsInvokedWithExpectedPageName()
    }
    func testTrackPageWithExtectedInfo_WithEmptyType() {
        givenConsentDefinitionConfigured(withConsentDefinition: consentDefinitionWithNoType)
        whenJITViewControllerHasLoaded()
        thenTrackPageIsInvokedWithEmptyConsentType()
        thenTrackPageIsInvokedWithExpectedPageName()
    }
    
    func testJustInTimeControllerInstantiation() {
        givenJustInTimeConsentAction()
        whenCreateViewControllerCalled()
        thenControllerCreationWasSuccefull()
    }
    
    func testJustInTimeUIConfigInstanceCreationWithConvinienceContructor() {
        whenJustInTimeUIConfigInstanceCreatedWithConvinienceContructor()
        thenJustInTimeUIConfigInstanceCreated()
    }
    
    func testJustInTimeControllerTappedOkayAndReturnSuccess() {
        givenJustInTimeConsentAction()
        whenCreateViewControllerCalledWithOkButton()
        thenDelegateAcceptedInvocationFor(object: delegateMock as! JustInTimeConsentUserActionMock, withValue: false)
    }
    func testJustInTimeControllerTappedCancelAndReturnSuccess() {
        givenJustInTimeConsentAction()
        whenCreateViewControllerCalledWithCancelButton()
        thenDelegateCanceledInvocationFor(object: delegateMock as! JustInTimeConsentUserActionMock, withValue: false)
    }
    
    func testJustInTimeControllerTappedOkayAndReturnFailure() {
        givenJustInTimeConsentAction()
        whenCreateViewControllerCalledWithOkButton()
        thenDelegateAcceptedInvocationFor(object: delegateMock as! JustInTimeConsentUserActionMock, withValue: false)
    }
    
    func testJustInTimeControllerTappedCancelAndReturnFailure() {
        givenJustInTimeConsentAction()
        whenCreateViewControllerCalledWithCancelButton()
        thenDelegateCanceledInvocationFor(object: delegateMock as! JustInTimeConsentUserActionMock, withValue: false)
    }
    
    func testJustInTimeTrackingWithStatusTrue_ServerReturnsTrue() {
        givenConsentManagerConfigured(withError: nil)
        givenConsentDefinitionWithType(types:["type1","type2"])
        givenInfoDict(withConsentStatus:true)
        givenControllerIsConfigured(withConsentDefinition: consentDefinitionToTest, appInfra: self.appInfra, withInteractorValue: true, withError: nil)
        whenControllerTappedAccept()
        thenTaggingMockIsInvokedWith(actionName: "sendData", withDict: self.infoDict)
    }
    
    func testJustInTimeTrackingWithStatusTrue_ServerReturnsError() {
        givenConsentDefinitionWithType(types:["type1","type2"])
        givenConsentManagerConfigured(withError: NSError(domain: "Sample", code: 10000, userInfo: nil))
        givenControllerIsConfigured(withConsentDefinition: consentDefinitionToTest, appInfra: self.appInfra, withInteractorValue: true, withError: nil)
        whenControllerTappedAccept()
        thenTaggingMockDictIsEmpty()
    }
    
    func testJustInTimeTrackingWithStatusFalse_ServerReturnsTrue() {
        givenConsentManagerConfigured(withError: nil)
        givenConsentDefinitionWithType(types:["type1","type2"])
        givenInfoDict(withConsentStatus:false)
        givenControllerIsConfigured(withConsentDefinition: consentDefinitionToTest, appInfra: self.appInfra, withInteractorValue: true, withError: nil)
        whenControllerTappedCancel()
        thenTaggingMockIsInvokedWith(actionName: "sendData",withDict: infoDict)
    }
    
    func testJustInTimeTrackingWithStatusFalse_ServerReturnsError() {
        givenConsentDefinitionWithType(types:["type1","type2"])
        givenConsentManagerConfigured(withError: NSError(domain: "Sample", code: 10000, userInfo: nil))
        givenControllerIsConfigured(withConsentDefinition: consentDefinitionToTest, appInfra: self.appInfra, withInteractorValue: true, withError: nil)
        whenControllerTappedCancel()
        thenTaggingMockDictIsEmpty()
    }
    
    func testJustInTimeTrackingWithStatusFalse_ServerReturnsError_WithEmptyTypes() {
        givenConsentDefinitionWithType(types:["",""])
        givenConsentManagerConfigured(withError: NSError(domain: "Sample", code: 10000, userInfo: nil))
        givenControllerIsConfigured(withConsentDefinition: consentDefinitionToTest, appInfra: self.appInfra, withInteractorValue: true, withError: nil)
        whenControllerTappedCancel()
        thenTaggingMockDictIsEmpty()
    }
    
    func testJustInTimeTrackingWithStatusTrue_ServerReturnsError_WithEmptyTypes() {
        givenConsentDefinitionWithType(types:["",""])
        givenConsentManagerConfigured(withError: NSError(domain: "Sample", code: 10000, userInfo: nil))
        givenControllerIsConfigured(withConsentDefinition: consentDefinitionToTest, appInfra: self.appInfra, withInteractorValue: true, withError: nil)
        whenControllerTappedCancel()
        thenTaggingMockDictIsEmpty()
    }
    
    func testJustInTimeTrackingWithStatusFalse_ServerReturnsTrue_WithEmptyTypes() {
        givenConsentDefinitionWithType(types:["",""])
        givenInfoDict(withConsentStatus:false)
        givenConsentManagerConfigured(withError: nil)
        givenControllerIsConfigured(withConsentDefinition: consentDefinitionToTest, appInfra: self.appInfra, withInteractorValue: true, withError: nil)
        whenControllerTappedCancel()
        thenTaggingMockIsInvokedWith(actionName: "sendData", withDict: infoDict)
    }
    
    func testJustInTimeTrackingWithStatusTrue_ServerReturnsTrue_WithEmptyTypes() {
        givenConsentDefinitionWithType(types:["",""])
        givenInfoDict(withConsentStatus:true)
        givenConsentManagerConfigured(withError: nil)
        givenControllerIsConfigured(withConsentDefinition: consentDefinitionToTest, appInfra: self.appInfra, withInteractorValue: true, withError: nil)
        whenControllerTappedAccept()
        thenTaggingMockIsInvokedWith(actionName: "sendData", withDict: infoDict)
    }
    
    func testMovesToWhatDoesThisMeanController() {
        let consentWidgetFlowMock = ConsentWidgetFlowMock.self
        controllerToTest.consentWidgetFlow = consentWidgetFlowMock
        
        givenConsentDefinitionConfigured(withConsentDefinition: getConsentDefinitionFor(types: ["",""]))
        whenJustInTimeUIConfigInstanceCreatedWithConvinienceContructor()
        controllerToTest.justInTimeUIConfig = justInTimeUIModel

        controllerToTest.moveToWhatDoesThisMeanController()
        
        XCTAssertTrue(consentWidgetFlowMock.moveToWhatDoesThisMeanCalled)
    }
    
    func testMoveToWhatDoesThisMeanWithPropositionsData() {
        let consentWidgetFlowMock = ConsentWidgetFlowMock.self
        controllerToTest.consentWidgetFlow = consentWidgetFlowMock
        let consentDefinition = getConsentDefinitionFor(types: ["",""])
        givenConsentDefinitionConfigured(withConsentDefinition: consentDefinition)
        whenJustInTimeUIConfigInstanceCreatedWithConvinienceContructor()
        controllerToTest.justInTimeUIConfig = justInTimeUIModel
        
        controllerToTest.moveToWhatDoesThisMeanController()
        
        XCTAssertEqual(consentWidgetFlowMock.Captured.helpText, consentDefinition.helpText)
        XCTAssertEqual(consentWidgetFlowMock.Captured.title, justInTimeUIModel.title)
    }
    
    private func givenControllerIsConfigured(withConsentDefinition: ConsentDefinition, appInfra: AIAppInfra, withInteractorValue: Bool, withError: NSError?) {
        let consentInteractor = returnConsentInteractorMock(withValue: true, withError: withError)
        let delegateMock = JustInTimeConsentUserActionMock()
        let interfaceObject = self.getInterfaceObject(withConsentModel: withConsentDefinition, consentInteractor: consentInteractor)
        controllerToTest = (interfaceObject.getJustInTimeConsentViewController(justInTimeConsentDelegate: delegateMock) as? JustInTimeConsentViewController)!
        controllerToTest.setAppInfra(inAppInfra: appInfra)
    }
    
    private func givenAppInfraIsSetToDefaultUnknown(){
        Bundle.loadSwizzler()
        appInfra = AIAppInfra(builder: nil)
        ConsentWidgetsData.sharedInstance.appInfra = appInfra
        appInfra?.tagging.setPrivacyConsent(AIATPrivacyStatus.unknown)
    }
    
    private func givenConsentManagerConfigured(withError: NSError?) {
        consentManagerMock.errorToReturn = withError
    }
    private func givenConsentDefinitionConfigured(withConsentDefinition:ConsentDefinition){
        controllerToTest.setConsentDefinition(consentDefinition: withConsentDefinition)
    }
    
    private func  givenJustInTimeConsentAction() {
        self.delegateMock = JustInTimeConsentUserActionMock()
    }
    private func givenInfoDict(withConsentStatus:Bool) {
        self.infoDict = TaggingHelper.createTaggingInfoDict(consentStatus: withConsentStatus, consentTypes: consentDefinitionToTest.getTypes())
    }
    private func givenConsentDefinitionWithType(types:[String]){
        consentDefinitionToTest = getConsentDefinitionFor(types: types)
    }
    private func whenControllerTappedAccept() {
        controllerToTest.acceptButtonTapped(UIDButton())
    }
    
    private func whenControllerTappedCancel() {
        controllerToTest.cancelButtonTapped(UIDButton())
    }
    private func whenJITViewControllerHasLoaded(){
        controllerToTest.viewWillAppear(true)
    }
    private func whenGetJustInTimeConsentViewControllerInvoked(){
        let delegateMock = JustInTimeConsentUserActionMock()
        controllerReturned = createViewController(withConsentInteractorValue: true, withConsentInteractorError: nil, withDelegate: delegateMock)
    }
    private func  whenCreateViewControllerCalled() {
        self.controllerToTest = createViewController(withConsentInteractorValue: true, withConsentInteractorError: nil, withDelegate: delegateMock)
    }
    private func whenJustInTimeUIConfigInstanceCreatedWithConvinienceContructor() {
        justInTimeUIModel = JustInTimeUIConfig(title: "Be the first to know", acceptButtonTitle: "Ok, count me in", cancelButtonTitle: "May be later", userBenefitsTitle: "What do we have to offer?", userBenefitsDescription: "Special offers,promotions and first hand information about new product releases.Tailored for you!")
    }
    private func whenCreateViewControllerCalledWithOkButton()
    {
        let interactorError = NSError(domain: "Sample error", code: 1002, userInfo: nil)
        let controllerToUse = createViewController(withConsentInteractorValue: true, withConsentInteractorError: interactorError, withDelegate: delegateMock)
        controllerToUse.acceptButtonTapped(UIDButton())
    }
    private func whenCreateViewControllerCalledWithCancelButton()
    {
        let interactorError = NSError(domain: "Sample error", code: 1002, userInfo: nil)
        let controllerToUse = createViewController(withConsentInteractorValue: true, withConsentInteractorError: interactorError, withDelegate: delegateMock)
        controllerToUse.cancelButtonTapped(UIDButton())
    }
    private func thenTaggingMockIsInvokedWith(actionName:String, withDict: [String:String]) {
        XCTAssertNotNil(taggingMock.dictInfo)
        
        for (key,value) in withDict {
            XCTAssertEqual(value, taggingMock.dictInfo[key])
        }
        
        XCTAssertEqual(actionName, self.taggingMock.trackedAction)
    }
    
    private func thenTaggingMockDictIsEmpty() {
        XCTAssertEqual(taggingMock.dictInfo.keys.count, 0)
        XCTAssertEqual(taggingMock.dictInfo.values.count, 0)
    }
    
    private func thenTrackPageIsInvoked(){
        XCTAssertTrue(taggingMock.wasTrackPageInvoked)
    }
    
    private func thenTrackPageIsInvokedWithExpectedPageName(){
        XCTAssertEqual(taggingMock.trackedPage, "jitConsent")
    }
    
    private func thenTrackPageIsInvokedWithExpectedInfoDict(){
        XCTAssertEqual(taggingMock.dictInfo["consentType"], "A|B|C")
    }
    
    private func thenTrackPageIsInvokedWithEmptyConsentType(){
        XCTAssertEqual(taggingMock.dictInfo["consentType"], "")
    }
    private func thenJustInTimeControllerInstantiated(){
        XCTAssertNotNil(controllerReturned, "Controller returned was nil")
        XCTAssertNotNil(controllerReturned.justInTimeConsentDelegate, "Delegate returned was nil")
        XCTAssertNotNil(controllerReturned.consentDefinition, "Consent Model returned was nil")
        XCTAssertNotNil(controllerReturned.justInTimeConsentAPIHelper, "API services helper returned was nil")
    }
    private func  thenControllerCreationWasSuccefull() {
        XCTAssertNotNil(self.controllerToTest, "Controller returned was nil")
        XCTAssertNotNil(self.controllerToTest.justInTimeConsentDelegate, "Delegate returned was nil")
        XCTAssertNotNil(self.controllerToTest.consentDefinition, "Consent Model returned was nil")
        XCTAssertNotNil(self.controllerToTest.justInTimeConsentAPIHelper, "API services helper returned was nil")
    }
    private func  thenJustInTimeUIConfigInstanceCreated() {
        XCTAssertNotNil(justInTimeUIModel, "Object creation failed")
        XCTAssertTrue(justInTimeUIModel .isKind(of: JustInTimeUIConfig.self))
    }
    private func createViewController(withConsentInteractorValue: Bool, withConsentInteractorError: NSError?, withDelegate: JustInTimeConsentViewProtocol) -> JustInTimeConsentViewController
    {
        let type1ConsentDefinition = getConsentDefinitionFor(types: ["type1"])
        let consentInteractor = returnConsentInteractorMock(withValue: withConsentInteractorValue, withError: withConsentInteractorError)
        let interfaceObject = self.getInterfaceObject(withConsentModel: type1ConsentDefinition, consentInteractor: consentInteractor)
        
        let controllerToUse: JustInTimeConsentViewController!
        controllerToUse = interfaceObject.getJustInTimeConsentViewController(justInTimeConsentDelegate: withDelegate) as? JustInTimeConsentViewController
        return controllerToUse
    }
    
    private func thenDelegateAcceptedInvocationFor(object: JustInTimeConsentUserActionMock, withValue: Bool) {
        XCTAssertEqual(object.wasConsentAcceptedInvoked, withValue)
    }
    
    private func thenDelegateCanceledInvocationFor(object: JustInTimeConsentUserActionMock, withValue: Bool) {
        XCTAssert(object.wasConsentCanceledInvoked == withValue, "Value returned is not expected value")
    }
    
    private func getInterfaceObject(withConsentModel: ConsentDefinition, consentInteractor: ConsentHandlerProtocol) -> JustInTimeConsentInterface {
        let justInTimeUIModel = JustInTimeUIConfig(inTitle: "Sample", inAcceptButtonTite: "Accept", inCancelButtonTitle: "Cancel")
        let interfaceObject = JustInTimeConsentInterface(withConsentDefinition: withConsentModel, withUIConfig: justInTimeUIModel, withAppInfra: appInfra)
        return interfaceObject
    }
    
    private func returnConsentInteractorMock(withValue: Bool, withError: NSError?) -> ConsentHandlerProtocol {
        let consentInteractor = ConsentInteractorMock()
        consentInteractor.errorToReturn = withError
        consentInteractor.postSuccess = withValue
        return consentInteractor
    }
    
    private func getConsentDefinitionFor(types: [String]) -> ConsentDefinition {
        return ConsentDefinition(types: types, text: "type consent", helpText: "sample", version: 0, locale: "en-US")
    }

    var appInfra: AIAppInfra!
    var consentManagerMock = ConsentManagerMock()
    var taggingMock = MockAppTagging()
    var controllerToTest: JustInTimeConsentViewController!
    let consentDefinitionWithType = ConsentDefinition(type: "A", text: "test", helpText: "test", version: 1, locale: "en_IN")
    let consentDefinitionWithTypes = ConsentDefinition(types: ["A","B","C"], text: "test", helpText: "test", version: 1, locale: "en_IN")
    let consentDefinitionWithNoType = ConsentDefinition(type: "", text: "test", helpText: "test", version: 1, locale: "en_IN")
    var controllerReturned: JustInTimeConsentViewController!
    var delegateMock:JustInTimeConsentViewProtocol!
    var justInTimeUIModel:JustInTimeUIConfig!
    var infoDict:[String:String]!
    var consentDefinitionToTest:ConsentDefinition!
    var expectation:XCTestExpectation!

}

