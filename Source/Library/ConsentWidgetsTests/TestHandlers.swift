import PlatformInterfaces

public class TestInteractor1 : ConsentHandlerProtocol {
    var postIsCalledWithStatus : Bool?
    var statusToReturn : ConsentStatus?
    var fetchReturnError : NSError?
    var postErrorToReturn: NSError?

    public func fetchConsentTypeState(for consentType: String, completion: @escaping (ConsentStatus?, NSError?) -> Void) {
        guard fetchReturnError == nil else {
            completion(nil, fetchReturnError)
            return
        }
        completion(statusToReturn, nil)
    }
    
    public func storeConsentState(for consentType: String, withStatus status: Bool, withVersion version: Int, completion: @escaping (Bool, NSError?) -> Void) {
        self.postIsCalledWithStatus = status
        completion(postErrorToReturn == nil, postErrorToReturn)
    }
}

public class TestInteractor2 : ConsentHandlerProtocol {
    var statusToReturn : ConsentStatus?
    var fetchReturnError : NSError?
    var postErrorToReturn: NSError?
    
    public func fetchConsentTypeState(for consentType: String, completion: @escaping (ConsentStatus?, NSError?) -> Void) {
        guard fetchReturnError == nil else {
            completion(nil, fetchReturnError)
            return
        }
        completion(statusToReturn, nil)
    }
    
    public func storeConsentState(for consentType: String, withStatus status: Bool, withVersion version: Int, completion: @escaping (Bool, NSError?) -> Void) {
        completion(postErrorToReturn == nil, postErrorToReturn)
    }
}
