/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsIconFontDLS

let paddingXEdgeToTitle: CGFloat = 24
let paddingYTitleToContainer: CGFloat = 20
let paddingXCloseToContainer: CGFloat = 12
let dialogTitleContainerInterSpacing: CGFloat = 8
let titleLineHeight: CGFloat = 24

class DialogTitleContentView: UIView {
    var theme: UIDTheme? = UIDThemeManager.sharedInstance.whiteTheme {
        didSet {
            configureTheme()
        }
    }

    let titleContentStackView = UIStackView.makePreparedForAutoLayout()
    
    let iconImageView = UIImageView.makePreparedForAutoLayout()
    
    let titleLabel = UIDLabel.makePreparedForAutoLayout()
    
    let closeButton =  UIButton.makePreparedForAutoLayout()
    
    var title: String? {
        didSet {
            if let title = title,
                let paragraphStyle = NSMutableParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle,
                let titleFont = UIFont(uidFont:.bold, size: UIDFontSizeLarge),
                let messageColor = theme?.contentItemPrimaryText {
                paragraphStyle.lineSpacing = titleLineHeight - UIDFontSizeLarge
                let attributes = [NSAttributedStringKey.font: titleFont,
                                  .paragraphStyle: paragraphStyle,
                                  .foregroundColor: messageColor]
                let attributedString = NSAttributedString(string: title, attributes: attributes)
                titleLabel.attributedText = attributedString
            } else {
                titleLabel.attributedText = nil
            }
        }
    }
    
    var image: UIImage? {
        didSet {
            iconImageView.isHidden = image == nil
            iconImageView.image = image
        }
    }
    
    var isCloseVisible: Bool = false {
        didSet {
            closeButton.isHidden = !isCloseVisible
            configureContentEdgeInsets()
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
        setupIconView()
        setupTitleLabel()
        setupCloseButton()
        setupTitleContentStackView()
        arrangeContent()
        configureTheme()
    }
    
    func configureTheme() {
        titleLabel.theme = theme
    }
    
    func setupTitleLabel() {
        titleLabel.customFont = true
        titleLabel.font = UIFont(uidFont:.bold, size: UIDFontSizeLarge)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required,
                                                           for: .vertical)
    }
    
    func setupIconView() {
        iconImageView.isHidden = true
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.backgroundColor = UIColor.clear
        iconImageView.tintColor = theme?.contentItemSecondaryText
        iconImageView.constrain(toSize: CGSize(width: UIDIconSize, height: UIDIconSize), layoutPriority: 999)
    }
    
    func setupCloseButton() {
        closeButton.titleLabel?.font = UIFont.iconFont(size: UIDFontSizeMedium)
        closeButton.setTitle(PhilipsDLSIcon.unicode(iconType: .crossBold32), for: .normal)
        closeButton.setTitleColor(UIColor.black, for: .normal)
        closeButton.constrain(toSize: CGSize(width: UIDIconSize, height: UIDIconSize), layoutPriority: 999)
        closeButton.isHidden = true
    }

    func arrangeContent() {
        var visualConstraints = [String]()
        visualConstraints.append("H:|-(0@999)-[titleContentStackView]-(0@999)-|")
        visualConstraints.append("V:|-(0@999)-[titleContentStackView]-(0@999)-|")
        let bindingViewsInfo: [String:UIView] = ["titleContentStackView": titleContentStackView]
        addConstraints(visualConstraints, metrics: nil, views: bindingViewsInfo)
    }
    
    func setupTitleContentStackView() {
        titleContentStackView.axis = .horizontal
        titleContentStackView.distribution = .fill
        titleContentStackView.alignment = .top
        titleContentStackView.spacing = dialogTitleContainerInterSpacing
        addSubview(titleContentStackView)
        configureContentEdgeInsets()
        titleContentStackView.addArrangedSubviews([iconImageView, titleLabel, closeButton])
    }
    
    func configureContentEdgeInsets() {
        let edgeInsets = UIEdgeInsets(top: 0, left: paddingXEdgeToTitle,
                                      bottom: paddingYTitleToContainer,
                                      right:  isCloseVisible ? paddingXCloseToContainer: paddingXEdgeToTitle)
        titleContentStackView.isLayoutMarginsRelativeArrangement = true
        titleContentStackView.layoutMargins = edgeInsets
    }
}
