// Copyright © Koninklijke Philips N.V., 2018
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

import Foundation
//import Quick
//import Nimble
import AppInfra

import PlatformInterfaces
@testable import ConsentWidgets

class ConsentWidgetsLocalizationSpec : QuickSpec {
    var presenter: ConsentPresenterMock!

    override func spec() {
        let bundle = Bundle(for: ConsentWidgetsViewController.self)
        let tester = LocalizationTester(bundle: bundle)
        let appInfra = AIAppInfra()
        let mockAppTagging = MockAppTagging()

        tester.test { () -> (UIViewController) in
            let storyboard = UIStoryboard(name: "ConsentWidgets", bundle: bundle)
            let controller = storyboard.instantiateViewController(withIdentifier: "ConsentWidgetsViewController") as! ConsentWidgetsViewController

            let consentLoaderInteractorMock = ConsentLoaderInteractorMock(appInfra: appInfra)
            presenter = ConsentPresenterMock(consentDefinitions: [], consentsLoaderInteractor: consentLoaderInteractorMock, taggingInterface: mockAppTagging)
            controller.consentPresenter = presenter

            let consentDefinition = getConsentViewModelFor("moment", true, false, revokeMessage: "whatever")
            controller.consentsToDisplay = [consentDefinition]
            return wrappedInNavigationController(controller)
        }
    }

    private func getConsentViewModelFor(_ type: String,_ status: Bool, _ disabled: Bool, revokeMessage: String) -> ConsentViewDataModel {
        return ConsentViewDataModel(consentDefinition: ConsentDefinition(type: type, text: type + " consent text", helpText: "sample help text", version: 1, locale: "en-US", revokeMessage: revokeMessage), consentText: type + " consent text",  status: status, isEnabled: disabled)
    }

    private func wrappedInNavigationController(_ controller: UIViewController) -> UIViewController {
        return UINavigationController(rootViewController: controller)
    }
}
