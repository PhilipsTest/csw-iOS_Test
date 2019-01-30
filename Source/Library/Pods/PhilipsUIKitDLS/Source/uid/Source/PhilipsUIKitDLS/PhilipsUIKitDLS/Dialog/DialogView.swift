/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

let paddingXEdgeToContainer: CGFloat = 24
let spacingTitleToContainer: CGFloat = 24
let paddingYEdgeToTextContainer: CGFloat = 24
let paddingToMainView: CGFloat = 24

class DialogView: UIView {
    var theme: UIDTheme? = UIDThemeManager.sharedInstance.whiteTheme {
        didSet {
            configureTheme()
        }
    }
    
    var maxWidthConstraint: NSLayoutConstraint!
   @objc open var maxWidth: CGFloat = max(UIScreen.main.bounds.maxX, UIScreen.main.bounds.maxY) {
        didSet {
            maxWidthConstraint.constant = maxWidth
        }
    }
    
    let mainContentView = UIView.makePreparedForAutoLayout()
    
    let dialogStackView = UIStackView.makePreparedForAutoLayout()
    
    let titleContentView = DialogTitleContentView.makePreparedForAutoLayout()
    
    let containerStackView = UIStackView.makePreparedForAutoLayout()
    
    var contentView: UIView? {
        didSet {
            containerStackView.removeArrangedSubviews(containerStackView.arrangedSubviews)
            if let contentView = contentView {
                containerStackView.addArrangedSubview(contentView)
            }
        }
    }
    
    let explanatoryStackView = UIStackView.makePreparedForAutoLayout()
    
    let actionButtonsView = DialogButtonContainer.makePreparedForAutoLayout()
    
    let separators = [UIDSeparator.makePreparedForAutoLayout(),
                      UIDSeparator.makePreparedForAutoLayout()]
    
    var actionButtons: [UIDButton]! {
        didSet {
            actionButtonsView.actionButtons = actionButtons
        }
    }
    
    var title: String? {
        didSet {
            titleContentView.title = title
            titleContentView.isHidden = title == nil
        }
    }
    var image: UIImage? {
        didSet {
            titleContentView.image = image
        }
    }
    
    var isCloseVisible: Bool = false {
        didSet {
            titleContentView.isCloseVisible = isCloseVisible
        }
    }
    
   @objc open var isSeparatorVisible: Bool = false {
        didSet {
            separators.forEach { $0.isHidden = !isSeparatorVisible }
        }
    }
    
   @objc required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        instanceInit()
    }
    
   @objc override public init(frame: CGRect) {
        super.init(frame: frame)
        instanceInit()
    }
    
    private func instanceInit() {
        configureContentView()
        configureDialogStackView()
        configureSeparators()
        setupDropShadow()
        arrangeContent()
        configureTheme()
    }
}

extension DialogView {
    func configureTheme() {
        guard let theme = theme else { return }
        separators.forEach { $0.theme = theme }
        actionButtonsView.theme = theme
        titleContentView.theme = theme
    }
    
    func arrangeContent() {
        explanatoryStackView.axis = .vertical
        titleContentView.isHidden = title == nil
        isSeparatorVisible = !(!isSeparatorVisible)
        explanatoryStackView.addArrangedSubviews([titleContentView, separators[0], containerStackView])
        dialogStackView.addArrangedSubviews([explanatoryStackView, separators[1], actionButtonsView])
    }
    
    func configureSeparators() {
        separators.forEach {
            $0.removeConstraints($0.constraints)
            let const = NSLayoutConstraint(item: $0,
                                           attribute: .height,
                                           relatedBy: .equal,
                                           toItem: nil,
                                           attribute: .notAnAttribute,
                                           multiplier: 0,
                                           constant: 1)
            const.priority = UILayoutPriority(rawValue: 999)
            const.isActive = true
        }
    }
    
    func configureContentView() {
        addSubview(mainContentView)
        mainContentView.constrainCenterToParent()
        let bindingViewsInfo: [String:UIView] = ["mainContentView": mainContentView]
        var visualConstraints = [String]()
        let metrics: [String : Any] = ["paddingToMainView": paddingToMainView]
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                mainContentView.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor,
                                                     constant: paddingToMainView),
                mainContentView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor,
                                                        constant: paddingToMainView)
                ])
        } else {
            visualConstraints.append("V:|-(>=paddingToMainView)-[mainContentView]-(>=paddingToMainView)-|")
        }
        visualConstraints.append("H:|-(>=paddingToMainView)-[mainContentView]-(>=paddingToMainView)-|")
        addConstraints(visualConstraints,
                       metrics: metrics,
                       views: bindingViewsInfo)
        
        maxWidthConstraint = NSLayoutConstraint(item: mainContentView, attribute: .width,
                                                relatedBy: .equal,
                                                toItem: nil, attribute: .notAnAttribute,
                                                multiplier: 1, constant: maxWidth)
        maxWidthConstraint.priority = UILayoutPriority(rawValue: 900)
        mainContentView.addConstraint(maxWidthConstraint)
        
        mainContentView.backgroundColor = theme?.popupDefaultBackground
        mainContentView.cornerRadius = UIDCornerRadius
        mainContentView.layoutIfNeeded()
    }
    
    func configureDialogStackView() {
        mainContentView.addSubview(dialogStackView)
        dialogStackView.axis = .vertical
        dialogStackView.distribution = .fill
        let edgeInsets = UIEdgeInsets(top: paddingYEdgeToTextContainer, left: 0, bottom: 0, right: 0)
        dialogStackView.isLayoutMarginsRelativeArrangement = true
        dialogStackView.layoutMargins = edgeInsets
        
        var visualConstraints = [String]()
        visualConstraints.append("H:|[dialogStackView]|")
        visualConstraints.append("V:|[dialogStackView]|")
        let bindingViewsInfo: [String : UIView] = ["dialogStackView": dialogStackView]
        mainContentView.addConstraints(visualConstraints, metrics: nil, views: bindingViewsInfo)
    }
    
    fileprivate func setupDropShadow() {
        if let theme = theme {
            let dropShadow = UIDDropShadow(level: .level3, theme: theme)
            mainContentView.apply(dropShadow: dropShadow)
        }
    }
}
