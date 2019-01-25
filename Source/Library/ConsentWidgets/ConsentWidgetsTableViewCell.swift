// Consent Widget
//
// Copyright © Koninklijke Philips N.V., 2017
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//
import UIKit
import PhilipsUIKitDLS

protocol ConsentWidgetsToggleProtocol: class {
    func handleToggleOfWidget(widget: UIDSwitch)
}

class ConsentWidgetsTableViewCell: UITableViewCell {
    
    weak var toggleSelectionDelegate: ConsentWidgetsToggleProtocol?
    @IBOutlet weak var lblConsentType: UIDLabel!
    @IBOutlet weak var lblConsentMeaning: UIDHyperLinkLabel!
    @IBOutlet weak var consentSwitch: UIDSwitch!
    
    @IBAction func consentSwitchAction(_ sender: UIDSwitch) {
        self.toggleSelectionDelegate?.handleToggleOfWidget(widget: sender)
    }
    
}
