import PlatformInterfaces

class CachedConsentStatus : NSObject, NSCoding {
   
    var consentStatus : ConsentStatus
    var expiresOn : Date
    
    
    enum Keys {
        static let consentStatus = "consentStatusKey"
        static let expiresOn = "expiresOnKey"
    }
    
    init(status: ConsentStates, version: Int, expiresOn : Date, timestamp: Date) {
        self.expiresOn = expiresOn
        self.consentStatus = ConsentStatus(status: status, version: version, timestamp:timestamp)
    }
    
    static func == (lhs: CachedConsentStatus, rhs: CachedConsentStatus) -> Bool {
        return (lhs.consentStatus == rhs.consentStatus) && (lhs.expiresOn == rhs.expiresOn)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.consentStatus, forKey: Keys.consentStatus)
        aCoder.encode(self.expiresOn, forKey: Keys.expiresOn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let consentStatus = aDecoder.decodeObject(forKey: Keys.consentStatus) as? ConsentStatus else {
            return nil
        }
        self.consentStatus = consentStatus
        self.expiresOn = aDecoder.decodeObject(forKey: Keys.expiresOn) as! Date
    }
}
