/* Copyright (c) Koninklijke Philips Electronics N.V. 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

/**
 *  Set Button Title with Line-Spacing.
 *
 *  - Since: 3.0.0
 */
public extension UIButton {
   @objc public func setTitle(_ title: String, for state: UIControlState = .normal, lineSpacing: CGFloat) {
        let attributedTitle = title.attributedString(lineSpacing: lineSpacing)
        setAttributedTitle(attributedTitle, for: state)
    }
}
