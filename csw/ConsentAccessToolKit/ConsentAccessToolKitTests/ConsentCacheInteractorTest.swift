import XCTest
import AppInfra
import PlatformInterfaces

@testable import ConsentAccessToolKit

class ConsentCacheInteractorTest: XCTestCase {
  
    var catkInputs: CATKInputs!
    var secureStorageMock : CATKSecureStorageMock!
    var consentCacheInteractor : ConsentCacheInteractor!

    var consentStatusReturned : CachedConsentStatus?
    var postSuccess : Bool?
    
    let expiresOn = Date()
    let _3MINUTES = 60 * 3
    var activeV1ConsentExpiringNow : CachedConsentStatus!
    var userData : TestUserData!
    
    enum Keys {
        static let consentCache = "OBE_CONSENT_CACHE"
    }
    
    override func setUp() {
        Bundle.loadSwizzler()
        userData = TestUserData()
        
        self.catkInputs = CATKInputs(logging: AppInfraLoggingMock(),
                                     restClient: AppInfraRestClientMock(),
                                     serviceDiscovery: TestAIServiceDiscoveryProtocol(),
                                     internationalization: AppInfraLocalisationMock(),
                                     appConfig: AppConfig(consentCacheTTL: 3, hsdpAppName: "testApp", hsdpPropName: "propositionTest"),
                                     consentManager: ConsentManagerMock(),
                                     userData: userData)
        
        secureStorageMock = CATKSecureStorageMock()
        self.catkInputs.storageProvider = secureStorageMock
        
        consentCacheInteractor = ConsentCacheInteractor(catkInputs: catkInputs)
        activeV1ConsentExpiringNow = CachedConsentStatus(status: ConsentStates.active, version:1, expiresOn: expiresOn, timestamp: Date(timeIntervalSince1970: 0))
    }
    
    func testReadFromCache() {
        givenConsentIsStoredInSecureStorage(forUserId: userData.hsdpUUID!, consentType: "blah", cachedConsentStatus: activeV1ConsentExpiringNow)
        whenFetchingConsentState(for: "blah")
        thenConsentStatusIsReturnedFromCache(expectedStatus: ConsentStates.active, expectedVersion: 1, expectedExpiresOn: expiresOn )
    }
    
    func testReadFromCacheReturnsNilWhenDataTypeIsDifferent() {
        self.secureStorageMock.mockSecureStorageOutputType = .fetchMockError
        whenFetchingConsentState(for: "blah")
        thenCachedConsentIsNil()
    }
    
    func testReadFromCacheWhenSecureStorageThrows() {
        givenSecureStorageFetchThrows()
        whenFetchingConsentState(for: "blah")
        thenNoConsentIsReturnedOnFetch()
    }
    
    func testStoreToCache() {
        whenStoringConsent(for : "blah", withStatus: ConsentStates.rejected, withVersion: 2)
        thenConsentIsStoredInCache()
        thenStoredConsentCacheHas(consentType: "blah", status: ConsentStates.rejected, version: 2)
    }
    
    func testStoreToCache_appendsToExistingConsents() {
        givenConsentIsStoredInSecureStorage(forUserId: userData.hsdpUUID!, consentType: "test", cachedConsentStatus: activeV1ConsentExpiringNow)
        whenStoringConsent(for : "blah", withStatus: ConsentStates.rejected, withVersion: 2)
        thenConsentIsStoredInCache()
        thenStoredConsentCacheHas(consentType: "blah", status: ConsentStates.rejected, version: 2)
        thenStoredConsentCacheHas(consentType: "test", status: ConsentStates.active, version: 1)
    }
    
    func testStoreToCacheHasCorrectExpiryDate() {
        let now = Date()
        givenAppInfraIsConfiguredForTTL(withMinutes: 3)
        whenStoringConsent(for : "test", withStatus: ConsentStates.active, withVersion: 1)
        thenStoredConsentCacheHas(consentType: "test", status: ConsentStates.active, version: 1)
        thenExpiryDateForStoredConsentIsLaterThan(now + TimeInterval(_3MINUTES), for: "test")
    }
    
    func testStoreToCacheThrows() {
        givenSecureStorageStoreThrows()
        whenStoringConsent(for : "test", withStatus: ConsentStates.active, withVersion: 1)
        thenPostIsUnsuccessful()
    }

    func testClearCache() {
        givenConsentIsStoredInSecureStorage(forUserId: userData.hsdpUUID!, consentType: "test", cachedConsentStatus: activeV1ConsentExpiringNow)
        givenConsentIsStoredInSecureStorage(forUserId: userData.hsdpUUID!, consentType: "blah", cachedConsentStatus: activeV1ConsentExpiringNow)
        whenClearingCache()
        thenConsentCacheIsCleared()
    }
    
    func testClearCacheForConsentType() {
        givenConsentIsStoredInSecureStorage(forUserId: userData.hsdpUUID!, consentType: "test", cachedConsentStatus: activeV1ConsentExpiringNow)
        givenConsentIsStoredInSecureStorage(forUserId: userData.hsdpUUID!, consentType: "blah", cachedConsentStatus: activeV1ConsentExpiringNow)
        whenClearingCacheFor("blah")
        thenConsentCacheIsClearedFor("blah")
        thenConsentCacheStillHas("test", withStatus: activeV1ConsentExpiringNow.consentStatus.status)
    }
    
    func testFetchConsentDeletesPreviousUserConsent() {
        givenConsentIsStoredInSecureStorage(forUserId: "oldUserId", consentType: "blah", cachedConsentStatus: activeV1ConsentExpiringNow)
        whenFetchingConsentState(for: "blah")
        thenConsentCacheIsCleared()
        thenNoConsentIsReturnedOnFetch()
    }
    
    func testFetchConsentReturnsNilIfCurentLoggedInUserHasNoUUID() {
        givenConsentIsStoredInSecureStorage(forUserId: "oldUserId", consentType: "blah", cachedConsentStatus: activeV1ConsentExpiringNow)
        givenCurrentUserHasNoUUID()
        whenFetchingConsentState(for: "blah")
        thenConsentCacheIsCleared()
        thenNoConsentIsReturnedOnFetch()
    }
    
    private func givenCurrentUserHasNoUUID() {
        userData.hsdpUUIDToReturn = nil
    }
    
    private func givenAppInfraIsConfiguredForTTL(withMinutes ttlMinutes : Int) {
        catkInputs.appConfig.consentCacheTTL = ttlMinutes
    }
    
    private func givenSecureStorageFetchThrows() {
        //If we don't store, the mock throws by default. So, do nothing here.
    }
    
    private func givenConsentIsStoredInSecureStorage(forUserId userId:String, consentType : String, cachedConsentStatus : CachedConsentStatus) {
        do {
            var cachedConsentDict = try? secureStorageMock.fetchValue(forKey: Keys.consentCache) as! [String: Any]
            if cachedConsentDict == nil {
                cachedConsentDict = [String : Any]()
            }
            var userConsents = cachedConsentDict![userId] as? [String : CachedConsentStatus] ?? [String: CachedConsentStatus]()
            userConsents[consentType] = cachedConsentStatus
            cachedConsentDict![userId] = userConsents
            try secureStorageMock.storeValue(forKey: Keys.consentCache, value: cachedConsentDict as! NSCoding)
        } catch {
            print("error storing in cache \(error)");
        }
    }
    
    private func givenSecureStorageStoreThrows() {
        secureStorageMock.mockSecureStorageOutputType = .postError
    }
    
    private func whenFetchingConsentState(for consentType : String) {
        self.consentStatusReturned = consentCacheInteractor.fetchState(forConsentType: consentType)
    }
    
    private func whenStoringConsent(for consentType: String, withStatus status: ConsentStates, withVersion version: Int) {
        self.postSuccess = consentCacheInteractor.storeState(forConsentType: consentType, status: status, version: version, timestamp: Date(timeIntervalSinceNow: 0))
    }
    
    private func whenClearingCache() {
        consentCacheInteractor.clearCache()
    }
    
    private func whenClearingCacheFor(_ consentType: String) {
        self.consentCacheInteractor.clearCache(forConsentType: consentType)
    }
    
    private func thenConsentStatusIsReturnedFromCache(expectedStatus: ConsentStates, expectedVersion: Int, expectedExpiresOn: Date) {
        XCTAssertNotNil(self.consentStatusReturned)
        XCTAssertEqual(expectedStatus, self.consentStatusReturned!.consentStatus.status)
        XCTAssertEqual(expectedVersion, self.consentStatusReturned!.consentStatus.version)
        XCTAssertEqual(expectedExpiresOn, self.consentStatusReturned!.expiresOn)
    }
    
    private func thenConsentIsStoredInCache() {
        XCTAssertTrue(self.postSuccess!)
    }
    
    private func thenNoConsentIsReturnedOnFetch() {
        XCTAssertNil(self.consentStatusReturned)
    }
    
    private func thenPostIsUnsuccessful() {
        XCTAssertFalse(self.postSuccess!)
    }
    
    private func thenStoredConsentCacheHas(consentType expectedType: String, status expectedStatus: ConsentStates, version expectedVersion: Int) {
        let storedConsent = getStoredConsentFromCache(forUserId: userData.hsdpUUID!, consentType: expectedType)
        XCTAssertEqual(expectedStatus, storedConsent.consentStatus.status)
        XCTAssertEqual(expectedVersion, storedConsent.consentStatus.version)
    }
    
    private func thenExpiryDateForStoredConsentIsLaterThan(_ expectedExpiryDate : Date, for consentType : String) {
        let storedConsent = getStoredConsentFromCache(forUserId: userData.hsdpUUID!, consentType: consentType)
        XCTAssertTrue(expectedExpiryDate < storedConsent.expiresOn)
    }
    
    private func thenConsentCacheIsCleared() {
        XCTAssertEqual(Keys.consentCache, self.secureStorageMock.removeValueKey)
    }
    
    private func thenConsentCacheIsClearedFor(_ expectedConsentType: String) {
        let cachedConsentDict = try? secureStorageMock.fetchValue(forKey: Keys.consentCache) as! [String: Any]
        let cachedConsentsUser = cachedConsentDict![userData.hsdpUUID!] as! [String : CachedConsentStatus]
        XCTAssertNil(cachedConsentsUser[expectedConsentType])
    }
    
    private func thenConsentCacheStillHas(_ expectedConsentType: String, withStatus expectedStatus: ConsentStates) {
        let cachedConsentDict = try? secureStorageMock.fetchValue(forKey: Keys.consentCache) as! [String: Any]
        let cachedConsentsUser = cachedConsentDict![userData.hsdpUUID!] as! [String : CachedConsentStatus]
        XCTAssertEqual(expectedStatus, cachedConsentsUser[expectedConsentType]?.consentStatus.status)
    }
    
    private func getStoredConsentFromCache(forUserId userId: String, consentType : String) -> CachedConsentStatus {
        let storedConsentDict = secureStorageMock.consentData[Keys.consentCache] as! [String : Any]
        let userCachedConsent = storedConsentDict[userId] as! [String : CachedConsentStatus]
        return userCachedConsent[consentType]!
    }
    
    private func thenCachedConsentIsNil() {
        XCTAssertNil(self.consentStatusReturned)
    }
}
