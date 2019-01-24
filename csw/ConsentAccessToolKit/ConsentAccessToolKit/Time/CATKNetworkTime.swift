//
//  CATKNetworkTime.swift
//  ConsentAccessToolKit
//


import TrueTime

public protocol TrueTimeProtocol {
    
    var referenceTime: ReferenceTime? { get }
    
    func start(pool: [String], port: Int)
    
    func fetchIfNeeded(success: @escaping (ReferenceTime) -> Void,
                       failure: ((NSError) -> Void)?)
    
}

extension TrueTimeClient: TrueTimeProtocol {
    
}

class CATKNetworkTime: NSObject {
    var client: TrueTimeProtocol?
    var isSynchronised: Bool = false
    
    public override init() {
        super.init()
        client = TrueTimeClient(timeout: 8, maxRetries: 3, maxConnections: 3, maxServers: 5,
                                numberOfSamples: 4, pollInterval: (3*60*60) )
        client?.start(pool: ntpHost(), port: 123)
        NotificationCenter.default.addObserver(self, selector: #selector(timeUpdated),
                                               name: NSNotification.Name.TrueTimeUpdated , object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func getUTCTime() -> Date! {
        if let now = client?.referenceTime?.now() {
            return now
        }
        return Date.init()
    }
    
    func ntpHost() -> [String] {
        return ["time.apple.com","0.pool.ntp.org","0.uk.pool.ntp.org",
                         "0.us.pool.ntp.org","asia.pool.ntp.org","time1.google.com"]
    }
    
    @objc func timeUpdated() {
        if ((client?.referenceTime?.now()) != nil) {
            isSynchronised = true
        } else {
            isSynchronised = false
        }
    }
}
