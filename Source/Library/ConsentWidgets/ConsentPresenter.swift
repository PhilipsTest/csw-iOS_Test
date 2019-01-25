
 // ConsentPresenter.swift
 // Copyright © Koninklijke Philips N.V., 2017
 // All rights are reserved. Reproduction or dissemination
 // in whole or in part is prohibited without the prior written
 // consent of the copyright holder.


import Foundation
import PlatformInterfaces
import AppInfra
import PhilipsUIKitDLS

struct ConsentPresenterConstants {
    static let timeoutInterval: TimeInterval = 100.0 //seconds
    static let versionMismatchErrorCode = 1252
    static let consentCenterString = "consentCenter"
    
}

public protocol ConsentsViewProtocol: NSObjectProtocol {
    func showProgressIndicator()
    func hideProgressIndicator()
    func updateConsentsForView(_ consents: [ConsentViewDataModel])
    func reloadConsentsView()
    func showErrorDialog( errorTitle: String, errorMessage: String, actionText: String, handler: ((UIDAction) -> Void)?)
}
typealias NavigatableConsentsView = UIViewController & ConsentsViewProtocol

class ConsentPresenter: NSObject {
    weak var consentsView : NavigatableConsentsView?
    var consentDefinitions: [ConsentDefinition]!
    var consentsLoaderInteractor : ConsentsLoaderInteractor
    var appTagging:AIAppTaggingProtocol!

    public init(consentDefinitions: [ConsentDefinition], consentsLoaderInteractor: ConsentsLoaderInteractor, taggingInterface: AIAppTaggingProtocol) {
        self.consentDefinitions = consentDefinitions
        self.consentsLoaderInteractor = consentsLoaderInteractor

        self.appTagging = TaggingHelper.createTaggingInstance(taggingInterface: taggingInterface)
    }
    
    public func attachView(consentsView: NavigatableConsentsView) {
        self.consentsView = consentsView
    }
    
    public func loadAllConsentStatus() {
        self.consentsView?.showProgressIndicator()
        self.consentsLoaderInteractor.fetchAllConsents(consentDefinitions: consentDefinitions, completion: { [weak self] (consentDefinitionStatusList, error) in
            self?.handleConsentDefinitionFetchStatusResponse(consentDefinitionStatusList: consentDefinitionStatusList, error: error)
        })
    }
    
    private func handleConsentDefinitionFetchStatusResponse(consentDefinitionStatusList: [ConsentDefinitionStatus]?, error: NSError?) {
        if error != nil {
            self.consentsView?.hideProgressIndicator()
            self.consentsView?.showErrorDialog(errorTitle: "csw_problem_occurred_error_title".localized, errorMessage: ErrorMessageHelper.getLocalizedErrorMessageBasedOnError(error!), actionText: "csw_ok".localized, handler: {_ in
                self.consentsView?.navigationController?.popViewController(animated: true)
            })
        } else {
            guard let returnedConsentDefinitionStatusList = consentDefinitionStatusList, returnedConsentDefinitionStatusList.count == consentDefinitions.count else {
                self.consentsView?.hideProgressIndicator()
                self.consentsView?.updateConsentsForView([])
                return
            }
            let orderedConsentDefinitionStatusList = self.getOrderedStatusList(consentDefinitionStatus: returnedConsentDefinitionStatusList, consentDefinitions: consentDefinitions)
            self.getViewDataModels(orderedConsentDefinitionStatusList, completion: { [weak self] (consentViewDataModels) in
                self?.consentsView?.hideProgressIndicator()
                self?.consentsView?.updateConsentsForView(consentViewDataModels)
            })
        }
    }
    
    private func getOrderedStatusList(consentDefinitionStatus: [ConsentDefinitionStatus], consentDefinitions: [ConsentDefinition]) -> [ConsentDefinitionStatus] {
        var consentDefinitionMapping: [ConsentDefinition: ConsentDefinitionStatus] = [:]
        for consentDefinitionStatus in consentDefinitionStatus {
            consentDefinitionMapping.updateValue(consentDefinitionStatus, forKey: consentDefinitionStatus.consentDefinition)
        }
        
        var consentDefinitionStatusToReturn: [ConsentDefinitionStatus] = []
        for consentDefinition in consentDefinitions {
            guard let consentStatus = consentDefinitionMapping[consentDefinition] else { continue }
            consentDefinitionStatusToReturn.append(consentStatus)
        }
        return consentDefinitionStatusToReturn
    }

    private func tagConsentAction(data: ConsentViewDataModel){
        let infoDict = TaggingHelper.createTaggingInfoDict(consentStatus: data.status, consentTypes: data.consentDefinition.getTypes())
        self.appTagging.trackAction(withInfo: TaggingHelperConstants.consentActionName, params: infoDict)
    }
    
    public func postConsent(data: ConsentViewDataModel) {
        self.consentsView?.showProgressIndicator()
        self.consentsLoaderInteractor.storeConsentState(withConsentDefinition: data.consentDefinition, withStatus: data.status, completion: { [weak self] success, error in
            if let strongSelf = self {
                strongSelf.consentsView?.hideProgressIndicator()
                if (error != nil) {
                    strongSelf.consentsView?.showErrorDialog(errorTitle: ErrorMessageHelper.getLocalizedErrorTitleBasedOnErrorCode(error!.code), errorMessage: ErrorMessageHelper.getLocalizedErrorMessageBasedOnError(error!), actionText: "csw_ok".localized, handler: nil)
                    strongSelf.resetStatusForData(data)
                    if strongSelf.needsConsentToBeDisabled(error: error!) {
                        data.isEnabled = false
                    }
                    strongSelf.consentsView?.reloadConsentsView()
                    return
                }
                if (success){
                    self?.tagConsentAction(data: data)
                }
            }
        })
    }

    func trackPage() {
        appTagging.trackPage(withInfo: ConsentPresenterConstants.consentCenterString, params: nil)
    }
    
    func revokeConsentDidFinishWith(action: Bool) {
        let infoDictionary = TaggingHelper.createPopUpTagginInfoDictionaryWith(action: action)
        self.appTagging.trackAction(withInfo: TaggingHelperConstants.consentActionName, params: infoDictionary)
    }
    
    fileprivate func resetStatusForData(_ data: ConsentViewDataModel) {
        data.status = !data.status
    }
    
    fileprivate func needsConsentToBeDisabled(error: NSError) -> Bool{
        return error.code == ConsentPresenterConstants.versionMismatchErrorCode
    }
    
    private func getViewDataModels(_ consentDefinitionStatusList : [ConsentDefinitionStatus], completion:@escaping ([ConsentViewDataModel])->()) {
        var consentsStatusViewModel : [ConsentViewDataModel] = []
        guard consentDefinitionStatusList.count == consentDefinitions.count else { completion(consentsStatusViewModel); return }
        
        for consentDefinitionStatus in consentDefinitionStatusList {
            let consentDefinitionObtained = consentDefinitionStatus.consentDefinition
            consentsStatusViewModel.append(ConsentViewDataModel(consentDefinition: consentDefinitionObtained, consentText: consentDefinitionObtained.text, status: (consentDefinitionStatus.status == ConsentStates.active), isEnabled: (consentDefinitionStatus.versionStatus == .inSync || consentDefinitionStatus.versionStatus == .appVersionIsHigher)))
        }
        completion(consentsStatusViewModel)
    }
}

