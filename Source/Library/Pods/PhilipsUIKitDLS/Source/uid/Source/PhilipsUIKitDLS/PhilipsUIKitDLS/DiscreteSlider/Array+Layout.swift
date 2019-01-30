/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

public
extension Array where Element == String {
    public func activateVisualConstraintsWith(metrics: [String : Any]? = nil,
                                              options: NSLayoutFormatOptions = [.directionLeadingToTrailing],
                                            views: [String : Any]) {
        for visualFormat in self {
            NSLayoutConstraint.constraints(withVisualFormat: visualFormat,
                                           options: options,
                                           metrics: metrics,
                                           views: views).forEach { $0.isActive = true }
        }
    }
}
