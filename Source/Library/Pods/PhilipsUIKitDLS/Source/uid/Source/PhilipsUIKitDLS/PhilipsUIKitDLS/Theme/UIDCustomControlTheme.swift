//  Copyright © 2016 Philips. All rights reserved.

/**
 * A PhilipsUIKitDLS Theme extension for theme colors that are not included yet in the generated code (UIDControlTheme).
 * This content is supposed to be temporary, once properly determined by design, these properties should be generaed too.
 *
 * - Since: 3.0.0
 */
extension UIDTheme {
    
    /**
     * contentPrimary will hold PhilipsUIKitDLS primary color for content.
     *
     * - Since: 3.0.0
     */
    open var contentPrimary: UIColor? {
        return brushes.contentPrimary(tonalRange: tonalRange)
            .color(in: colorRange)
    }

    /**
     * contentSecondary will hold PhilipsUIKitDLS secondary color for content.
     *
     * - Since: 3.0.0
     */
    open var contentSecondary: UIColor? {
        return brushes.contentSecondary(tonalRange: tonalRange)
            .color(in: colorRange)
    }
}
