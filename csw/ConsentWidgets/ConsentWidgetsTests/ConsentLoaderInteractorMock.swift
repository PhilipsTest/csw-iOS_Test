import PlatformInterfaces
@testable import ConsentWidgets

public class ConsentLoaderInteractorMock : ConsentsLoaderInteractor {

    var consentDefinitionStatusListToReturn: [ConsentDefinitionStatus]? = []
    var errorToReturn : NSError?
    var postSuccess : Bool = false
    var statusOfConsentToPost: Bool?
    var consentDefinitionToPost: ConsentDefinition?
    var postErrorToReturn: NSError?

    public override func fetchAllConsents(consentDefinitions: [ConsentDefinition], completion: @escaping ([ConsentDefinitionStatus]?, NSError?) -> Void) {
        completion(consentDefinitionStatusListToReturn, errorToReturn)
    }
    
    public override func storeConsentState(withConsentDefinition consentDefinition: ConsentDefinition, withStatus status: Bool, completion : @escaping (_ success : Bool, _ error : NSError? ) -> Void) {
        self.consentDefinitionToPost = consentDefinition
        self.statusOfConsentToPost = status
        completion(postSuccess, postErrorToReturn)
    }
}
