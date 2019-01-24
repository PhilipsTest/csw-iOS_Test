import Foundation
import PlatformInterfaces

class ConsentConverter {
    
    private static let ACTIVE_STATUS:String = "active"
    private static let INACTIVE_STATUS:String = "inactive"
    private static let REJECTED_STATUS:String = "rejected"
    
    public static func convertToCATKConsent(consentDTO: Dictionary<String, Any>) -> CATKConsent {
        let consentInfo = (consentDTO["policyRule"] as! String).components(separatedBy: ":")[2].components(separatedBy: "/")
        let consentStatus = getConsentStatus(value: consentDTO["status"]!  as! String)
        return CATKConsent(consentType: consentInfo[0], subject: (consentDTO["subject"] as! String), documentVersion: consentInfo[2], status: consentStatus, language: consentDTO["language"] as! String, country: consentInfo[1], dateTime: (consentDTO["dateTime"] as! String))
    }
    
    public static func convertToConsentDTO(consent: CATKConsent, applicationName: String, propositionName: String) -> Dictionary<String, String>? {
        guard let subject = consent.subject else {
            return nil
        }
        let policyRule = "urn:com.philips.consent:" + consent.consentType + "/" + consent.country + "/" + consent.documentVersion + "/" + propositionName + "/" + applicationName
        var consentDictionary = Dictionary<String, String>()
        consentDictionary.updateValue(consent.resourceType, forKey: "resourceType")
        consentDictionary.updateValue(consent.language, forKey: "language")
        let consentStatusString = getConsentStatusString(status: consent.status)
        consentDictionary.updateValue(consentStatusString, forKey: "status")
        consentDictionary.updateValue(subject, forKey: "subject")
        consentDictionary.updateValue(policyRule, forKey: "policyRule")
        return consentDictionary
    }
    private static func getConsentStatus(value: String) -> ConsentStates{
        switch value {
        case ACTIVE_STATUS:
            return ConsentStates.active
        case INACTIVE_STATUS:
            return ConsentStates.inactive
        case REJECTED_STATUS:
            return ConsentStates.rejected
        default:
            return ConsentStates.inactive
        }
    }
    private static func getConsentStatusString(status: ConsentStates) -> String{
        switch status {
        case ConsentStates.active:
            return ACTIVE_STATUS
        case ConsentStates.inactive:
            return INACTIVE_STATUS
        case ConsentStates.rejected:
            return REJECTED_STATUS
        }
    }
}

