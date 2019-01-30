/** © Koninklijke Philips N.V., 2016. All rights reserved. */

import Foundation

/**
 * The types of PhilipsUIKit UIDView's background-color that are available. In code, you should use these types. 
 * Unfortunately,Interface Builder doesn't support enums yet, so if you configure the UIDView in Interface Builder,
 * you have to use the numeric values.
 * - Since: 3.0.0
 */
@objc
public enum UIDViewBackgroundColorType: Int {
    /// Primary Background Color: uses theme's primary content color as background color (numerical value: 0)
    /// - Since: 3.0.0
    case primary
    /// Secondary Background Color: uses theme's secondary content color as background color  (numerical value: 1)
    /// - Since: 3.0.0
    case secondary
}

/**
 *  A UIDView is the standard content-view to use as per DLS guideline.
 *  In InterfaceBuilder it is possible to create a UIView and give it the class UIDView, the styling will be done
 *  immediately.
 *
 *  - Since: 3.0.0
 */
@objcMembers open class UIDView: UIView {
    
    /**
     * PhilipsUIKitDLS Theme Reference.
     *
     * Default value is UIDThemeManager's defaultTheme.
     *
     * - Since: 3.0.0
     */
    open var theme = UIDThemeManager.sharedInstance.defaultTheme {
        didSet {
            configureView()
        }
    }
    
    // swiftlint:disable valid_ibinspectable
    /**
     * The type of the backgroundColor.
     * Updates the background color when set.
     *
     * Default value is UIDViewBackgroundColorType.primary
     *
     * - Since: 3.0.0
     */
    @IBInspectable
    public var backgroundColorType: UIDViewBackgroundColorType = .primary {
        didSet {
            configureView()
        }
    }
    // swiftlint:enable valid_ibinspectable
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configureView()
    }
    
    private func configureView() {
        var backgroundColor = self.backgroundColor
        switch self.backgroundColorType {
        case .secondary:
            backgroundColor = theme?.contentSecondary
        default:
            backgroundColor = theme?.contentPrimary
        }
        self.backgroundColor = backgroundColor
    }
}
