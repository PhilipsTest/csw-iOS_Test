import PlatformInterfaces


public class ConsentCacheInteractor : NSObject, ConsentCacheProtocol {
    let catkInputs : CATKInputs
    
    enum Keys {
        static let consentCache = "OBE_CONSENT_CACHE"
        static let consentCacheTTL = "ConsentCacheTTLInMinutes"
    }
    
    public init(catkInputs: CATKInputs) {
        self.catkInputs = catkInputs
    }
    
    func fetchState(forConsentType consentType: String) -> CachedConsentStatus? {
        let userCachedConsent = getCurrentUserCachedConsent()
        return userCachedConsent[consentType]
    }
    
    func storeState(forConsentType consentType: String, status: ConsentStates, version: Int,timestamp: Date) -> Bool {
        do {
            let cachedConsent = CachedConsentStatus(status: status, version: version, expiresOn: Date() + TimeInterval(try getCacheTimeToLiveInSeconds()),timestamp:timestamp)
            var userCachedConsent = getCurrentUserCachedConsent()
            userCachedConsent[consentType] = cachedConsent
            guard let loggedInUserId = currentLoggedInUserId() else {
                return false
            }
            try self.catkInputs.storageProvider.storeValue(forKey: Keys.consentCache, value: [loggedInUserId : userCachedConsent ] as NSCoding)
            return true
        } catch  let cacheError as NSError {
            self.catkInputs.logging.log(.warning, eventId: "Store consent cache", message: "Storing consent to cache failed with error \(cacheError)")
            return false
        }
    }
    
    func clearCache(forConsentType consentType: String) {
        do {
            var cachedConsentDict = try self.catkInputs.storageProvider.fetchValue(forKey: Keys.consentCache) as! [String : Any]
            if currentLoggedInUserId() != nil, var userConsents = cachedConsentDict[currentLoggedInUserId()!] as? [String : CachedConsentStatus],
                    userConsents[consentType] != nil {
                userConsents.removeValue(forKey: consentType)
                try self.catkInputs.storageProvider.storeValue(forKey: Keys.consentCache, value: [currentLoggedInUserId()! : userConsents ] as NSCoding)
            }
        }catch let cacheError as NSError {
            self.catkInputs.logging.log(.warning, eventId: "Fetch or store error", message: "Fetching from consent cache or storing failed with error \(cacheError)")
        }
    }
    
    
    func clearCache() {
        self.catkInputs.storageProvider.removeValue(forKey: Keys.consentCache)
    }
    
    private func getCachedConsent() -> [String : Any] {
        var cachedConsentDict = [String : Any]()
        do {
            let value = try self.catkInputs.storageProvider.fetchValue(forKey: Keys.consentCache)
            if value is [String : Any] {
                cachedConsentDict = value as! [String : Any]
            }
        }catch let cacheError as NSError {
            self.catkInputs.logging.log(.warning, eventId: "Fetch from consent cache", message: "Fetching from consent cache failed with error \(cacheError)")
        }
        
        return cachedConsentDict
    }
    
    private func getCurrentUserCachedConsent() -> [String : CachedConsentStatus] {
        let cachedConsentDict = getCachedConsent()
        var cachedConsentForUser : [String : CachedConsentStatus]?
        if let loggedInUserId = currentLoggedInUserId() {
            cachedConsentForUser = cachedConsentDict[loggedInUserId] as? [String : CachedConsentStatus]
        }
        if cachedConsentForUser == nil {
            self.clearCache()
            cachedConsentForUser = [String : CachedConsentStatus]()
        }
        return cachedConsentForUser!
    }
    
    private func currentLoggedInUserId() -> String? {
        return ConsentServiceURHandler.sharedInstance.hsdpUUID()
    }
    
    private func getCacheTimeToLiveInSeconds() throws -> Int  {
        return (self.catkInputs.appConfig.consentCacheTTL * 60)
    }
}
