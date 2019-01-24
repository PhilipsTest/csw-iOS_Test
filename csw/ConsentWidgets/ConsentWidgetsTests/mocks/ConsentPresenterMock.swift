//
//  ConsentPresenterMock.swift
//  ConsentWidgetsTests
//

import Foundation
import PlatformInterfaces
import AppInfra
@testable import ConsentWidgets

class ConsentPresenterMock: ConsentPresenter {
    var postCalled = false
    var postWithStatus: Bool?
    var loadAllConsentStatusIsCalled: Bool = false
    var attachViewIsCalled: Bool = false
    var trackPageIsCalled: Bool = false
    var shouldPostReturnError: Bool = false

    override init(consentDefinitions: [ConsentDefinition], consentsLoaderInteractor: ConsentsLoaderInteractor, taggingInterface: AIAppTaggingProtocol) {
        super.init(consentDefinitions: consentDefinitions, consentsLoaderInteractor: consentsLoaderInteractor, taggingInterface: taggingInterface)
    }

    override func postConsent(data: ConsentViewDataModel) {
        postCalled = true
        guard shouldPostReturnError == false else {
            self.consentsView?.showErrorDialog(errorTitle: "Sample", errorMessage: "Sample", actionText: "OK", handler: nil)
            data.status = !data.status
            postWithStatus = false
            return
        }
        postWithStatus = data.status
    }

    override func trackPage() {
        trackPageIsCalled = true
    }

    override func loadAllConsentStatus() {
        loadAllConsentStatusIsCalled = true
    }

    override func attachView(consentsView: NavigatableConsentsView) {
        attachViewIsCalled = true
    }
}

