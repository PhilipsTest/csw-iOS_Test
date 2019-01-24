import PlatformInterfaces

protocol ConsentCacheProtocol {
    func fetchState(forConsentType consentType: String) -> CachedConsentStatus?
    func storeState(forConsentType consentType: String, status: ConsentStates, version: Int,timestamp:Date) -> Bool
    func clearCache(forConsentType consentType: String)
}

