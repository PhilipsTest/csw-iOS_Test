/** © Koninklijke Philips N.V., 2016. All rights reserved. */

import Foundation

/**
 *  A UIDSecondaryNavigationBarView is the standard secondary navigationBar view to use as per DLS guideline.
 *  In InterfaceBuilder it is possible to create a UIView and give it the class UIDSecondaryNavigationBarView, 
 *  the styling will be done immediately.
 *
 *  - Since: 3.0.0
 */
@objcMembers open class UIDSecondaryNavigationBarView: UIView {
    
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
        configureView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    private func configureView() {
        self.backgroundColor = theme?.navigationSecondaryBackground
        let deviceWidth = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        guard let startColor = theme?.shadowLevelTwoShadow else {
            return
        }
        let endColor = startColor.withAlphaComponent(0)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0,
                                     y: self.frame.size.height,
                                     width: deviceWidth,
                                     height: UIDSecondaryNavigationBarShadowHeight)
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        self.layer.addSublayer(gradientLayer)
    }
}
