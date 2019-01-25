//  Copyright © 2016 Philips. All rights reserved.

import UIKit

public extension UIView {
    
    /// Applies DLS specific drop shadow to the UIView
    /// Sets the drop shadow to the CALayer of the view.
    ///
    /// - Important:
    /// If the property clipToBounds == true, the shadow will not be visible.
    ///
    /// - Parameter dropShadow: drop shadow specification
    /// - Since: 3.0.0
  @objc  public func apply(dropShadow: UIDDropShadow) {
        layer.shadowRadius = dropShadow.radius
        layer.shadowOffset = dropShadow.offset
        layer.shadowColor = dropShadow.color?.cgColor
        layer.shadowOpacity = dropShadow.opacity
    }
    
    /// Remove DLS specific drop shadow to the UIView
    /// - Since: 3.0.0
   @objc public func removeDropShadow() {
        layer.shadowOpacity = 0.0
    }
}
