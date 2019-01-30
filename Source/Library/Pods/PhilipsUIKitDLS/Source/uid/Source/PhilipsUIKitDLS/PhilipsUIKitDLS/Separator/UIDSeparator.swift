/** © Koninklijke Philips N.V., 2017. All rights reserved. */

import UIKit

/// - Since: 3.0.0
@objcMembers open
class UIDSeparator: UIView {
    
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
    
    /**
     * Configure the component's color.
     *
     * - Since: 3.0.0
     */
   open var separatorColor: UIColor? {
        didSet {
            backgroundColor = separatorColor
        }
    }
    
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
    
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: UIDProgressIndicatorHeight)
    }
    
    private func configureView() {
        separatorColor = theme?.separatorContentBackground
    }
}
