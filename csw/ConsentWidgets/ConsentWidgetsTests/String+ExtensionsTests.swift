//
//  String+ExtensionsTests.swift
//  ConsentWidgetsTests
//
//  Copyright © 2018 Philips. All rights reserved.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder.
//

import XCTest
@testable import ConsentWidgets

class String_ExtensionsTests: XCTestCase {
    
    func testStringRangeCalculationWithEmptyString() {
        let stringToBeTested = ""
        let range = stringToBeTested.nsRange(of: "abc")
        XCTAssertNil(range)
    }
    
    func testStringRangeCalculationWithNonEmptyString_NotContainingSubString() {
        let stringToBeTested = "Trying to test the range of the string"
        let range = stringToBeTested.nsRange(of: "abc")
        XCTAssertNil(range)
    }
    
    func testStringRangeCalculationWithNonEmptyString_ContainingSubString() {
        let stringToBeTested = "Trying abc to test the range of the string"
        let range = stringToBeTested.nsRange(of: "abc")
        XCTAssertNotNil(range)
        XCTAssert(range?.length == "abc".count)
        XCTAssert(range?.lowerBound == 7)
    }
    
    func testStringRangeCalculationWithMultipleOccurances_ReturnsRangeForFirstOccurance() {
        let stringToBeTested = "Trying abc to test the range of the string abc"
        let range = stringToBeTested.nsRange(of: "abc")
        XCTAssertNotNil(range)
        XCTAssert(range?.length == "abc".count)
        XCTAssert(range?.lowerBound == 7)
    }
    
    func testStringSlicingWithNonEmptyString_WithoutSpecialKeys() {
        let stringToBeTested = "Trying to test the range of the string"
        let returnedString = stringToBeTested.slice(from: "test", to: "string")
        XCTAssertNotNil(returnedString)
        XCTAssert(returnedString == " the range of the ")
    }
    
    func testStringSlicingWithNonEmptyString_WithSpecialKeys() {
        let stringToBeTested = "Trying {to} test the range of the string"
        let returnedString = stringToBeTested.slice(from: "{", to: "}")
        XCTAssertNotNil(returnedString)
        XCTAssert(returnedString == "to")
    }
    
    func testStringSlicingWithEmptyString() {
        let stringToBeTested = ""
        let returnedString = stringToBeTested.slice(from: "{", to: "}")
        XCTAssertNil(returnedString)
    }
    
    func testStringSlicingWithNonEmptyString_ButKeysMissing() {
        let stringToBeTested = "Trying to test the range of the string"
        let returnedString = stringToBeTested.slice(from: "{", to: "}")
        XCTAssertNil(returnedString)
    }
    
    func testStringSlicingWithPresenceOfFromAndToStringMultipleTimes_ReturnsTheFirstOccurance() {
        let stringToBeTested = "Trying to {test} the range of the {string}"
        let returnedString = stringToBeTested.slice(from: "{", to: "}")
        XCTAssertNotNil(returnedString)
        XCTAssertTrue(returnedString == "test")
    }
}
