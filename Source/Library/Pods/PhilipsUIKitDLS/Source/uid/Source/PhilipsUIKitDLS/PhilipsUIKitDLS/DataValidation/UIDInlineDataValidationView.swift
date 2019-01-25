/** © Koninklijke Philips N.V., 2017. All rights reserved. */

import Foundation
import PhilipsIconFontDLS

/**
 *  UIDInlineDataValidationViewDelegate is a protocol for inline datavalidation view.
 *  This protocal responsible to send event on validation icon-view tapped.
 *
 *  - Since: 3.0.0
 */
@objc
public protocol UIDInlineDataValidationViewDelegate: NSObjectProtocol {
    // send event on validation icon-view tapped.
    /// - Since: 3.0.0
    @objc
    optional func inlineDataValidationView(_ validationView: UIDInlineDataValidationView, iconViewTapped sender: UIView?)
}

/**
 *  A UIDInlineDataValidationView is the standard inline datavalidation view to use as per DLS guideline.
 *  In InterfaceBuilder it is possible to create a UIView and give it the class UIDInlineDataValidationView,
 *  the styling will be done immediately.
 *
 *  - Since: 3.0.0
 */
@IBDesignable
@objcMembers open class UIDInlineDataValidationView: UIView {
    
    /**
     * Set delegate for ValidationView Icon tapped Event.
     *
     * - Since: 3.0.0
     */
    weak open var delegate: UIDInlineDataValidationViewDelegate?
    
    // swiftlint:disable valid_ibinspectable
    /**
     * Set validation message of validationview.
     *
     * Default value is empty string. i.e ""
     *
     * - Since: 3.0.0
     */
    @IBInspectable
    open var validationMessage: String = "" {
        didSet {
            validationMessageLabel?.text = validationMessage
        }
    }
    // swiftlint:enable valid_ibinspectable
    
    /**
     * PhilipsUIKitDLS Theme Reference.
     *
     * Default value is UIDThemeManager's defaultTheme.
     *
     * - Since: 3.0.0
     */
    open var theme = UIDThemeManager.sharedInstance.defaultTheme {
        didSet {
            configureTheme()
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    var validationIconView: UIView?
    private var validationIconLabel: UILabel?
    private var validationMessageView: UIView?
    var validationMessageLabel: UILabel?
    private let tapGestureRecognizer = UITapGestureRecognizer()
    private let iconSize: CGFloat = 8
    
    private func setupViews() {
        addValidationIconView()
        addValidationMessageView()
        addConstraints()
        configureTheme()
    }
    
    private func addValidationIconView() {
        validationIconView = validationIconView ?? newValidationIconView()
        if let validationIconView = validationIconView {
            self.addSubview(validationIconView)
        }
        addGestureRecognizerToValidationIcon()
    }
    
    private func addValidationMessageView() {
        validationMessageView = newValidationMessageView()
        if let validationMessageView = validationMessageView {
            self.addSubview(validationMessageView)
        }
    }
    
    // swiftlint:disable line_length
    private func addConstraints() {
        guard let validationIconView = validationIconView, let validationIconLabel = validationIconLabel,
            let validationMessageView = validationMessageView, let validationMessageLabel = validationMessageLabel else {
            return
        }
        let views = ["iconView": validationIconView,
                     "iconLabel": validationIconLabel,
                     "messageView": validationMessageView,
                     "messageLabel": validationMessageLabel]
        let metrics = ["iconHeight": iconSize * 2,
                       "spacing": iconSize / 2,
                       "messageSpacing": iconSize / 4]
        validationIconView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[iconLabel(==iconView)]",
                                                                          options: .directionLeadingToTrailing,
                                                                          metrics: nil,
                                                                          views: views))
        validationIconView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[iconLabel(==iconView)]",
                                                                          options: .directionLeadingToTrailing,
                                                                          metrics: nil,
                                                                          views: views))
        validationMessageView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[messageLabel]-(spacing)-|",
                                                                             options: .directionLeadingToTrailing,
                                                                             metrics: metrics,
                                                                             views: views))
        validationMessageView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(messageSpacing)-[messageLabel]|",
                                                                             options: .directionLeadingToTrailing,
                                                                             metrics: metrics,
                                                                             views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[iconView(iconHeight)]-(spacing)-[messageView]|",
                                                           options: .directionLeadingToTrailing,
                                                           metrics: metrics,
                                                           views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[iconView(iconHeight)]",
                                                           options: .directionLeadingToTrailing,
                                                           metrics: metrics,
                                                           views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[messageView]|",
                                                           options: .directionLeadingToTrailing,
                                                           metrics: nil,
                                                           views: views))
    }
    // swiftlint:enable line_length
    
    private func newValidationIconView() -> UIView {
        let iconView = UIView.makePreparedForAutoLayout()
        iconView.backgroundColor = UIColor.clear
        validationIconLabel = newValidationIconLabel()
        iconView.addSubview(validationIconLabel!)
        iconView.constrain(toSize: CGSize(width: UIDFontSizeMedium, height: UIDFontSizeMedium))
        return iconView
    }
    
    private func newValidationIconLabel() -> UILabel {
        let iconLabel = UILabel.makePreparedForAutoLayout()
        iconLabel.text = PhilipsDLSIcon.unicode(iconType: .warning)
        iconLabel.font = UIFont.iconFont(size: UIDFontSizeMedium)
        iconLabel.textAlignment = .center
        return iconLabel
    }
    
    private func addGestureRecognizerToValidationIcon() {
        validationIconView!.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.addTarget(self, action: #selector(validationIconTapped))
    }
    
    @objc private func validationIconTapped() {
        delegate?.inlineDataValidationView?(self, iconViewTapped: validationIconView)
    }
    
    private func newValidationMessageView() -> UIView {
        let messageView = UIView.makePreparedForAutoLayout()
        messageView.backgroundColor = UIColor.clear
        validationMessageLabel = newValidationMessageLabel()
        messageView.addSubview(validationMessageLabel!)
        return messageView
    }
    
    private func newValidationMessageLabel() -> UILabel {
        let messageLabel = UILabel.makePreparedForAutoLayout()
        messageLabel.text = validationMessage
        messageLabel.font = UIFont(uidFont: .book, size: UIDFontSizeSmall)
        messageLabel.numberOfLines = 0
        messageLabel.clipsToBounds = true
        return messageLabel
    }
    
    private func configureTheme() {
        validationIconLabel?.textColor = theme?.typographyValidationIcon
        validationMessageLabel?.textColor = theme?.typographyValidationText
    }
}
