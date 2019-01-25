// Consent Widget
//
// Copyright © Koninklijke Philips N.V., 2017
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import UIKit
import PhilipsUIKitDLS

public class BaseViewController: UIViewController, UIDNotificationBarViewDelegate {
    @IBOutlet var progressIndicator: UIDProgressIndicator?

    override public func viewDidLoad() {
        super.viewDidLoad()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if self.progressIndicator?.isHidden == false {
            self.progressIndicator?.startAnimating()
        }
    }

    //MARK: Progress Indicator Show & Hide
    public func showProgressIndicator() {
        DispatchQueue.main.async(execute: {
            self.progressIndicator?.isHidden = false
            self.progressIndicator?.startAnimating()
        })
    }

    public func hideProgressIndicator() {
        DispatchQueue.main.async(execute: {
            self.progressIndicator?.isHidden = true
            self.progressIndicator?.stopAnimating()
        })
    }
    
    func showNotificationBarErrorView(withTitle errorMessage: String) {
        let errorAlert = UIAlertController(title: "Offline", message: "There seems to be a problem with your internet connection. Please check and try again".localized, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler:  { _ in self.hideProgressIndicator()})
        errorAlert.addAction(action)
        self.present(errorAlert, animated: true, completion: nil)
    }
}
