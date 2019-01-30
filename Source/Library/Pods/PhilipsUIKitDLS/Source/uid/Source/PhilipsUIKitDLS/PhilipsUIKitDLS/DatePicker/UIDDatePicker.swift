/** © Koninklijke Philips N.V., 2017. All rights reserved. */

import UIKit

/// - Since: 3.0.0
@objcMembers open
class UIDDatePicker: UIDatePicker {
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
    
    func instanceInit() {
        backgroundColor = UIColor.clear
        configureView()
    }
    
    func configureView() {
        if let textColor = theme?.pickerIosDefaultPickerText {
            setValue(textColor, forKey: "textColor")
            perform(Selector(("setHighlightsToday:")), with: textColor)
        }
    }
}
