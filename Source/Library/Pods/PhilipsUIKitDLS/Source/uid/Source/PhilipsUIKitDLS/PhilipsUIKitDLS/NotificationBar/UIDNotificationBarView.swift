/** © Koninklijke Philips N.V., minimumDescriptionHeight17. All rights reserved. */

import UIKit
import PhilipsIconFontDLS

/**
 *  UIDNotificationBarViewDelegate is a protocol for Notification Bar View.
 *  This protocal responsible to send event on action buttons tapped event.
 *
 *  - Since: 3.0.0
 */
@objc
public protocol UIDNotificationBarViewDelegate: NSObjectProtocol {
    /// - Since: 3.0.0
    @objc optional func notificationBar(_ notificationBar: UIDNotificationBarView, forTapped buttonType: UIDActionButtonType)
}

/**
 * The types of PhilipsUIKit Action bar buttons that are available. In code, you should use these types. Unfortunately,
 * Interface Builder doesn't support enums yet, so if you configure the button in Interface Builder,
 * you have to use the numeric values.
 * - Since: 3.0.0
 */
@objc
public enum UIDActionButtonType: Int {
    /// leading button: should be use for Leading button. (numerical value: 0)
    /// - Since: 3.0.0
    case leading
    /// leading button: should be use for Trailing button. (numerical value: 1)
    /// - Since: 3.0.0
    case trailing
    /// leading button: should be use for Close button. (numerical value: 2)
    /// - Since: 3.0.0
    case close
}

/**
 * The types of PhilipsUIKit notification bar  (UIDNotificationBar) that are available. 
 * In code, you should use these types. Unfortunately,
 * Interface Builder doesn't support enums yet, so if you configure the button in Interface Builder,
 * you have to use the numeric values.
 * - Since: 3.0.0
 */
@objc
public enum UIDNotificationBarType: Int {
    /// textWithAction style: should be use for "text with action buttons". (numerical value: 0)
    /// - Since: 3.0.0
    case textWithAction
    /// textOnly style: should be use for "text only". (numerical value: 1)
    /// - Since: 3.0.0
    case textOnly
}

/// - Since: 3.0.0
@IBDesignable
open class UIDNotificationBarView: UIView {
 
    /**
     * Set delegate for Notification Bar View action button tapped Event.
     *
     * - Since: 3.0.0
     */
   @objc weak open var delegate: UIDNotificationBarViewDelegate?
    
    /**
     * Close Button in Notification Bar View
     *
     * - Since: 3.0.0
     */
  @objc open internal(set) var closeButton: UIButton?
    
    /**
     * Leading Button in Notification Bar View
     *
     * - Since: 3.0.0
     */
  @objc open internal(set) var leadingButton: UIDButton?
    
    /**
     * Trailing Button in Notification Bar View
     *
     * - Since: 3.0.0
     */
    @objc open internal(set) var trailingButton: UIDButton?
    
    private let labelVerticalStackViewSpacing: CGFloat = 8
    private let closeButtonEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    private let shadowOpacity: Float = 0.5
    private let shadowRadius: CGFloat = 5
    private let shadowOffset = CGSize(width: 0, height: 1.0)
    
    /**
     *  Container View inside Notification Bar View which can be used for custom notification bar
     * - Since: 3.0.0
     */
   @objc public var contentView: UIView?

    var bottomVerticalStackView: UIStackView?
    var iconVerticalStackView: UIStackView?
    var verticalTitleStackView: UIStackView?
    var verticalDescriptionStackView: UIStackView?
    var bottomHorizontalStackView: UIStackView?
    var notificationTitleLabel: UILabel?
    var notificationDescriptionLabel: UILabel?
    var notificationVerticalStackView: UIStackView?
    var views: [String: Any] = [:]
    var metrics: [String: Any] = [:]
    
    /**
     *  Configure the control's theme.
     *  - Since: 3.0.0
     */
    @objc open var theme: UIDTheme? = UIDThemeManager.sharedInstance.defaultTheme {
        didSet {
            configureTheme()
        }
    }
    
    /**
     *  Get or set the title text.
     *
     *  - Since: 3.0.0
     */
    @IBInspectable
    @objc open var titleMessage: String = "" {
        didSet {
            notificationTitleLabel?.text = titleMessage
            verticalTitleStackView?.isHidden = titleMessage.count == 0
        }
    }
    
    /**
     *  Get or set the description text.
     *
     *  - Since: 3.0.0
     */
    @IBInspectable
   @objc open var descriptionMessage: String = "" {
        didSet {
            notificationDescriptionLabel.ifNotNil {
                $0.text(descriptionMessage, lineSpacing: UIDLineSpacing)
                verticalDescriptionStackView?.isHidden = descriptionMessage.count == 0
            }
        }
    }
    
    /**
     *  Get or set whether the Notification Bar is accented or not.
     *
     *  - Since: 3.0.0
     */
    
    @IBInspectable
   @objc public var isAccent: Bool = false {
        didSet {
            configureTheme()
        }
    }
    
    /**
     * The type of the notification bar.
     * Updates the constraints for notification bar when set.
     * Defaults to NotificationBarType.textWithAction
     * - Since: 3.0.0
     */
   @objc open var notificationBarType: UIDNotificationBarType = .textWithAction {
        didSet {
            configureConstraint()
            bottomHorizontalStackView?.isHidden = notificationBarType == .textOnly
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        instanceInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        instanceInit()
        isAccent = !(!isAccent)
    }
    
    func instanceInit() {
        setUpViews()
        configureTheme()
        notificationTitleLabel?.text = titleMessage
        notificationDescriptionLabel.ifNotNil {
            $0.text(descriptionMessage, lineSpacing: UIDLineSpacing)
        }
        titleMessage = {return titleMessage}()
        descriptionMessage = {return descriptionMessage}()
    }
    
    private func setUpViews() {
        translatesAutoresizingMaskIntoConstraints = false
        setUpShadowForNotificationBar()
        setUpCustomContainerView()
        setUpStackViews()
    }
    
    private func setUpShadowForNotificationBar() {
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowColor = theme?.shadowLevelTwoShadow?.cgColor
    }
    
    private func setUpCustomContainerView() {
        contentView = UIView(frame: self.bounds)
        contentView?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView!)
    }
    
    private func setUpStackViews() {
        setUpTopStackViews()
        setUpBottomStackViews()
        setUpMetrics()
    }
    
    private func setUpTopStackViews() {
        notificationVerticalStackView = verticalStackView()
        verticalTitleStackView = verticalStackView()
        verticalDescriptionStackView = verticalStackView()
        iconVerticalStackView = verticalStackView()
        notificationTitleLabel = titleLabel()
        notificationDescriptionLabel = descriptionLabel()
        closeButton = createCloseButton()
        if let notificationVerticalStackView = notificationVerticalStackView,
            let verticalTitleStackView = verticalTitleStackView,
            let verticalDescriptionStackView = verticalDescriptionStackView,
            let iconVerticalStackView = iconVerticalStackView,
            let notificationTitleLabel = notificationTitleLabel,
            let notificationDescriptionLabel = notificationDescriptionLabel,
            let closeButton = closeButton {
            notificationVerticalStackView.spacing = labelVerticalStackViewSpacing
            contentView?.addSubview(notificationVerticalStackView)
            notificationVerticalStackView.addArrangedSubview(verticalTitleStackView)
            notificationVerticalStackView.addArrangedSubview(verticalDescriptionStackView)
            contentView?.addSubview(iconVerticalStackView)
            verticalTitleStackView.addArrangedSubview(notificationTitleLabel)
            verticalDescriptionStackView.addArrangedSubview(notificationDescriptionLabel)
            iconVerticalStackView.addArrangedSubview(closeButton)
        }
    }
    
    private func setUpBottomStackViews() {
        bottomVerticalStackView = verticalStackView()
        bottomHorizontalStackView = horizontalStackView()
        leadingButton = quietButton()
        trailingButton = quietButton()
        if let bottomVerticalStackView = bottomVerticalStackView,
            let bottomHorizontalStackView = bottomHorizontalStackView,
            let leadingButton = leadingButton,
            let trailingButton = trailingButton {
            contentView?.addSubview(bottomVerticalStackView)
            bottomVerticalStackView.addArrangedSubview(bottomHorizontalStackView)
            
            let edgeInsets = UIEdgeInsets(top: UIDSize8, left: 0, bottom: UIDSize8, right: 0)
            bottomHorizontalStackView.isLayoutMarginsRelativeArrangement = true
            bottomHorizontalStackView.layoutMargins = edgeInsets
            
            leadingButton.addTarget(self, action: #selector(leadingButtonTapped(_:)), for: .touchUpInside)
            trailingButton.addTarget(self, action: #selector(trailingButtonTapped(_:)), for: .touchUpInside)
            bottomHorizontalStackView.addArrangedSubview(leadingButton)
            bottomHorizontalStackView.addArrangedSubview(trailingButton)
        }
    }
    
    private func titleLabel() -> UILabel? {
        notificationTitleLabel = UILabel.makePreparedForAutoLayout()
        notificationTitleLabel?.numberOfLines = 0
        notificationTitleLabel?.font = UIFont(uidFont:.medium, size: UIDFontSizeMedium)
        notificationTitleLabel?.sizeToFit()
        return notificationTitleLabel
    }
    
    private func descriptionLabel() -> UILabel? {
        notificationDescriptionLabel = UILabel.makePreparedForAutoLayout()
        notificationDescriptionLabel?.numberOfLines = 0
        notificationDescriptionLabel?.font = UIFont(uidFont:.book, size: 14)
        notificationDescriptionLabel?.sizeToFit()
        return notificationDescriptionLabel
    }
    
    private func createCloseButton() -> UIButton? {
        closeButton = UIButton.makePreparedForAutoLayout()
        closeButton?.backgroundColor = UIColor.clear
        closeButton?.titleLabel?.isHidden = false
        
        closeButton?.titleLabel?.font = UIFont.iconFont(size: UIDFontSizeMedium)
        closeButton?.setTitle(PhilipsDLSIcon.unicode(iconType: .crossBold32), for: .normal)
        
        closeButton?.setTitleColor(UIColor.black, for: .normal)
        closeButton?.titleEdgeInsets = closeButtonEdgeInsets
        closeButton?.addTarget(self, action: #selector(hideNotificationBar), for: .touchUpInside)
        return closeButton
    }
    
    @objc open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        let views = ["v": self]
        let view = self.superview
        guard let parentView = view else {
            return
        }
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v]-0-|",
                                                                 options: .directionLeadingToTrailing,
                                                                 metrics: nil,
                                                                 views: views))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v]",
                                                                 options: .directionLeadingToTrailing,
                                                                 metrics: nil,
                                                                 views: views))
        layoutIfNeeded()
    }
}
