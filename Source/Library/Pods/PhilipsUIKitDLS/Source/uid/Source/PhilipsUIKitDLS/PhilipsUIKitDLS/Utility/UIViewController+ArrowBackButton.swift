/** © Koninklijke Philips N.V., 2016. All rights reserved. */

import Foundation

extension UIViewController {
    
    // See: http://justabeech.com/2014/02/24/empty-back-button-on-ios7/
    
    class func arrowBackBarButtonItem() {
        if !UIDThemeManager.sharedInstance.showBackButtonText {
            DispatchQueue.once {
                let originalSelector = #selector(viewDidLoad)
                let swizzledSelector = #selector(noTitleBackBarButtonItem)
                
                let originalMethod = class_getInstanceMethod(self, originalSelector)
                let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
                
                let didAddMethod = class_addMethod(self, originalSelector,
                                                   method_getImplementation(swizzledMethod!),
                                                   method_getTypeEncoding(swizzledMethod!))
                
                if didAddMethod {
                    class_replaceMethod(self, swizzledSelector,
                                        method_getImplementation(originalMethod!),
                                        method_getTypeEncoding(originalMethod!))
                } else {
                    method_exchangeImplementations(originalMethod!, swizzledMethod!)
                    
                }
            }
        }
    }
    
    // Swizzling Method for viewDidLoad.
    @objc open func noTitleBackBarButtonItem() {
        noTitleBackBarButtonItem() // Remember this is swizzled! So this is not recursive.
        let barButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = barButton
    }
}

extension DispatchQueue {
    private static let token = NSUUID().uuidString
    private static var tokenTracker = [String]()
    
    /**
     Executes a block of code, associated with a unique token, only once. The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter block: Block to execute once
     */
    class func once(block: () -> Void) {
        once(token: token, block: block)
    }
    
    //http://rolling-rabbits.com/2016/07/21/grand-central-dispatch-in-swift-3/
    private class func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        if tokenTracker.contains(token) {
            return
        }
        tokenTracker.append(token)
        block()
    }
}
