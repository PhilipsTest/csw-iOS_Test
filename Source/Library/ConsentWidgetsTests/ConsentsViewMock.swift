import Foundation
import PhilipsUIKitDLS
@testable import ConsentWidgets

class ConsentsViewMock : UIViewController, ConsentsViewProtocol {
    var updateConsentsForViewCalled = false
    var consentsToDisplay : [ConsentViewDataModel]?
    
    var showErrorCalled = false
    var errorMessage : String?
    var errorTitle : String?
    var actionText :  String?
    
    var progressIndicatorShown = false
    var progressIndicatorHidden = false
    var viewReloaded = false
    
    func updateConsentsForView(_ consents : [ConsentViewDataModel]) {
        updateConsentsForViewCalled = true
        consentsToDisplay = consents
    }
    func showProgressIndicator() {
        progressIndicatorShown = true
    }
    func hideProgressIndicator() {
        progressIndicatorHidden = true
    }
    
    func showErrorDialog(errorTitle: String, errorMessage: String, actionText: String, handler: ((UIDAction) -> Void)?) {
        showErrorCalled = true
        self.errorTitle = errorTitle
        self.errorMessage = errorMessage
        self.actionText = actionText
        handler?(UIDAction())
    }
    
    func reloadConsentsView() {
        self.viewReloaded = true
    }
    
}
