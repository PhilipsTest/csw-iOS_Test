/* Copyright (c) Koninklijke Philips Electronics N.V. 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

/**
 *  Get AttributedString with Line-Spacing from String.
 *
 *  - Since: 3.0.0
 */
public extension String {
    public func attributedString(lineSpacing: CGFloat = UIDLineSpacing,
                                 textAlignment: NSTextAlignment = .natural) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let range = NSRange(location: 0, length: self.count)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.alignment = textAlignment
        attributedString.addAttribute(.paragraphStyle, value: style, range: range)
        return attributedString
    }
}
