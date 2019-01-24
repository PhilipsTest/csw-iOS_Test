import Foundation
import PlatformInterfaces
import XCTest
@testable import ConsentAccessToolKit

class ConsentConverterTest : XCTestCase {
    
    func testConvertsConsentDTO_toDataModel() {
        givenConsentDTOWith(resourceType: RESOURCE_TYPE, language: LANGUAGE, status: STATUS_ACCEPTED, subject: SUBJECT, dateTime: DATE_TIME, policyRule: "urn:com.philips.consent:" + CONSENT_TYPE + "/" + COUNTRY + "/" + DOC_VERSION + "/" + PROP_NAME + "/" + APP_NAME)
        whenConvertingDTOToDataModel(consent: exampleConsentDTO!)
        thenConsentIsCreatedWith(resourceType: RESOURCE_TYPE, language: LANGUAGE, status: ConsentStates.active, subject: SUBJECT, dateTime: DATE_TIME, consentType: CONSENT_TYPE, country: COUNTRY, documentId: DOC_VERSION)
        
    }
    
    func testConvertsDataModel_toKeyValue_ContainsStatusActive_WhenStatusIsTrue() {
        givenConsentWith(consentType: CONSENT_TYPE, subject: SUBJECT, documentVersion: DOC_VERSION, status: ConsentStates.active, applicationName: APP_NAME, propositionName: PROP_NAME, language: LANGUAGE, country: COUNTRY)
        whenConvertingToDTO(consent: exampleConsent!, applicationName: APP_NAME, propositionName: PROP_NAME)
        thenConsentDTOIsCreatedWith(resourceType: RESOURCE_TYPE, language: LANGUAGE, policyRule: "urn:com.philips.consent:" + CONSENT_TYPE + "/" + COUNTRY + "/" + DOC_VERSION + "/" + PROP_NAME + "/" + APP_NAME, status: "active", subject: SUBJECT)
    }
    
    func testConvertsDataModel_toKeyValue_ContainsStatusRejected_WhenStatusIsFalse() {
        givenConsentWith(consentType: CONSENT_TYPE, subject: SUBJECT, documentVersion: DOC_VERSION, status: ConsentStates.rejected, applicationName: APP_NAME, propositionName: PROP_NAME, language: LANGUAGE, country: COUNTRY)
        whenConvertingToDTO(consent: exampleConsent!, applicationName: APP_NAME, propositionName: PROP_NAME)
        thenConsentDTOIsCreatedWith(resourceType: RESOURCE_TYPE, language: LANGUAGE, policyRule: "urn:com.philips.consent:" + CONSENT_TYPE + "/" + COUNTRY + "/" + DOC_VERSION + "/" + PROP_NAME + "/" + APP_NAME, status: "rejected", subject: SUBJECT)
    }
    
    func testConvertsDataModel_toKeyValue_takesDocumentVersionFromParameter() {
        givenConsentWith(consentType: CONSENT_TYPE, subject: SUBJECT, documentVersion: DOC_VERSION_ONE, status: ConsentStates.rejected, applicationName: APP_NAME, propositionName: PROP_NAME, language: LANGUAGE, country: COUNTRY)
        whenConvertingToDTO(consent: exampleConsent!, applicationName: APP_NAME, propositionName: PROP_NAME)
        thenConsentDTOIsCreatedWith(resourceType: RESOURCE_TYPE, language: LANGUAGE, policyRule: "urn:com.philips.consent:" + CONSENT_TYPE + "/" + COUNTRY + "/" + DOC_VERSION_ONE + "/" + PROP_NAME + "/" + APP_NAME, status: "rejected", subject: SUBJECT)
    }
    
    func givenConsentDTOWith(resourceType: String, language: String, status: String, subject: String, dateTime: String, policyRule: String) {
        exampleConsentDTO = Dictionary<String, String>()
        exampleConsentDTO!.updateValue(dateTime, forKey: "dateTime")
        exampleConsentDTO!.updateValue(language, forKey: "language")
        exampleConsentDTO!.updateValue(status, forKey: "status")
        exampleConsentDTO!.updateValue(subject, forKey: "subject")
        exampleConsentDTO!.updateValue(policyRule, forKey: "policyRule")
    }
    
    func givenConsentWith(consentType: String, subject: String, documentVersion: String, status: ConsentStates, applicationName: String, propositionName: String, language: String, country: String) {
        exampleConsent = CATKConsent.init(consentType: consentType, subject: subject, documentVersion: documentVersion, status: status, language: language, country: country, dateTime: nil)
    }
    
    func whenConvertingToDTO(consent: CATKConsent, applicationName: String, propositionName: String) {
        consentDTOResult = ConsentConverter.convertToConsentDTO(consent: consent, applicationName: applicationName, propositionName: propositionName)
    }
    
    func whenConvertingDTOToDataModel(consent: Dictionary<String, Any>) {
        consentResult = ConsentConverter.convertToCATKConsent(consentDTO: consent)
    }
    
    func thenConsentIsCreatedWith(resourceType: String, language: String, status: ConsentStates, subject: String, dateTime: String, consentType: String, country: String, documentId: String) {
        XCTAssertEqual(dateTime, consentResult!.dateTime)
        XCTAssertEqual(consentType, consentResult!.consentType)
        XCTAssertEqual(status, consentResult!.status)
        XCTAssertEqual(resourceType, consentResult!.resourceType)
        XCTAssertEqual(language, consentResult!.language)
        XCTAssertEqual(country, consentResult!.country)
        XCTAssertEqual(subject, consentResult!.subject)
        XCTAssertEqual(documentId, consentResult!.documentVersion)
    }
    
    func thenConsentDTOIsCreatedWith(resourceType: String, language: String, policyRule: String, status: String, subject: String) {
        XCTAssertEqual(resourceType, consentDTOResult!["resourceType"] as! String)
        XCTAssertEqual(language, consentDTOResult!["language"] as! String)
        XCTAssertEqual(policyRule, consentDTOResult!["policyRule"] as! String)
        XCTAssertEqual(status, consentDTOResult!["status"] as! String)
        XCTAssertEqual(subject, consentDTOResult!["subject"] as! String)
    }
    
    var exampleConsentDTO: Dictionary<String, Any>?
    var exampleConsent: CATKConsent?
    var consentDTOResult: Dictionary<String, Any>?
    var consentResult: CATKConsent?
    let DATE_TIME = "2017-10-17T09:33:59.000Z"
    let RESOURCE_TYPE = "Consent"
    let COUNTRY = "NL"
    let LANGUAGE = "en-GB"
    let STATUS = true
    let STATUS_ACCEPTED = "active"
    let SUBJECT = "userUUID"
    let CONSENT_TYPE = "moment"
    let DOC_VERSION = "0"
    let DOC_VERSION_ONE = "1"
    let PROP_NAME = "propName"
    let APP_NAME = "appName"
    var policyRule: String?
}
