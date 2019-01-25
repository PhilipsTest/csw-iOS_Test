//
//  ConsentWidgetVCHelperTest.swift
//  ConsentWidgetsTests
//
//  Copyright © Koninklijke Philips N.V., 2017
//  All rights are reserved. Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder.
//

import XCTest
@testable import ConsentWidgets

class ConsentWidgetVCHelperTest: XCTestCase {
      
    func testPrivacyAttributedStringConversionWithoutKeys() {
        let stringToBeHandledAsLink = "Sample Text for testing purpose"
        let hyperLinkText = ConsentWidgetViewControllerHelper.getCompletePrivacyStringToDisplay(fromString: stringToBeHandledAsLink)
        XCTAssertNotNil(hyperLinkText)
    }
    
    func testPrivacyAttributedStringCreationWithBracesAsSpecialKeys() {
        let stringToBeHandledAsLink = "Sample Text for {testing} purpose"
        let hyperLinkText = ConsentWidgetViewControllerHelper.getCompletePrivacyStringToDisplay(fromString: stringToBeHandledAsLink)
        XCTAssertNotNil(hyperLinkText)
        XCTAssert(hyperLinkText?.count == stringToBeHandledAsLink.count - 2)
    }
    
    func testPrivacyAttributeStringCreationWithEmptyStringBetweenBracesAsSpecialKeys() {
        let stringToBeHandledAsLink = "Sample Text for {} purpose"
        let hyperLinkText = ConsentWidgetViewControllerHelper.getCompletePrivacyStringToDisplay(fromString: stringToBeHandledAsLink)
        XCTAssertNotNil(hyperLinkText)
        XCTAssert(hyperLinkText?.count == stringToBeHandledAsLink.count - 2)
    }
    
    func testPrivacyAttributeStringCreationWithWholeStringBetweenBracesAsSpecialKeys() {
        let stringToBeHandledAsLink = "{ab}"
        let hyperLinkText = ConsentWidgetViewControllerHelper.getCompletePrivacyStringToDisplay(fromString: stringToBeHandledAsLink)
        XCTAssertNotNil(hyperLinkText)
        XCTAssert(hyperLinkText?.count == stringToBeHandledAsLink.count - 2)
    }
    
    func testGetRangeOfHyperLinkWithEmptyStringBetweenBracesAsSpecialKeys() {
        let stringToBeHandledAsLink = "Sample Text for {} purpose"
        let hyperLinkRange = ConsentWidgetViewControllerHelper.getRangeOfHyperlinkedPartOfPrivacyString(fromString: stringToBeHandledAsLink)
        XCTAssertNil(hyperLinkRange)
    }
    
    func testGetRangeOfHyperLinkWithLinkTextBetweenBracesAsSpecialKeys() {
        let textForPrivacy = "abcd"
        let stringToBeHandledAsLink = "Sample Text for {" + textForPrivacy + "} purpose"
        let hyperLinkRange = ConsentWidgetViewControllerHelper.getRangeOfHyperlinkedPartOfPrivacyString(fromString: stringToBeHandledAsLink)
        XCTAssertNotNil(hyperLinkRange)
        XCTAssert(hyperLinkRange?.length == textForPrivacy.count)
    }
    
    func testGetRangeOfHyperLinkWithoutBracesAsSpecialKeysKeys() {
        let stringToBeHandledAsLink = "Sample Text for purpose"
        let hyperLinkRange = ConsentWidgetViewControllerHelper.getRangeOfHyperlinkedPartOfPrivacyString(fromString: stringToBeHandledAsLink)
        XCTAssertNil(hyperLinkRange)
    }
    
    func testGetRangeOfHyperLinkWithOpenBraceKeysOnly() {
        let stringToBeHandledAsLink = "Sample Text for {purpose{"
        let hyperLinkRange = ConsentWidgetViewControllerHelper.getRangeOfHyperlinkedPartOfPrivacyString(fromString: stringToBeHandledAsLink)
        XCTAssertNil(hyperLinkRange)
        
        let hyperLinkText = ConsentWidgetViewControllerHelper.getCompletePrivacyStringToDisplay(fromString: stringToBeHandledAsLink)
        XCTAssertTrue(hyperLinkText == "Sample Text for purpose")
    }
    
    func testGetRangeOfHyperLinkWithOpenClosedBraceKeysOnly() {
        let stringToBeHandledAsLink = "Sample Text for }purpose}"
        let hyperLinkRange = ConsentWidgetViewControllerHelper.getRangeOfHyperlinkedPartOfPrivacyString(fromString: stringToBeHandledAsLink)
        XCTAssertNil(hyperLinkRange)
        
        let hyperLinkText = ConsentWidgetViewControllerHelper.getCompletePrivacyStringToDisplay(fromString: stringToBeHandledAsLink)
        XCTAssertTrue(hyperLinkText == "Sample Text for purpose")
    }
    
    func testGetRangeOfHyperLinkWithOneClosedBraceKey() {
        let stringToBeHandledAsLink = "Sample Text for} purpose"
        let hyperLinkRange = ConsentWidgetViewControllerHelper.getRangeOfHyperlinkedPartOfPrivacyString(fromString: stringToBeHandledAsLink)
        XCTAssertNil(hyperLinkRange)
        
        let hyperLinkText = ConsentWidgetViewControllerHelper.getCompletePrivacyStringToDisplay(fromString: stringToBeHandledAsLink)
        XCTAssertTrue(hyperLinkText == "Sample Text for purpose")
    }
    
    func testGetRangeOfHyperLinkWithOneOpenBraceKey() {
        let stringToBeHandledAsLink = "Sample Text for {purpose"
        let hyperLinkRange = ConsentWidgetViewControllerHelper.getRangeOfHyperlinkedPartOfPrivacyString(fromString: stringToBeHandledAsLink)
        XCTAssertNil(hyperLinkRange)
        
        let hyperLinkText = ConsentWidgetViewControllerHelper.getCompletePrivacyStringToDisplay(fromString: stringToBeHandledAsLink)
        XCTAssertTrue(hyperLinkText == "Sample Text for purpose")
    }
    
    func testGetRangeAndTextOfHyperLink_MultiplePartsHavingOpenAndClosedKeys() {
        let stringToBeHandledAsLink = "Sample Text for {purpose} of {privacy notice}"
        let hyperLinkRange = ConsentWidgetViewControllerHelper.getRangeOfHyperlinkedPartOfPrivacyString(fromString: stringToBeHandledAsLink)
        XCTAssertNotNil(hyperLinkRange)
        XCTAssertTrue(hyperLinkRange?.length == 7, "Length is not as expected")
        XCTAssertTrue(hyperLinkRange?.location == 16, "Starting index is not as expected")
        XCTAssertTrue(hyperLinkRange?.upperBound == 23, "Upper bound is not as expected")
        let hyperLinkText = ConsentWidgetViewControllerHelper.getCompletePrivacyStringToDisplay(fromString: stringToBeHandledAsLink)
        XCTAssertTrue(hyperLinkText == "Sample Text for purpose of privacy notice")
    }
    
    func testGetRangeAndTextOfHyperLinkWithEmptyText() {
        let stringToBeHandledAsLink = ""
        let hyperLinkRange = ConsentWidgetViewControllerHelper.getRangeOfHyperlinkedPartOfPrivacyString(fromString: stringToBeHandledAsLink)
        XCTAssertNil(hyperLinkRange)
        
        let hyperLinkText = ConsentWidgetViewControllerHelper.getCompletePrivacyStringToDisplay(fromString: stringToBeHandledAsLink)
        XCTAssertTrue(hyperLinkText == "")
    }
    
}
