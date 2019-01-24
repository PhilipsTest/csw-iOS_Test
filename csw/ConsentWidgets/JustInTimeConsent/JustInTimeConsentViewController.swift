//
// JustInTimeConsentViewController.swift
// Copyright © Koninklijke Philips N.V., 2017
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import UIKit
import PhilipsUIKitDLS
import PlatformInterfaces
import AppInfra

struct JITConstants {
    static let jitTaggingConstant = "jitConsent"
}
class JustInTimeConsentViewController: UIViewController {
    @IBOutlet weak var titleLable: UIDLabel!
    @IBOutlet weak var specialOffersLabel: UIDLabel!
    @IBOutlet weak var acceptButton: UIDProgressButton!
    @IBOutlet weak var cancelButton: UIDProgressButton!
    @IBOutlet weak var consentDescription: UIDLabel!
    @IBOutlet weak var whatDoesThisMean: UIDHyperLinkLabel!
    @IBOutlet weak var progressIndicator: UIDProgressIndicator!
    @IBOutlet weak var dialogContainerView: UIDView!
    
    weak var justInTimeConsentDelegate: JustInTimeConsentViewProtocol?
    private(set) var consentDefinition:ConsentDefinition!
    private(set) var justInTimeConsentAPIHelper: JustInTimeConsentAPIService!
    var justInTimeUIConfig: JustInTimeUIConfig!
    private(set) var appInfra:AIAppInfra!
    var consentWidgetFlow: ConsentWidgetFlow.Type = ConsentWidgetFlowManager.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.accessibilityLabel = "csw_justInTimeToolbar_consentToolbar_toolbar"
        self.navigationItem.accessibilityLabel = "csw_justInTimeToolbar_consentToolbarTitle_textView"
        populateViewWithDataModel()
        self.dialogContainerView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentTertiaryBackground
        self.progressIndicator.hidesWhenStopped = true
        self.progressIndicator.progressIndicatorStyle = .indeterminate
        self.progressIndicator.circularProgressIndicatorSize = .medium
        self.progressIndicator.isHidden = true
        let hyperLinkModel : UIDHyperLinkModel = UIDHyperLinkModel()
        self.whatDoesThisMean?.addLink(hyperLinkModel) {[weak self] _ in
            self?.moveToWhatDoesThisMeanController()
        }
        if navigationController?.navigationBar.backItem == nil {
            let btnDone = UIBarButtonItem(title: "✕", style: .done, target: self, action: #selector(crossButtonTapped))
            self.navigationItem.leftBarButtonItem = btnDone
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trackPage(consentTypes: self.consentDefinition.getTypes())
    }
    
    func moveToWhatDoesThisMeanController() {
        consentWidgetFlow.moveToWhatDoesThisMeanControllerWith(helpText: self.consentDefinition.helpText,
                                                                  title: justInTimeUIConfig.title,
                                                                  navigationController: self.navigationController)
    }
    
    func setJustInTimeConsentDelegate(delegate:JustInTimeConsentViewProtocol){
        self.justInTimeConsentDelegate = delegate
    }
    
    func setConsentDefinition(consentDefinition: ConsentDefinition){
        self.consentDefinition = consentDefinition
    }
    
    func setAppInfra(inAppInfra: AIAppInfra) {
        self.appInfra = inAppInfra 
        self.justInTimeConsentAPIHelper = JustInTimeConsentAPIService(appInfra: inAppInfra)
    }
    
    @objc func crossButtonTapped(){
        DispatchQueue.main.async {
            self.justInTimeConsentDelegate?.justInTimeConsentDismissed?()
        }
    }
    
    @IBAction func acceptButtonTapped(_ sender: UIDButton) {
        postConsent(withStatus: true) { [weak self] in
            DispatchQueue.main.async {
                self?.justInTimeConsentDelegate?.justInTimeConsentAccepted()
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIDButton) {
        postConsent(withStatus: false) { [weak self] in
            DispatchQueue.main.async {
                self?.justInTimeConsentDelegate?.justInTimeConsentCancelled()
            }
        }
    }
    
    private func postConsent(withStatus:Bool, completion: @escaping ()->Void)
    {
        self.showProgressIndicator()
        self.justInTimeConsentAPIHelper?.postConsent(consentDefinition: self.consentDefinition, withStatus: withStatus, completion: { [weak self] (result, error) in
            if let strongSelf = self {
                strongSelf.hideProgressIndicator()
                guard error == nil  else{
                    strongSelf.displayError(errorTitle: ErrorMessageHelper.getLocalizedErrorTitleBasedOnErrorCode(error!.code), errorMessage: (ErrorMessageHelper.getLocalizedErrorMessageBasedOnError(error!)), actionText: "csw_ok".localized, handler: nil)
                    return
                }
                if(result){
                    strongSelf.tagConsentAction(consentStatus: withStatus, consentTypes: (strongSelf.consentDefinition.getTypes()))
                }
                completion()
            }
        })
    }
    
    private func tagConsentAction(consentStatus:Bool,consentTypes:[String]) {
        let infoDict = TaggingHelper.createTaggingInfoDict(consentStatus: consentStatus, consentTypes: consentTypes)
        let appTagging = TaggingHelper.createTaggingInstance(taggingInterface: self.appInfra.tagging)
        appTagging?.trackAction(withInfo: TaggingHelperConstants.consentActionName, params: infoDict)
    }
    
    private func trackPage(consentTypes:[String]) {
        let infoDict = [TaggingHelperConstants.consentType: TaggingHelper.createTaggingString(consentTypes: consentTypes)]
        let appTagging = TaggingHelper.createTaggingInstance(taggingInterface: self.appInfra.tagging)
        appTagging?.trackPage(withInfo: JITConstants.jitTaggingConstant, params: infoDict)
    }
    
    func displayOfflineErrorDialogue() {
        displayError(errorTitle: "csw_offline_title".localized, errorMessage: "csw_offline_message".localized, actionText: "csw_ok".localized, handler: nil)
    }
    
    public func displayError(errorTitle: String, errorMessage: String, actionText: String, handler: ((UIDAction) -> Void)?) {
        DispatchQueue.main.async {
            let alert = UIDAlertController(title: errorTitle, message: errorMessage)
            let action = UIDAction(title: actionText, style: .primary, handler: handler)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: Updating UI
extension JustInTimeConsentViewController {
    fileprivate func populateViewWithDataModel(){
        self.titleLable.text =  self.justInTimeUIConfig.userBenefitsTitle
        self.specialOffersLabel.text = self.justInTimeUIConfig.userBenefitsDescription
        self.title = justInTimeUIConfig.title
        self.acceptButton.setTitle(self.justInTimeUIConfig.acceptButtonTitle, for: .normal)
        self.cancelButton.setTitle(self.justInTimeUIConfig.cancelButtonTitle, for: .normal)
        self.whatDoesThisMean.text = "csw_consent_help_label".localized
        self.consentDescription.text = self.consentDefinition.text
    }
    
    fileprivate func showProgressIndicator() {
        self.view.isUserInteractionEnabled = false
        self.progressIndicator.startAnimating()
    }
    
    fileprivate func hideProgressIndicator() {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            self.progressIndicator.stopAnimating()
        }
    }
}


