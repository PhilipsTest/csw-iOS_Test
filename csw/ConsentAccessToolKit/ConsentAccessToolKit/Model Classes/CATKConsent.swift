import Foundation
import PlatformInterfaces

public struct CATKConsent {
    public var resourceType: String
    public var dateTime: String?
    public var language: String
    public var status: ConsentStates
    public var subject: String?
    public var country: String
    public var consentType: String
    public var documentVersion: String
    
    public init(resourceType: String = "Consent", consentType: String, subject: String?, documentVersion: String, status: ConsentStates, language: String, country: String, dateTime: String?) {
        self.resourceType = resourceType
        self.language = language
        self.status = status
        self.subject = subject
        self.consentType = consentType
        self.documentVersion = documentVersion
        self.country = country
        self.dateTime = dateTime
    }
}

