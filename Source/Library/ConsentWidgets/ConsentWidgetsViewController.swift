// Consent Widget
//
// Copyright © Koninklijke Philips N.V., 2017
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import PhilipsUIKitDLS
import AppInfra

public class ConsentWidgetsViewController: BaseViewController, ConsentsViewProtocol, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var concentWidgetsTableView: UITableView?
    var consentsToDisplay : [ConsentViewDataModel] = []
    var consentPresenter : ConsentPresenter!
    weak var privacyDelegate: ConsentWidgetCenterPrivacyProtocol?
    
    var appInfra : AIAppInfra!
    fileprivate var _revokeConsentAlertController: UIDAlertController!
    private var privacyDescriptionContainsSpecialCharacters = false
    
    var revokeConsentAlertController: UIDAlertController {
        get {
            if _revokeConsentAlertController == nil {
                _revokeConsentAlertController = UIDAlertController.init(title: "csw_privacy_settings".localized, message: "mya_csw_consent_revoked_confirm_descr".localized)
            }
            return _revokeConsentAlertController
        }
        set {
            _revokeConsentAlertController = newValue
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.backItem?.title = ""
        self.title = "csw_privacy_settings".localized
        
        self.consentPresenter.attachView(consentsView: self)
        self.consentPresenter.loadAllConsentStatus()
        self.concentWidgetsTableView?.estimatedRowHeight = 100
        self.concentWidgetsTableView?.rowHeight = UITableViewAutomaticDimension
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(false, animated: false)
        self.consentPresenter.trackPage()
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else{
            return consentsToDisplay.count
        }
    }
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.font = UIFont(uidFont:.book, size: UIDFontSizeMedium)
            headerTitle.textLabel?.textColor = UIColor.gray
            headerTitle.contentView.backgroundColor = (UIDThemeManager.sharedInstance.defaultTheme?.contentTertiaryBackground)!
        }
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section == 0 else {
            let cell:ConsentWidgetsTableViewCell = concentWidgetsTableView?.dequeueReusableCell(withIdentifier: "ConsentWidgetsCell") as! ConsentWidgetsTableViewCell
            let consentToDisplay = consentsToDisplay[indexPath.row]
            
            cell.consentSwitch.isOn = consentToDisplay.status
            cell.lblConsentType.text = consentToDisplay.consentText
            cell.consentSwitch.tag = indexPath.row
            cell.consentSwitch.isEnabled = consentToDisplay.isEnabled
            cell.toggleSelectionDelegate = self
            cell.contentView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentPrimary
            let hyperLinkModel : UIDHyperLinkModel = UIDHyperLinkModel()
            cell.lblConsentMeaning.text = "csw_consent_help_label".localized
            cell.lblConsentMeaning.addLink(hyperLinkModel) { [weak self] _ in
                self?.moveToWhatDoesThisMeanController(withHelpText: consentToDisplay.consentDefinition.helpText)
            }
            return cell
            
        }
        let cell:ConsentWidgetsTableViewCell = concentWidgetsTableView?.dequeueReusableCell(withIdentifier: "ConsentWidgetsPrivacyCell") as! ConsentWidgetsTableViewCell!
        self.configurePrivacyNoticeCell(inCell: cell)
        cell.contentView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentPrimary
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard indexPath.section == 0, privacyDescriptionContainsSpecialCharacters == true else {
            return
        }
        self.handlePrivacyLinkTap()
    }

    private func configurePrivacyNoticeCell(inCell: ConsentWidgetsTableViewCell) {
        let localisedPrivacyText = "mya_Privacy_Settings_Desc".localized
        if let textToDisplay = ConsentWidgetViewControllerHelper.getCompletePrivacyStringToDisplay(fromString: localisedPrivacyText) {
            inCell.lblConsentMeaning.text = textToDisplay
            guard let rangeToHighlight = ConsentWidgetViewControllerHelper.getRangeOfHyperlinkedPartOfPrivacyString(fromString: localisedPrivacyText) else {
                privacyDescriptionContainsSpecialCharacters = true
                return
            }
            
            let hyperLinkModel : UIDHyperLinkModel = UIDHyperLinkModel()
            hyperLinkModel.highlightRange = rangeToHighlight
            inCell.lblConsentMeaning?.addLink(hyperLinkModel, handler: { [weak self] (range) in
                if let strongSelf = self {
                    strongSelf.handlePrivacyLinkTap()
                }
            })
        }
    }
    
    func handlePrivacyLinkTap() {
        self.privacyDelegate?.userClickedOnPrivacyURL()
    }
    
    private func moveToWhatDoesThisMeanController(withHelpText: String) {
        ConsentWidgetFlowManager.moveToWhatDoesThisMeanControllerWith(helpText: withHelpText, title: nil, navigationController: self.navigationController)
    }
    
    public func reloadConsentsView() {
        DispatchQueue.main.async(execute: {
            self.concentWidgetsTableView?.reloadData()
        })
    }
    
    public func updateConsentsForView(_ consents: [ConsentViewDataModel]) {
        self.consentsToDisplay = consents
        self.reloadConsentsView()
    }
    
    public func showErrorDialog(errorTitle: String, errorMessage: String, actionText: String, handler: ((UIDAction) -> Void)?) {
        DispatchQueue.main.async {
            let alert = UIDAlertController(title: errorTitle, message: errorMessage)
            let action = UIDAction(title: actionText, style: .primary, handler: handler)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension ConsentWidgetsViewController: ConsentWidgetsToggleProtocol {
    func handleToggleOfWidget(widget: UIDSwitch){
        let viewModelThatWasUpdated = consentsToDisplay[widget.tag]
        viewModelThatWasUpdated.status = widget.isOn
        if hasToConfirmUser(widget, viewModelThatWasUpdated) {
            presentRevokeConsentAlert(withMessage: viewModelThatWasUpdated.consentDefinition.revokeMessage!) { accepted in
                self.consentPresenter.revokeConsentDidFinishWith(action: accepted)
                if accepted {
                    self.consentPresenter.postConsent(data: viewModelThatWasUpdated)                    
                } else {
                    widget.isOn = !widget.isOn
                }
                self._revokeConsentAlertController = nil
            }
        } else {
            self.consentPresenter.postConsent(data: viewModelThatWasUpdated)
        }
    }
    
    fileprivate func presentRevokeConsentAlert(withMessage message: String, _ handler: @escaping (Bool) -> Void) {
        let okAction = UIDAction(title: "mya_csw_consent_revoked_confirm_btn_ok".localized, style: .primary) { action in
            handler(true)
        }
        let cancelAction = UIDAction(title: "mya_csw_consent_revoked_confirm_btn_cancel".localized, style: .secondary) { action in
            handler(false)
        }
        self.revokeConsentAlertController.attributedMessage = message.asRevokeMessage
        self.revokeConsentAlertController.addAction(okAction)
        self.revokeConsentAlertController.addAction(cancelAction)
        self.present(self.revokeConsentAlertController, animated: true, completion: nil)
    }
    
    fileprivate func hasToConfirmUser(_ widget: UIDSwitch, _ viewModelThatWasUpdated: ConsentViewDataModel) -> Bool {
        return !widget.isOn && viewModelThatWasUpdated.consentDefinition.revokeMessage != nil
    }
}


