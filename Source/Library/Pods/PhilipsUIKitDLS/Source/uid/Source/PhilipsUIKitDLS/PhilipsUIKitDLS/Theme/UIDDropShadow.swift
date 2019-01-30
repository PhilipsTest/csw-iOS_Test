/** © Koninklijke Philips N.V., 2016. All rights reserved. */

import UIKit

/// DLS specified drop shadow levels
/// - Since: 3.0.0
@objc public enum UIDDropShadowLevel: NSInteger {
    /// DLS specified drop shadow level 1. Used typically for sub hierarchy.
    /// For example, separating a drop down control from its background.
    /// - Since: 3.0.0
    case level1 = 1
    /// DLS specified drop shadow level 2. Used between higher levels such as navigation.
    /// - Since: 3.0.0
    case level2
    /// DLS specified drop shadow level 3. Used for dialogs & alerts.
    /// - Since: 3.0.0
    case level3
}

/// UIDDropShadow contains all properties of DLS Drop shadow effects for various views
/// - Since: 3.0.0
@objcMembers open class UIDDropShadow: NSObject {
    
    /// Radius, spread, or 'blur' of the shadow effect in dp
    /// - Since: 3.0.0
    open let radius: CGFloat
    
    /// Offset, location of the drop shadow relative to the view.
    /// - Since: 3.0.0
    open let offset: CGSize
    
    /// Color of the drop shadow. 
    /// By default, it's expected to also contain opacity information in the alpha layer.
    /// - Since: 3.0.0
    open let color: UIColor?
    
    /// Opacity of the drop shadow.
    /// By default set to 1 (= 100%). Opacity of DLS drop shadows is handled by the color property
    /// - Since: 3.0.0
    open let opacity: Float = 1.0

    /// Convenience constructor for DLS specified drop shadow levels.
    //// Sets predefined properties based on UIDDropShadowLevel and UIDTheme
    ///
    /// - Parameters:
    ///   - level: DLS specified shadow level
    ///   - theme: DLS specified or suctom theme. Expects theme.controlColors.shadowLevelXColor to be set
    /// - Since: 3.0.0
    convenience public init(level: UIDDropShadowLevel, theme: UIDTheme) {
        switch level {
        case .level1:
            self.init(radius: 1.0,
                      offset: CGSize(width: 0, height: 1),
                      color:theme.brushes.shadowLevelOne(tonalRange: theme.tonalRange).color(in: theme.colorRange))
        case .level2:
            self.init(radius: 2.0,
                      offset: CGSize(width: 0, height: 1),
                      color:theme.brushes.shadowLevelTwo(tonalRange: theme.tonalRange).color(in: theme.colorRange))
        case .level3:
            self.init(radius: 8.0,
                      offset: CGSize(width: 0, height: 8),
                      color:theme.brushes.shadowLevelThree(tonalRange: theme.tonalRange).color(in: theme.colorRange))
        }
    }
    
    /// Constructor for custom drop shadows.
    ///
    /// - Parameters:
    ///   - radius: spread of the shadow effect in dp.
    ///   - offset: location of the drop shadow relative to the view.
    ///   - color: drop shadow color. Should also contain opacity information in the alpha layer.
    /// - Since: 3.0.0
    @objc required public init(radius: CGFloat, offset: CGSize, color: UIColor?) {
        self.radius = radius
        self.offset = offset
        self.color = color
        super.init()
    }
}
