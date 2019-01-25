/* Copyright (c) Koninklijke Philips Electronics N.V. 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

/**
 * The types of Notification Badge (UIDNotificationBadgeLabel) that are available.
 * In code, you should use these types. Unfortunately, Interface Builder doesn't support enums yet,
 * so if you configure the Notification Badge in Interface Builder, you have to use the numeric values.
 *
 * - Since: 3.0.0
 */
@objc
public enum UIDNotificationBadgeType: Int {
    /// default NotificationBadge: (numerical value: 0)
    /// - Since: 3.0.0
    case normal
    /// small NotificationBadge: (numerical value: 1)
    /// - Since: 3.0.0
    case small
}

private let defaultNotificationBadgeHeight: CGFloat = 24
private let smallNotificationBadgeHeight: CGFloat = 20
private let notificationBadgeExceedText: String = "9999+"
private let notificationBadgeMargin: CGFloat = 8

/**
 *  A UIDNotificationBadgeLabel is the standard Notification-Badge to use as per DLS guideline.
 *  In InterfaceBuilder it is possible to create a UIView and give it the class UIDNotificationBadgeLabel,
 *  the styling will be done immediately.
 *
 *  @note Use "badgeCount" API to update the notification badge count any-time. @see badgeCount
 *
 *  - Since: 3.0.0
 */
@IBDesignable
@objcMembers open class UIDNotificationBadgeLabel: UILabel {
    
    /**
     * PhilipsUIKitDLS Theme Reference.
     *
     * Default value is UIDThemeManager's defaultTheme.
     *
     * - Since: 3.0.0
     */
    open var theme = UIDThemeManager.sharedInstance.defaultTheme {
        didSet {
            configureBadge()
        }
    }
    
    // swiftlint:disable valid_ibinspectable
    /**
     * Type of badge.
     *
     * Default value is UIDNotificationBadgeType.default.
     *
     * - Since: 3.0.0
     */
    @IBInspectable
    open var badgeType: UIDNotificationBadgeType = .normal {
        didSet {
            configureBadge()
        }
    }
    // swiftlint:enable valid_ibinspectable
    
    /**
     * Use this API to update the badge-count anytime.
     *
     * Default value is 0.
     *
     * - Since: 3.0.0
     */
    @IBInspectable
    open var badgeCount: Int = 0 {
        didSet {
            text = badgeCount > UIDNotificationBadgeMaxCount ? notificationBadgeExceedText : String(badgeCount)
            badgeLabel?.text = text
        }
    }
    
    /**
     *  Get or set whether the Notification Badge Label is accented or not.
     *
     *  - Since: 3.0.0
     */
    @IBInspectable
    public var isAccent: Bool = false {
        didSet {
            configureTheme()
        }
    }
    
    override open var text: String? {
        didSet {
            configureBadge()
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: badgeWidth, height: badgeHeight)
    }
    
    ///Internal Variables
    var backgroundView: UIView?
    var badgeLabel: UILabel?
    
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
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        instanceInit()
    }
    
    private func instanceInit() {
        configureViews()
        configureBadge()
        configureTheme()
    }
    
    private func configureViews() {
        (backgroundView, badgeLabel) = (UIView.makePreparedForAutoLayout(), UILabel.makePreparedForAutoLayout())
        if let backgroundView = backgroundView, let badgeLabel = badgeLabel, let theme = theme {
            badgeLabel.textAlignment = .center
            badgeLabel.baselineAdjustment = .alignCenters
            configureAutolayoutConstraints(parentView: self, childView: backgroundView)
            configureAutolayoutConstraints(parentView: backgroundView, childView: badgeLabel)
            let dropShadow = UIDDropShadow(level: .level1, theme: theme)
            backgroundView.apply(dropShadow: dropShadow)
        }
    }
    
    private func configureAutolayoutConstraints(parentView: UIView, childView: UIView) {
        parentView.addSubview(childView)
        let views: [String: UIView] = ["childView": childView]
        var visualFormatConstraints = [String]()
        visualFormatConstraints.append("H:|[childView]|")
        visualFormatConstraints.append("V:|[childView]|")
        parentView.addConstraints(visualFormatConstraints, metrics: nil, views: views)
    }
}

private extension UIDNotificationBadgeLabel {
    func configureBadge() {
        isHidden = badgeCount < 1
        font = UIFont(uidFont:.book, size: badgeType.fontSize)
        badgeLabel?.font = UIFont(uidFont:.book, size: badgeType.fontSize)
        badgeLabel?.textAlignment = .center
        badgeLabel?.baselineAdjustment = .alignCenters
        backgroundView?.layer.cornerRadius = badgeType.fontSize
        badgeLabel?.layer.cornerRadius = badgeType.fontSize
        invalidateIntrinsicContentSize()
    }
    
    func configureTheme() {
        backgroundColor = .clear
        badgeLabel?.textColor = isAccent ? theme?.notificationBadgeAccentText : theme?.notificationBadgeDefaultText
        backgroundView?.backgroundColor = isAccent ? theme?.notificationBadgeAccentBackground : theme?.notificationBadgeDefaultBackground
    }
    
    var badgeWidth: CGFloat {
        return width > badgeHeight ? width : badgeHeight
    }
    
    var badgeHeight: CGFloat {
        return badgeType.height
    }
}

private extension UIDNotificationBadgeType {
    var height: CGFloat {
        return self == .normal ? defaultNotificationBadgeHeight : smallNotificationBadgeHeight
    }
    
    var fontSize: CGFloat {
        return height / 2
    }
}

private extension UILabel {
    var width: CGFloat {
        let labelSize = sizeToFit(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                         height: defaultNotificationBadgeHeight))
        return labelSize.width + notificationBadgeMargin
    }
}
