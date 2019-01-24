import XCTest
import PlatformInterfaces
@testable import ConsentAccessToolKit

class CachedConsentStatusTest: XCTestCase {
    var cachedConsentStatus: CachedConsentStatus!
    var dateOld,dateRecent:Date!
    
    func testCachedConsentStatusCreation(){
        whenCachedConsentStatusInstantiated()
        thenCachedConsentStatusCreated()
    }
    
    func testCachedConsentStatusEqualityWithIdenticalexpiresOnDate(){
        let expiresOnDate =  Date()
        givenTheConsentStatusWithTimestamps(dateOld: expiresOnDate, dateRecent: expiresOnDate)
        thenCachedConsentStatusFoundIdentical()
    }
    
    func testCachedConsentStatusEqualityWithNonIdenticalexpiresOnDate(){
        let oldExpiresOnDate =  Date()
        let recentExpiresOnDate = oldExpiresOnDate + TimeInterval(60)
        givenTheConsentStatusWithTimestamps(dateOld: oldExpiresOnDate, dateRecent: recentExpiresOnDate)
        thenCachedConsentStatusFoundNonIdentical()
    }
    
    private func givenTheConsentStatusWithTimestamps(dateOld:Date,dateRecent:Date){
        self.dateOld = dateOld
        self.dateRecent = dateRecent
    }

    private func thenCachedConsentStatusFoundIdentical(){
        let CachedConsentStatusWithOldDate = CachedConsentStatus(status: ConsentStates.active, version: 1, expiresOn: dateOld,timestamp: Date(timeIntervalSince1970: 0))
       let CachedConsentStatus2 = CachedConsentStatus(status: ConsentStates.active, version: 1, expiresOn: dateRecent, timestamp: Date(timeIntervalSince1970: 0))
        XCTAssertTrue(CachedConsentStatusWithOldDate == CachedConsentStatus2)
    }
    
    private func thenCachedConsentStatusFoundNonIdentical(){
        let CachedConsentStatusWithOldDate = CachedConsentStatus(status: ConsentStates.active, version: 1, expiresOn: dateOld, timestamp: Date(timeIntervalSince1970: 0))
        let CachedConsentStatus2 = CachedConsentStatus(status: ConsentStates.active, version: 1, expiresOn: dateRecent, timestamp: Date(timeIntervalSince1970: 0))
        XCTAssertFalse(CachedConsentStatusWithOldDate == CachedConsentStatus2)
    }
    
    private func createCachedConsentStatus(){
        cachedConsentStatus = CachedConsentStatus(status: ConsentStates.active,version:10, expiresOn:Date(timeIntervalSince1970: 1234), timestamp: Date(timeIntervalSince1970: 0))
        
    }
    
    private func whenCachedConsentStatusInstantiated(){
        createCachedConsentStatus()
    }
    
    private func thenCachedConsentStatusCreated(){
        XCTAssertNotNil(cachedConsentStatus)
    }
}
