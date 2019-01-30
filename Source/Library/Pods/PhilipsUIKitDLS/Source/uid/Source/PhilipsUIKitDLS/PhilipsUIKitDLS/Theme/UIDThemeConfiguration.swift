/** © Koninklijke Philips N.V., 2016. All rights reserved. */

import Foundation

/**
 * A collection of available PhilipsUIKitDLS "Navigation shadow level".
 *
 * - Since: 3.0.0
 */
@objc public enum UIDNavigationShadowLevel: Int {
    /// - Since: 3.0.0
    case one
    /// - Since: 3.0.0
    case two
}

// MARK: - Theme configuration
/**
 * A Philips UIKit Theme configuration. "UIDTheme" will use "UIDThemeConfiguration" as input parameter during initialization.
 *
 * - Since: 3.0.0
 */
@objcMembers open class UIDThemeConfiguration: NSObject {
    
    /**
     * colorRange will hold PhilipsUIKitDLS Color Range value.
     * @note default value is "groupBlue"
     *
     * - Since: 3.0.0
     */
    open var colorRange: UIDColorRange = .groupBlue
    
    /**
     * tonalRange will hold PhilipsUIKitDLS Tonal Range value.
     * @note default value is "ultraLight"
     *
     * - Since: 3.0.0
     */
    open var tonalRange: UIDTonalRange = .ultraLight
    
    /**
     * navigationTonalRange will hold PhilipsUIKitDLS Tonal Range value.
     * @note default value is "bright"
     *
     * - Since: 3.0.0
     */
    open var navigationTonalRange: UIDTonalRange = .bright
    
    /**
     * accentColorRange will hold PhilipsUIKitDLS accent Range value.
     *
     * The supported Color Range-Accent Range mapping is as below
     *
     * - Group blue: Purple, Pink, Orange, Green, Aqua
     * - Blue: Purple, Pink, Orange, Green, Aqua
     * - Aqua: Purple, Pink, Orange, Blue
     * - Green: Purple, Pink, Orange
     * - Orange: Purple, Aqua, Blue
     * - Pink: Purple, Orange
     * - Purple: Pink, Orange, Green, Aqua, Blue
     * - Gray: Purple, Pink, Orange, Green, Aqua, Blue, Group blue
     *
     * @note default value is "aqua"
     *
     * - Since: 3.0.0
     */
    open private(set) var accentColorRange: UIDColorRange = .aqua

    /**
     * init with default UIDThemeConfiguration's value.
     *
     * - Since: 3.0.0
     */
    public convenience override init() {
        self.init(colorRange: .groupBlue, tonalRange: .ultraLight)
    }
    
    /**
     * init with custom UIDThemeConfiguration's UIDColorRange & UIDTonalRange value.
     *
     * - Since: 3.0.0
     */
    public convenience init(colorRange: UIDColorRange, tonalRange: UIDTonalRange) {
        self.init(colorRange: colorRange, tonalRange: tonalRange, navigationTonalRange: .bright)
    }
    
    /**
     * init with custom UIDThemeConfiguration's UIDColorRange, UIDTonalRange & NavigationTonalRange value.
     *
     * - Since: 3.0.0
     */
    public convenience init(colorRange: UIDColorRange, tonalRange: UIDTonalRange, navigationTonalRange: UIDTonalRange) {
        let accentColorRange = UIDTheme.defaultAccent(for: colorRange) ?? .aqua
        self.init(colorRange: colorRange,
                  tonalRange: tonalRange,
                  navigationTonalRange: navigationTonalRange,
                  accentColorRange: accentColorRange)
    }
    
    /**
     * init with custom UIDThemeConfiguration's UIDColorRange, UIDTonalRange,NavigationTonalRange & AccentColorRange value.
     * @note **If Color Range doesnot support the passed Accent Color range,
     * by default the first supported Accent Color Range for the passed Color Range will be applied**
     *
     * - Since: 3.0.0
     */
    public init(colorRange: UIDColorRange,
                tonalRange: UIDTonalRange,
                navigationTonalRange: UIDTonalRange,
                accentColorRange: UIDColorRange) {
        let modifiedAccentColorRange = UIDTheme.isValidAccent(for: colorRange, with: accentColorRange) ?
            accentColorRange : UIDTheme.defaultAccent(for: colorRange) ??
            .aqua
        
        #if DEBUG
            if modifiedAccentColorRange != accentColorRange {
                NSLog("The given Color Range doesnot support this Accent. Using default Accent Color for the Color Range.")
            }
        #endif
        
        self.colorRange = colorRange
        self.tonalRange = tonalRange
        self.navigationTonalRange = navigationTonalRange
        self.accentColorRange = modifiedAccentColorRange
        super.init()
    }
}
