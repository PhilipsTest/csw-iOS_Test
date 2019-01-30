//  Copyright © 2016 Philips. All rights reserved.

import UIKit

/**
 * The types of PhilipsUIKit buttons  (UIDButton) that are available. In code, you should use these types. Unfortunately,
 * Interface Builder doesn't support enums yet, so if you configure the button in Interface Builder,
 * you have to use the numeric values.
 * - Since: 3.0.0
 */
@objc
public enum UIDButtonType: Int {
    /// Primary button: uses primary theme color as background color (numerical value: 0)
    /// - Since: 3.0.0
    case primary
    /// Secondary button: uses secondary theme color as background color  (numerical value: 1)
    /// - Since: 3.0.0
    case secondary
    /// Quiet Emphasis button: quiet emphasis buttons have no background color.
    /// Denotes less important options (numerical value: 2)
    /// - Since: 3.0.0
    case quiet
    /// Accent button: accent buttons have different background color than the default theme (numerical value: 3)
    /// - Since: 3.0.0
    case accent
    /// Quiet Default button: quiet default buttons have no background color.
    /// Denotes least important options (numerical value: 4)
    /// - Since: 1804.0.0
    case quietDefault
}

/// - Since: 3.0.0
@objc
public enum UIDButtonStyle: Int {
    /// textOnly style: should be use for "text only button". (numerical value: 0)
    /// - Since: 3.0.0
    case textOnly
    /// iconOnly style: should be use for "icon only button". (numerical value: 1)
    /// - Since: 3.0.0
    case iconOnly
    /// textWithIcon style: should be use for "text with icon button". (numerical value: 2)
    /// - Since: 3.0.0
    case textWithIcon
}

/**
 *  A UIDButton is the standard button to use.
 *  In InterfaceBuilder it is possible to create a UIButton and give it the class UIDButton, the styling will be done
 *  immediately.
 *
 *  **Please note:** The button must have type "Custom" (`UIButtonTypeCustom`) in order to work correctly.
 * - Since: 3.0.0
 */
@IBDesignable
@objcMembers open class UIDButton: UIButton {
    
    static var edgeInset: CGFloat = UIDSize16
    static let iconOnlyButtonEdgeInset: CGFloat = UIDSize24 / 2.0
    static let textWithIconButtonEdgeInset: CGFloat = UIDSize16 / 4.0
    static let iconSize: CGSize = CGSize(width: UIDIconSize, height: UIDIconSize)
    
    // swiftlint:disable valid_ibinspectable
    /**
     * The type of the button.
     * Updates the button styling when set.
     *
     * Defaults to UIDButtonType.primary
     *
     * - Since: 3.0.0
     */
    @IBInspectable
    open var philipsType: UIDButtonType = .primary {
        didSet {
            assert(buttonType == .custom, "UIDButton must have type 'custom' in order to work properly.")
            configureButton()
        }
    }
    
    /**
     * The Style of the button.
     * Updates the button styling when set.
     *
     * Defaults to UIDButtonStyle.textOnly
     *
     * - Since: 3.0.0
     */
    @IBInspectable
    public var buttonStyle: UIDButtonStyle = .textOnly {
        didSet {
            updateTitle()
            updateInsets()
        }
    }
    // swiftlint:enable valid_ibinspectable
    
    // customTitleColor: Controls whether the button can have a custom TitleColor instead of the standard DLS button TitleColor.
    // Set this to `true` if you want to specify your own TitleColor in Interface Builder.
    // - Since: 3.0.0
    @IBInspectable
    open var customTitleColor: Bool = false {
        didSet {
            updateTitle()
        }
    }
    
    /** 
     * The UIDTheme of the button.
     * Updates the button styling when set.
     *
     * Defaults to UIDThemeManager.sharedInstance.defaultTheme
     * 
     * - Since: 3.0.0
     */
    public var theme: UIDTheme? = UIDThemeManager.sharedInstance.defaultTheme {
        didSet {
            configureButton()
        }
    }
    
    /**
     *  Get or set the title font.
     *
     *  - Since: 3.0.0
     */
    public var titleFont: UIFont? = UIFont(uidFont:.book, size: UIDFontSizeMedium) {
        didSet {
            updateTitle()
        }
    }
    
    override open var isEnabled: Bool {
        didSet {
            updateTintColor()
        }
    }
    
    override open var isHighlighted: Bool {
        didSet {
            updateTintColor()
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width, height: UIDControlHeight)
    }
    
    var configuration: ButtonConfiguration {
        switch philipsType {
        case .primary:
            return .primary
        case .secondary:
            return .secondary
        case .quiet:
            return .quiet
        case .accent:
            return .accent
        case .quietDefault:
            return .quietDefault
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
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        instanceInit()
    }
    
    override open func setImage(_ image: UIImage?, for state: UIControlState) {
        let buttonImage = image?.resizeImage(size: UIDButton.iconSize)?.withRenderingMode(.alwaysTemplate)
        super.setImage(buttonImage, for: state)
    }
    
    open override func setTitle(_ title: String?, for state: UIControlState) {
        super.setTitle(title, for: state)
        updateTitle()
    }
    
    func instanceInit() {
        cornerRadius = UIDCornerRadius
        clipsToBounds = true
        adjustsImageWhenHighlighted = false
        adjustsImageWhenDisabled = false
        setImage(image(for: .normal), for: .normal)
        configureButton()
        updateInsets()
    }
    
    private func configureButton() {
        updateTitle()
        updateTintColor()
        configuration.configureBackground(of:self)
    }

    private func updateTitle() {
        configuration.configureTitle(of:self)
    }
    
    private func updateInsets() {
        UIDButton.edgeInset = philipsType == .quietDefault || philipsType == .quiet ? UIDSize16 / 2.0 : UIDSize16
        imageEdgeInsets = UIEdgeInsets.zero
        titleEdgeInsets = UIEdgeInsets.zero
        switch buttonStyle {
        case .textOnly:
            contentEdgeInsets = UIEdgeInsets(top: 0,
                                             left: UIDButton.edgeInset,
                                             bottom: 0,
                                             right: UIDButton.edgeInset)
        case .iconOnly:
            contentEdgeInsets = UIEdgeInsets(top: 0,
                                             left: UIDButton.iconOnlyButtonEdgeInset,
                                             bottom: 0,
                                             right: UIDButton.iconOnlyButtonEdgeInset)
        case .textWithIcon:
            contentEdgeInsets = UIEdgeInsets(top: 0,
                                             left: UIDButton.edgeInset,
                                             bottom: 0,
                                             right: UIDButton.edgeInset)
            imageEdgeInsets = UIEdgeInsets(top: 0,
                                           left: LayoutDirection.isRightToLeft ?
                                            UIDButton.textWithIconButtonEdgeInset :
                                            -UIDButton.textWithIconButtonEdgeInset,
                                           bottom: 0,
                                           right: LayoutDirection.isRightToLeft ?
                                            -UIDButton.textWithIconButtonEdgeInset :
                                            UIDButton.textWithIconButtonEdgeInset)
            titleEdgeInsets = UIEdgeInsets(top: 0,
                                           left: LayoutDirection.isRightToLeft ?
                                            -UIDButton.textWithIconButtonEdgeInset :
                                            UIDButton.textWithIconButtonEdgeInset,
                                           bottom: 0,
                                           right: LayoutDirection.isRightToLeft ?
                                            UIDButton.textWithIconButtonEdgeInset :
                                            -UIDButton.textWithIconButtonEdgeInset)
        }
    }
    
    private func updateTintColor() {
        let (normalColor, disabledColor, highlightedColor) = configuration.titleColors(of: self)
        if isHighlighted {
            tintColor = highlightedColor
        } else if isEnabled {
            tintColor = normalColor
        } else {
            tintColor = disabledColor
        }
    }
}
