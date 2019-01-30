//  Copyright © 2016 Philips. All rights reserved.

fileprivate let textBoxUltraLightBorderWidth: CGFloat = 1
fileprivate let textBoxDefaultNormalBorderWidth: CGFloat = 0
fileprivate let textBoxDefaultFocusBorderWidth: CGFloat = 4

/**
 * A PhilipsUIKitDLS Theme extension for UIDTextField and UIDTextView (TextBox in terms of the design reference).
 * Has computed properties for TextBoxes, based on the theme (based on UIDInputColors).
 * Maps input colors to the context of text boxes.
 *
 * - Since: 3.0.0
 */

extension UIDTheme {

    // ****************************************************
    // MARK: - Text Box Border Width
    // ****************************************************

    /**
     * textBoxNormalBorderWidth is 1 when tonal range it .ultraLight, 0 otherwise
     *
     * - Since: 3.0.0
     */
    open var textBoxNormalBorderWidth: CGFloat {
        return tonalRange == .ultraLight ? textBoxUltraLightBorderWidth : textBoxDefaultNormalBorderWidth
    }

    /**
     * textBoxFocusBorderWidth is 1 when the tonal range is .ultraLight, 4 otherwize
     *
     * - Since: 3.0.0
     */
    open var textBoxFocusBorderWidth: CGFloat {
        return tonalRange == .ultraLight ? textBoxUltraLightBorderWidth : textBoxDefaultFocusBorderWidth
    }

}
