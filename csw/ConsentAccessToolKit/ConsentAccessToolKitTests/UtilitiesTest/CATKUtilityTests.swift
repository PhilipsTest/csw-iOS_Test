//
//  CATKUtilityTests.swift
//  ConsentAccessToolKitTests
//
//  Created by Ravi Kiran HR on 12/07/18.
//  Copyright © 2018 Philips. All rights reserved.
//

import XCTest
@testable import ConsentAccessToolKit

class CATKUtilityTests: XCTestCase {
    
    private func givenDateToConvert(date:Date){
        givenDate = date
    }
    private func givenStringToConvert(strDate:String){
        givenStrDate = strDate
    }
    private func whenConvertDateToStringInvoked(){
       convertedString = CATKUtility.convertDatetoString(date:givenDate)
        
    }
    private func whenConvertStringToDateInvoked(){
        convertedDate = CATKUtility.convertStringtoDate(strDate:givenStrDate)
        
    }
    private func thenDateConvertedToExpectedDateString(expectedStrDate:String){
        XCTAssertEqual(convertedString.components(separatedBy: "T")[0], expectedStrDate.components(separatedBy: "T")[0])
    }
    private func thenConvertedDateIsNotNil(){
        XCTAssertNotNil(convertedDate)
    }
    private func thenConvertedDateStringIsNotNil(){
        XCTAssertNotNil(convertedString)
    }
    private func thenStringConvertedToExpectedDate(strExpectedDate:String){
        let strConvertedDate = CATKUtility.convertDatetoString(date:convertedDate)
        XCTAssertEqual(strConvertedDate,strExpectedDate)
    }
    func testDateToStringConversion() {
        givenDateToConvert(date: Date(timeIntervalSince1970: 0))
        whenConvertDateToStringInvoked()
        thenDateConvertedToExpectedDateString(expectedStrDate: "1970-01-01T05:30:00.000Z")
        thenConvertedDateStringIsNotNil()
    }
    
    func testStringToDateConversion() {
        givenStringToConvert(strDate:"1970-01-01T05:30:00.000Z")
        whenConvertStringToDateInvoked()
        thenConvertedDateIsNotNil()
        thenStringConvertedToExpectedDate(strExpectedDate: "1970-01-01T05:30:00.000Z")
    }
    

    var convertedDate:Date!
    var convertedString:String!
    var givenStrDate:String!
    var givenDate:Date!
}
