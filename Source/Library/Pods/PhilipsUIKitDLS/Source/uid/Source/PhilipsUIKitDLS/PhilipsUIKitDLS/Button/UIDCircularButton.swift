/* Copyright (c) Koninklijke Philips N.V., 2018
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsIconFontDLS

/**
 * The types of UIDCircularButtonType buttons that are available. In code, you should use these types.
 * Unfortunately, Interface Builder doesn't support enums yet, so if you configure the button in Interface
 * Builder, you have to use the numeric values.
 *
 * - Since: 1805.0.0
 */
@objc
public enum UIDCircularButtonType: Int {
    /// Regular Circular button: The regular variant of the Circular Button (numerical value: 0)
    /// - Since: 1805.0.0
    case regular
    /// Large circular button: The large variant of the Circular Button (numerical value: 1)
    /// - Since: 1805.0.0
    case large
}

/**
 *  A UIDCircularButton is the circular DLS button to use.
 *  In InterfaceBuilder it is possible to create a UIButton and give it the class UIDCircularButton, the
 *  styling will be done immediately.
 *
 *  **Please note:** The button must have type "Custom" (`UIButtonTypeCustom`) in order to work correctly.
 * - Since: 1805.0.0
 */
@IBDesignable
@objcMembers open class UIDCircularButton: UIButton {
    
    /**
     * The DLS icon to show on the button.
     * Updates the button title when set to show the Icon.
     *
     * Defaults to empty
     *
     * - Since: 1805.0.0
     */
    open var icon: PhilipsDLSIconType? {
        didSet {
            configureIcon()
        }
    }
    
    /**
     *  Get or set whether the Circular Button is accented or not.
     *
     *  - Since: 1805.0.0
     */
    @IBInspectable
    public var isAccent: Bool = false {
        didSet {
            configureTheme()
        }
    }

    /**
     * The type of the circular button.
     * Updates the button sizing when set.
     *
     * Defaults to UIDCircularButtonType.regular
     *
     * - Since: 1805.0.0
     */
    @IBInspectable
    public var circularButtonType: UIDCircularButtonType = .regular {
        didSet {
            layoutSubviews()
        }
    }

    /**
     * The UIDTheme of the circular button.
     * Updates the button styling when set.
     *
     * Defaults to UIDThemeManager.sharedInstance.defaultTheme
     *
     * - Since: 1805.0.0
     */
    public var theme: UIDTheme? = UIDThemeManager.sharedInstance.defaultTheme {
        didSet {
            configureTheme()
        }
    }
    
    open override var isHighlighted: Bool {
        didSet {
            if oldValue != isHighlighted {
                configureTheme()
            }
        }
    }
    
    open override var isEnabled: Bool {
        didSet {
            if oldValue != isEnabled {
                configureTheme()
            }
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width :buttonSize, height : buttonSize)
    }

    private var buttonSize: CGFloat {
        return circularButtonType == .regular ? UIDSize42 : UIDSize56
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        instanceInit()
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        instanceInit()
    }

    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        instanceInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width * 0.5
    }
}

// MARK: Helper methods

extension UIDCircularButton {

    private func instanceInit() {
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.isHidden = false
        imageView?.isHidden = true
        contentEdgeInsets  = .zero
        clearStyles()
        configureTheme()
        configureIcon()
    }

    private func clearStyles() {
        let states: [UIControlState] = [.normal, .highlighted, .disabled, .selected]
        states.forEach {
            setImage(nil, for: $0)
            setTitle(nil, for: $0)
            setTitleColor(nil, for: $0)
            setBackgroundImage(nil, for: $0)
        }
    }

    private func configureIcon() {
        guard let icon = icon else { return }
        let states: [UIControlState] = [.normal, .highlighted, .disabled, .selected]
        let font = UIFont.iconFont(size: UIDSize24)
        let title = PhilipsDLSIcon.unicode(iconType: icon)
        titleLabel?.font = font
        states.forEach { setTitle(title, for: $0) }
    }

    private func configureTheme() {
        guard let theme = theme else { return }
        
        let normalBackgroundColor, highlightBackgroundColor, disabledBackgroundColor,
        normalIconColor, highlightIconColor, disabledIconColor: UIColor?

        normalBackgroundColor = isAccent ?
            theme.buttonAccentBackground :
            theme.buttonPrimaryBackground
        highlightBackgroundColor = isAccent ?
            theme.buttonAccentPressedBackground :
            theme.buttonPrimaryPressedBackground
        disabledBackgroundColor = isAccent ?
            theme.buttonAccentDisabledBackground :
            theme.buttonPrimaryDisabledBackground

        normalIconColor = isAccent ?
            theme.buttonAccentIcon :
            theme.buttonPrimaryIcon
        highlightIconColor = isAccent ?
            theme.buttonAccentIcon :
            theme.buttonPrimaryIcon
        disabledIconColor = isAccent ?
            theme.buttonAccentDisabledIcon :
            theme.buttonPrimaryDisabledIcon

        backgroundColor = isEnabled ?
            (isHighlighted ?
                highlightBackgroundColor :
                normalBackgroundColor) :
        disabledBackgroundColor
        
        setTitleColor(normalIconColor, for: .normal)
        setTitleColor(highlightIconColor, for: .highlighted)
        setTitleColor(disabledIconColor, for: .disabled)
        
        configureShadow()
    }

    private func configureShadow() {
        if let theme = theme {
            let dropShadow = UIDDropShadow(level: .level2, theme: theme)
            apply(dropShadow: dropShadow)
        }
    }
}
