/** © Koninklijke Philips N.V., 2016. All rights reserved. */

import Foundation
import UIKit

/**
 * A PhilipsUIKitDLS Theme. Themes have properties for all places where they are used. You can use one of the standard
 * themes (such as blueDark, purpleDark), or you can make your own theme.
 *
 * - Since: 3.0.0
 */
@objcMembers open class UIDTheme: NSObject {
    
    // ****************************************************
    // MARK: - Theme's properties
    // ****************************************************
    
    /**
     * colorRange will hold PhilipsUIKitDLS Color Range value.
     * @note default value is "groupBlue"
     *
     * - Since: 3.0.0
     */
    open private(set) var colorRange: UIDColorRange
    
    /**
     * tonalRange will hold PhilipsUIKitDLS Tonal Range value.
     * @note default value is "ultraLight"
     *
     * - Since: 3.0.0
     */
    open internal(set) var tonalRange: UIDTonalRange
    
    /**
     * navigationTonalRange will hold PhilipsUIKitDLS Tonal Range value.
     * @note default value is "bright"
     *
     * - Since: 3.0.0
     */
    open internal(set) var navigationTonalRange: UIDTonalRange
    
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
     * @note Use **supportedAccentColors(for colorRange:)**
     * API to get a list of Accent Color Ranges for the wanted Color Range. Default value is "aqua"
     *
     * - Since: 3.0.0
     */
    open private(set) var accentColorRange: UIDColorRange
   
    // ****************************************************
    // MARK: - Theme's Content-Color properties
    // ****************************************************

    /**
     * applicationBackgroundColor will hold PhilipsUIKitDLS application background content Color.
     *
     * - Since: 3.0.0
     */
    open var applicationBackgroundColor: UIColor? { return contentTertiaryBackground }
    
    /**
     * applicationBackgroundImage will hold image which will use by all COCO's.
     * @note default value is "nil"
     *
     * - Since: 3.0.0
     */
    public var applicationBackgroundImage: UIImage?
    
    var brushes: UIDSemanticBrushes = UIDSemanticBrushes()
    // ****************************************************
    // MARK: - initialization
    // ****************************************************
    
    /**
     * init with default UIDThemeConfiguration's value.
     *
     * - Since: 3.0.0
     */
    public convenience override init() {
        self.init(themeConfiguration: UIDThemeConfiguration())
    }
    
    /**
     * init with custom UIDThemeConfiguration's value.
     * By using UIDThemeConfiguration, User can pass custom values of 'colorRange','tonalRange' & 'navigationTonalRange'.
     * @see UIDColorRange UIDTonalRange
     *
     * - Since: 3.0.0
     */
     public init(themeConfiguration: UIDThemeConfiguration) {
        self.colorRange = themeConfiguration.colorRange
        self.tonalRange = themeConfiguration.tonalRange
        self.navigationTonalRange = themeConfiguration.navigationTonalRange
        self.accentColorRange = themeConfiguration.accentColorRange
        self.brushes = UIDSemanticBrushes()
        super.init()
        self.brushes.theme = self
    }
}
