import UIKit

struct CATKConstants {
    static let successResponseCode                  = 200
    static let successFetchedResponseCode           = 201

    struct ConsentServiceErrorDomain {
        static let FetchConsentError = "Consent Fetch Error"
        static let FetchConsentTypeError = "Consent Type Fetch Error"
        static let StoreConsentTypeError = "Consent Type Store Error"
    }
    
    struct ConsentServiceErrorCode {
        static let FetchConsentErrorCode                    = 3000
        static let FetchConsentTypeErrorDifferentTypeCode   = 3001
        static let FetchConsentTypeVersionErrorCode         = 3002
        static let StoreConsentTypeLocaleErrorCode          = 3003
        static let UserNotLoggedInErrorCode                 = 3004
        static let StoreConsentTypeNoInternetErrorCode      = NSURLErrorNotConnectedToInternet
    }
}
