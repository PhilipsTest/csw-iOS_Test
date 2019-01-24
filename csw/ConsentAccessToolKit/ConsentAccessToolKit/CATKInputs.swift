import AppInfra
import PlatformInterfaces

public class CATKInputs {
    let logging: AILoggingProtocol
    let restClient: AIRESTClientProtocol
    let time: CATKNetworkTime!
    let serviceDiscovery: AIServiceDiscoveryProtocol
    let appConfig: AppConfig
    let consentManager: AIConsentManagerProtocol
    
    var storageProvider: CATKStorageProviderProtocol
    var internationalization: AIInternationalizationProtocol?
    
    public init(logging: AILoggingProtocol,
                restClient: AIRESTClientProtocol,
                serviceDiscovery: AIServiceDiscoveryProtocol,
                internationalization: AIInternationalizationProtocol?,
                appConfig: AppConfig,
                consentManager: AIConsentManagerProtocol,
                userData: UserDataInterface) {
        
        self.storageProvider = CATKStorageProvider()
        self.logging = logging
        self.restClient = restClient
        self.time = CATKNetworkTime()
        self.serviceDiscovery = serviceDiscovery
        self.internationalization = internationalization
        self.consentManager = consentManager
        self.appConfig = appConfig
        
        ConsentServiceURHandler.sharedInstance.setup(withUserData: userData)
    }
}
