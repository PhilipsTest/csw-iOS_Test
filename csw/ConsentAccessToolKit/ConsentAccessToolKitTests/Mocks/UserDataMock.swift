import Foundation
import PlatformInterfaces

public class UserDataMock : NSObject, UserDataInterface {
    var hsdpUUIDToReturn: String? = "user"
    var loggedInStateToReturn = URLoggedInState.userLoggedIn
    
    public func logoutSession() {
        
    }
    
    public func refreshSession() {
        
    }
    
    public func refetchUserDetails() {
        
    }
    
    public func updateUserDetails(_ fields: Dictionary<String, AnyObject>) {
        
    }
    
    public func userDetails(_ fields: Array<String>?) throws -> Dictionary<String, AnyObject> {
        return [:]
    }
    
    public func authorizeLoginToHSDP(withCompletion completion: @escaping (Bool, Error?) -> Void) {
        
    }
    
    public func isUserLoggedIn() -> Bool {
        return true
    }
    
    public func loggedInState() -> URLoggedInState {
        return self.loggedInStateToReturn
    }
    
    public var janrainAccessToken: String?
    
    public var hsdpAccessToken: String?{
        return "accesstoken"
    }
    
    public var janrainUUID: String?
    
    public var hsdpUUID: String? {
        return self.hsdpUUIDToReturn
    }
    
    public func addUserDataInterfaceListener(_ listener: USRUserDataDelegate) {
        
    }
    
    public func removeUserDataInterfaceListener(_ listener: USRUserDataDelegate) {
        
    }
}
