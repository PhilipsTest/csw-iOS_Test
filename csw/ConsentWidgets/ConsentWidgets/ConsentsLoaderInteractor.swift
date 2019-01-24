import PlatformInterfaces
import AppInfra

public class ConsentsLoaderInteractor {
    var appInfra: AIAppInfra!
    
    public init(appInfra: AIAppInfra) {
        self.appInfra = appInfra
    }
    
    public func fetchAllConsents(consentDefinitions: [ConsentDefinition], completion: @escaping ([ConsentDefinitionStatus]?, NSError?) -> Void) {
        self.appInfra.consentManager.fetchConsentStates(forConsentDefinitions: consentDefinitions) { (consentDefinitionStatuses, error) in
            completion(consentDefinitionStatuses, error)
        }
    }
    
    public func storeConsentState(withConsentDefinition: ConsentDefinition, withStatus: Bool, completion: @escaping (Bool, NSError?) -> Void) {
        self.appInfra.consentManager.storeConsentState(consent: withConsentDefinition, withStatus: withStatus) { (result, error) in
            completion(result, error)
        }
    }
}
