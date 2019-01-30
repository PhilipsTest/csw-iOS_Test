/* Copyright (c) Koninklijke Philips Electronics N.V. 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

let dotDiameter: CGFloat = 8

class DotView: UIView {
    var isHighlighted: Bool = false {
        didSet {
            configureTheme()
        }
    }
    
    /// - Since: 3.0.0
    @objc public var theme: UIDTheme? = UIDThemeManager.sharedInstance.defaultTheme {
        didSet {
            configureTheme()
        }
    }
    
   @objc override public init(frame: CGRect) {
        super.init(frame: frame)
        instanceInit()
    }
    
    @objc required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc open override func awakeFromNib() {
        instanceInit()
    }
    
    func instanceInit() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = dotDiameter / 2
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: dotDiameter, height: dotDiameter)
    }
    
    func configureTheme() {
        let color = isHighlighted ? theme?.dotNavigationDefaultHoverBackground
            : theme?.dotNavigationDefaultOffBackground
        backgroundColor = color
    }
}
