/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

/**
 
 Helper functions for dealing with right-to-left languages.
 
 */
struct LayoutDirection {
    
    static var isRightToLeft: Bool {
        return UIView.userInterfaceLayoutDirection(
            for: .unspecified) == .rightToLeft
    }
}
