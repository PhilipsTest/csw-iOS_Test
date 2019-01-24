//
//  CATKNetworkTimeTests.swift
//

import XCTest
import TrueTime
@testable import ConsentAccessToolKit

class AINetworkTimeTests: XCTestCase {
    
    var catkTime: CATKNetworkTime?
    
    override func setUp() {
        super.setUp()
        catkTime = CATKNetworkTime()
    }
    
    func testUtcTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let timeZone = NSTimeZone(name: "UTC")
        if let aZone = timeZone {
            formatter.timeZone = aZone as TimeZone
        }
        let now = Date()
        let dateAsString = formatter.string(from: now)
        
        let utcTime: Date? = catkTime?.getUTCTime()
        var utcAsString: String? = nil
        if let aTime = utcTime {
            utcAsString = formatter.string(from: aTime)
        }
        XCTAssertEqual(dateAsString, utcAsString)
    }
    
    func testDeinit() {
        catkTime = nil
    }
    
    func testTimeUpdateToTrue() {
        let now = Date()
        let trueTimeMock = TrueTimeMock(date: now, isSync: true)
        trueTimeMock.setReferenceTime()
        catkTime?.client = trueTimeMock
        catkTime?.isSynchronised = false
        catkTime?.timeUpdated()
        XCTAssertTrue((catkTime?.isSynchronised)!)
    }
    
    func testTimeUpdateToFalse() {
        let trueTimeMock = TrueTimeMockWithReferenceTimeToNil()
        catkTime?.client = trueTimeMock
        catkTime?.isSynchronised = true
        catkTime?.timeUpdated()
        XCTAssertFalse((catkTime?.isSynchronised)!)
    }
    
    func giveUrlsFromNtp() -> [String] {
        let arrayOfUrls = ["time.apple.com","0.pool.ntp.org","0.uk.pool.ntp.org","0.us.pool.ntp.org","asia.pool.ntp.org","time1.google.com"]
        return arrayOfUrls
    }
}

class TrueTimeMock : TrueTimeProtocol {
    
    var date : Date?
    var sync : Bool = false
    
    init(date: Date, isSync: Bool) {
        self.date = date
        self.sync = isSync
    }
    
    var referenceTime: ReferenceTime?
    
    func start(pool: [String], port: Int) {
        return
    }
    
    func fetchIfNeeded(success: @escaping (ReferenceTime) -> Void, failure: ((NSError) -> Void)?) {
        if sync {
            success(ReferenceTime(time: date!, uptime: timeval.init(tv_sec: 100, tv_usec: 100)))
        } else {
            failure!(NSError(domain: "", code: 1, userInfo: nil))
        }
    }
    
    public func setReferenceTime() {
        self.referenceTime = ReferenceTime(time: date!, uptime: timeval.init(tv_sec: 0, tv_usec: 0))
    }
}

class TrueTimeMockWithReferenceTimeToNil: TrueTimeProtocol{
    var referenceTime: ReferenceTime?
    
    func start(pool: [String], port: Int) {
        return
    }
    
    func fetchIfNeeded(success: @escaping (ReferenceTime) -> Void, failure: ((NSError) -> Void)?) {
        return
    }
    
    
}
