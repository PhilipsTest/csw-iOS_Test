// Copyright © Koninklijke Philips N.V., 2018
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

import Foundation
import Quick
import Nimble
import PlatformInterfaces
import AppInfra
@testable import ConsentWidgets

class JustInTimeViewControllerLocalizationSpec : QuickSpec {
    var presenter: ConsentPresenterMock!
    var appInfra: AIAppInfra!
    
    override func spec() {
        let bundle = Bundle(for: ConsentWidgetsViewController.self)
        let tester = LocalizationTester(bundle: bundle)
        
        tester.test { () -> (UIViewController) in
            let jitController = createViewController(withBundle: bundle, consentInteractorValue: true, consentInteractorError: nil, delegate: JustInTimeConsentUserActionMock())
            return wrappedInNavigationController(jitController)
        }
    }
    
    private func wrappedInNavigationController(_ controller: UIViewController) -> UIViewController {
        return UINavigationController(rootViewController: controller)
    }
    
    private func createViewController(withBundle bundle: Bundle, consentInteractorValue: Bool, consentInteractorError: NSError?, delegate: JustInTimeConsentViewProtocol) -> JustInTimeConsentViewController {
        givenAppInfraIsSetTconsenoDefaultUnknown()
        let type1ConsentDefinition = getConsentDefinitionFor(types: ["type1"])
        let storyboard = UIStoryboard(name: "ConsentWidgets", bundle: bundle)
        let jitController = storyboard.instantiateViewController(withIdentifier: "justInTimeConsentWidget") as! JustInTimeConsentViewController
        jitController.justInTimeConsentDelegate = delegate
        jitController.setConsentDefinition(consentDefinition: type1ConsentDefinition)
        jitController.justInTimeUIConfig = JustInTimeUIConfig(inTitle: "Sample", inAcceptButtonTite: "Accept", inCancelButtonTitle: "Cancel")
        let taggingMock = MockAppTagging()
        appInfra = AIAppInfra(builder: nil)
        appInfra.tagging = taggingMock
        jitController.setAppInfra(inAppInfra: appInfra)

        return jitController
    }
    
    private func getConsentDefinitionFor(types: [String]) -> ConsentDefinition {
        return ConsentDefinition(types: types, text: "type consent", helpText: "sample", version: 0, locale: "en-US")
    }
    
    private func givenAppInfraIsSetTconsenoDefaultUnknown(){
        Bundle.loadSwizzler()
        appInfra = AIAppInfra(builder: nil)
        ConsentWidgetsData.sharedInstance.appInfra = appInfra
        appInfra.tagging.setPrivacyConsent(AIATPrivacyStatus.unknown)
    }
}
