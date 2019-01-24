//
//  CATKString+ExtensionsTests.swift
//  ConsentAccessToolKitTests
//
/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import ConsentAccessToolKit

class CATKString_ExtensionsTests: XCTestCase {
    
    func testNoInternetConnectionKey() {
        let noInternetConnectionLocalisedString = "CATK_NO_INTERNET_CONNECTION_KEY".localized
        XCTAssertNotNil(noInternetConnectionLocalisedString)
        XCTAssertEqual(noInternetConnectionLocalisedString, "You seem to be offline. Please check your internet settings.")
    }
    
    func testLocaleNotFoundKey() {
        let noLocaleLocalisedString = "CATK_PROBLEM_OCCURED".localized
        XCTAssertNotNil(noLocaleLocalisedString)
        XCTAssertEqual(noLocaleLocalisedString, "Sorry, something went wrong. Please try again")
    }
    
    func testVersionConversionKey() {
        let noLocaleLocalisedString = "CATK_PROBLEM_OCCURED".localized
        XCTAssertNotNil(noLocaleLocalisedString)
        XCTAssertEqual(noLocaleLocalisedString, "Sorry, something went wrong. Please try again")
    }
    
}
