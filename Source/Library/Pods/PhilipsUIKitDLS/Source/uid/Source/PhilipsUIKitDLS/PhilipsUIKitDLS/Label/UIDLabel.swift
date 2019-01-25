//  Copyright © 2016 Philips. All rights reserved.

import UIKit

/**
 * The types of PhilipsUIKit labels  (UIDLabel) that are available. In code, you should use these types. Unfortunately,
 * Interface Builder doesn't support enums yet, so if you configure the button in Interface Builder,
 * you have to use the numeric values.
 * - Since: 3.0.0
 */
@objc
public enum UIDLabelType: Int {
    /// Value Label: uses primary theme color as text color (numerical value: 0). This will be non prominent one.
    /// - Since: 3.0.0
    case regular
    /// Regular Label: uses tertiary theme color as text color  (numerical value: 1). This will be prominent one.
    /// - Since: 3.0.0
    case value
    /// Disabled Label: uses disabled theme color as text color  (numerical value: 1). This will be prominent one.
    /// - Since: 3.0.0
    case disabled
}

/// - Since: 3.0.0
@objc
public enum UIDFontType: Int {
    /// book: Lighter version of font
    /// - Since: 3.0.0
    case book
    /// medium: Darker version of font.
    /// - Since: 3.0.0
    case medium
    
    func font() -> UIFont? {
        switch self {
        case .book:
            return UIFont(uidFont:.book, size: UIDFontSizeMedium)
        case .medium:
            return UIFont(uidFont:.medium, size: UIDFontSizeMedium)
        }
    }
}

/**
 *  A UIDLabel is the standard switch to use.
 *  In InterfaceBuilder it is possible to create a UILabel and give it the class UIDLabel, the styling will be done
 *  immediately.
 * - Since: 3.0.0
 *
 */
@IBDesignable
 @objcMembers open class UIDLabel: UILabel {
    /**
     *  Configure the control's theme.
     *  - Since: 3.0.0
     */
    open var theme: UIDTheme? = UIDThemeManager.sharedInstance.defaultTheme {
        didSet {
            configureTheme()
        }
    }
    
    /// labelType : Type of label
    /// - Since: 3.0.0
    open var labelType: UIDLabelType = .regular {
        didSet {
            configureColor()
        }
    }
    
    /// fontType : Type of font
    /// - Since: 3.0.0
    open var fontType: UIDFontType = .book {
        didSet {
            configureFont()
        }
    }
    
    // customFont: Controls whether the label can have a custom font instead of the standard DLS label font.
    // Set this to `true` if you want to specify your own font, either in Interface Builder or in code.
    /// - Since: 3.0.0
    @IBInspectable
    open var customFont: Bool = false {
        didSet {
            configureFont()
        }
    }
    
    private var labelColor: UIColor? {
        switch labelType {
        case .regular:
            return theme?.labelRegularText
        case .value:
            return theme?.labelValueText
        case .disabled:
            return theme?.labelValueDisabledText
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        instanceInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        instanceInit()
    }
    
    private func instanceInit() {
        backgroundColor = UIColor.clear
        configureTheme()
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        instanceInit()
    }
    
    open override var text: String? {
        didSet {
            setAttributedTitle()
        }
    }
    
    private func setAttributedTitle() {
        let attributes = font.attributes(with: textColor)
        let attributedString = NSMutableAttributedString(string: text ?? "",
                                                         attributes: attributes)
        attributedText = attributedString
    }
    
    private func configureTheme() {
        configureColor()
        configureFont()
    }
    
    private func configureColor() {
        textColor = labelColor
    }
    
    private func configureFont() {
        if customFont == false {
            font = fontType.font()
        }
    }
}
