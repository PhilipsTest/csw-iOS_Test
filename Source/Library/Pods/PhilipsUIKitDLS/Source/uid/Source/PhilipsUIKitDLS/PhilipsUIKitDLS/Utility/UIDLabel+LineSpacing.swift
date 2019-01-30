/** © Koninklijke Philips N.V., 2017. All rights reserved. */

public extension UILabel {
    /// - Since: 3.0.0
  @objc public func text(_ text: String,  lineSpacing: CGFloat) {
        attributedText = text.attributedString(lineSpacing: lineSpacing, textAlignment: textAlignment)
    }
}
