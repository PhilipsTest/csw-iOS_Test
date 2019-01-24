import UIKit
import UAPPFramework

public class ConsentWidgetsInterface: NSObject, UAPPProtocol {
    
    var appInfra: AIAppInfra
    
    required public init(dependencies: UAPPDependencies, andSettings settings: UAPPSettings?) {
        appInfra = dependencies.appInfra
        ConsentWidgetsData.sharedInstance.appInfra = dependencies.appInfra
    }
    
    public func instantiateViewController(_ launchInput: UAPPLaunchInput, withErrorHandler completionHandler: ((Error?) -> Void)? = nil) -> UIViewController? {
        let viewController: ConsentWidgetsViewController = ConsentWidgetInterfaceUIHelper.instantiateUserInterface() as! ConsentWidgetsViewController
        let consentLaunchInput : ConsentWidgetsLaunchInput = (launchInput as? ConsentWidgetsLaunchInput)!
        viewController.consentPresenter = ConsentPresenter(consentDefinitions: consentLaunchInput.consentDefinitions, consentsLoaderInteractor: ConsentsLoaderInteractor(appInfra: appInfra), taggingInterface: appInfra.tagging!)
        viewController.privacyDelegate = consentLaunchInput.privacyDelegate
        viewController.appInfra = appInfra
        return viewController
    }
}
