/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

/**
 *  Highlighting a certain range of label text
 */

public extension UILabel {
    
    /**
     *  Highlight a given range of a label text. Can be used with attributed label text as well as normal label text
     *
     *  - Important:
     *  1. To set user-defined font or text color or any other attribute to the label text,
     *  they should be set before calling this method.
     *  2. The label text should be set before calling this method
     *
     * - Parameter range: The range of the label text which is to be highlighted
     * - Since: 3.0.0
     */
    
    @objc public func highlightText(_ range: NSRange) {
        var highlightedText: NSMutableAttributedString?
        
        if let labelAttributedText = attributedText {
            highlightedText = NSMutableAttributedString(attributedString: labelAttributedText)
        }
        
        if let labelHighlightedText = highlightedText, labelHighlightedText.isValid(range: range) {
            var highlightedStringRange = range
            let fontAttributes = labelHighlightedText.attributes(at: range.location, effectiveRange: &highlightedStringRange)
            let highlightedFontSize = (fontAttributes[.font] as? UIFont)?.pointSize ?? font.pointSize
            
            if let highlightedFont = UIFont(uidFont: .bold, size: highlightedFontSize) {
                labelHighlightedText.addAttribute(.font, value: highlightedFont, range: range)
                attributedText = labelHighlightedText
            }
        }
    }
    
    /**
     *  Set a label text and highlight a given range of the label text. This will override the label text if any
     *
     *  - Important:
     *  To set user-defined font or text color or any other attribute to the label text,
     *  they should be set before calling this method.
     *
     * - Parameter range: The range of the label text which is to be highlighted
     * - Parameter text: The text to be set on the label
     * - Since: 3.0.0
     */
    
   @objc public func highlightedText(text: String, range: NSRange) {
        self.text = text
        highlightText(range)
    }
    
    /**
     *  Set a label attributed text and highlight a given range of the label text. This will override the label text if any
     *
     *  - Important:
     *  To set user-defined font or text color or any other attribute to the label attributed text,
     *  they should be set before calling this method.
     *
     * - Parameter range: The range of the label text which is to be highlighted
     * - Parameter attributedText: The attributed text to be set on the label
     * - Since: 3.0.0
     */
    
   @objc public func highlightedAttributedText(attributedText: NSAttributedString, range: NSRange) {
        self.attributedText = attributedText
        highlightText(range)
    }
}

extension NSMutableAttributedString {
    
    func isValid(range: NSRange) -> Bool {
        return range.location != NSNotFound && range.location + range.length <= length
    }
}
