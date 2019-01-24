import Foundation
import PlatformInterfaces

open class ConsentServiceURHandler: NSObject {
    
    public var userData: UserDataInterface?
    public static var sharedInstance = ConsentServiceURHandler()
    
    fileprivate override  init() {
        super.init()
    }
    
    public func setup(withUserData userData: UserDataInterface?) {
        self.userData = userData
    }

    open func hsdpUUID() -> String? {
        return self.userData?.hsdpUUID
    }
    
    open  func hsdpAccessToken() -> String? {
        return self.userData?.hsdpAccessToken
    }
    
    open  func isUserLoggedIn() -> Bool {
        return self.userData?.loggedInState() == URLoggedInState.userLoggedIn
    }
    
}
