//
//  TaggingHelperTests.swift
//  ConsentWidgetsTests
//
//  Copyright © 2018 Philips. All rights reserved.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder.
//

import XCTest
import AppInfra
@testable import ConsentWidgets
class TaggingHelperTests: XCTestCase {
    
    override func setUp() {
        givenTaggingInterface()
        super.setUp()
    }
    func testCreateTaggingInstance() {
        givenTaggingInterface()
        whenCreateTaggingInstanceIsTriggered()
        thenTaggingInstanceCreated(withExpectedCompID:"CSW",withExtectedCompVersion:"1.0.0")
    }
    func testCreateTaggingInfoDict() {
        givenConsentTypes(consentTypes: ["A","B"])
        givenConsentStatus(consentStatus:true)
        whenCreateTaggingInfoDictIsTriggered()
        thenNonEmptyInfoDictCreated()
    }
    func testCreateTaggingInfoDictWithEmptyType() {
        givenConsentTypes(consentTypes: [])
        givenConsentStatus(consentStatus:true)
        whenCreateTaggingInfoDictIsTriggered()
        thenNonEmptyInfoDictCreated()
        thenConsentTypeOfDictInfoIsEmpty()
    }
    func testCreateTaggingInfoDictWithExpectedValue() {
        givenConsentTypes(consentTypes: ["A","B","C"])
        givenConsentStatus(consentStatus:true)
        whenCreateTaggingInfoDictIsTriggered()
        thenInfoDictCreated(withExpectedSpecialEvents:"consentAccepted",withExpectedConsentType:"A|B|C")
    }
    func testCreateTaggingInfoDictWithExpectedValueFalse() {
        givenConsentTypes(consentTypes: ["A","B","C"])
        givenConsentStatus(consentStatus:false)
        whenCreateTaggingInfoDictIsTriggered()
        thenInfoDictCreated(withExpectedSpecialEvents:"consentRejected",withExpectedConsentType:"A|B|C")
    }
    func testTrackPageDictCreationWithConsentTypes() {
        givenConsentTypes(consentTypes: ["moment", "coaching"])
        whenCreateTrackPageInfoDict()
        thenDictReturned(dictionaryExpected: ["consentType" : "moment|coaching"])
    }
    func testTrackPageDictCreationWithDuplicateConsentTypes() {
        givenConsentTypes(consentTypes: ["moment", "moment"])
        whenCreateTrackPageInfoDict()
        thenDictReturned(dictionaryExpected: ["consentType" : "moment|moment"])
    }
    func testTrackPageDictCreationWithZeroConsentTypes() {
        givenConsentTypes(consentTypes: [])
        whenCreateTrackPageInfoDict()
        thenDictReturned(dictionaryExpected: ["consentType": ""])
    }
    func testTrackPageDictCreationWithEmptyConsentTypes() {
        givenConsentTypes(consentTypes: ["", ""])
        whenCreateTrackPageInfoDict()
        thenDictReturned(dictionaryExpected: ["consentType":"|"])
    }
    
    func testCreatePopUpInfoDictionary() {
        whenCreatingPopUpInfoDictionary()
        thenDictReturned(dictionaryExpected: [TaggingHelperConstants.inAppNotification : TaggingHelperConstants.revokeConsentPopUp, TaggingHelperConstants.inAppNotificationResponse : TaggingHelperConstants.Action.yes])
    }
     
    private func givenTaggingInterface(){
        appInfra = AIAppInfra()
        taggingMock = MockAppTagging()
        appInfra.tagging = taggingMock
    }
    private func givenConsentTypes(consentTypes: [String]) {
        self.consentTypes = consentTypes
    }
    private func givenConsentStatus(consentStatus:Bool) {
        self.consentStatus = consentStatus
    }
    private func whenCreateTrackPageInfoDict() {
        self.dictInfo = [ TaggingHelperConstants.consentType : TaggingHelper.createTaggingString(consentTypes: consentTypes)]
    }
    private func whenCreateTaggingInstanceIsTriggered(){
        taggingInstance = TaggingHelper.createTaggingInstance(taggingInterface: appInfra.tagging)
        
    }
    private func whenCreateTaggingInfoDictIsTriggered(){
        self.dictInfo = TaggingHelper.createTaggingInfoDict(consentStatus: self.consentStatus, consentTypes: self.consentTypes)
    }
    
    private func whenCreatingPopUpInfoDictionary() {
        self.dictInfo = TaggingHelper.createPopUpTagginInfoDictionaryWith(action: true)
    }
    
    private func thenTaggingInstanceCreated(withExpectedCompID:String,withExtectedCompVersion:String) {
        XCTAssertEqual(withExpectedCompID, taggingMock.componentId)
        XCTAssertEqual(withExtectedCompVersion, taggingMock.componentVersion)
        XCTAssertNotNil(taggingInstance)
    }
    private func thenNonEmptyInfoDictCreated(){
        XCTAssertNotEqual(self.dictInfo,["":""])
    }
    private func thenConsentTypeOfDictInfoIsEmpty() {
        XCTAssertEqual(self.dictInfo["consentType"], "")
    }
    private func thenDictReturned(dictionaryExpected: [String: String]) {
        XCTAssertEqual(dictionaryExpected.keys.count, self.dictInfo.keys.count)
        XCTAssertEqual(dictionaryExpected.values.count, self.dictInfo.values.count)
        
        for (key,value) in dictionaryExpected {
            let valueExpected = self.dictInfo[key]
            XCTAssertEqual(value, valueExpected)
        }
    }
    private func thenInfoDictCreated(withExpectedSpecialEvents:String,withExpectedConsentType:String) {
        XCTAssertEqual(self.dictInfo["specialEvents"], withExpectedSpecialEvents)
        XCTAssertEqual(self.dictInfo["consentType"], withExpectedConsentType)
    }

    var appInfra: AIAppInfra!
    var taggingMock : MockAppTagging!
    var consentTypes: [String]!
    var consentStatus : Bool!
    var dictInfo: [String: String] = ["":""]
    var taggingInstance : AIAppTaggingProtocol!
}

