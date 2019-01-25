//  Copyright © 2016 Philips. All rights reserved.

import UIKit

/**
 *  Return a dictionary of type "[String : Any]" for "NSFontAttributeName" & "NSForegroundColorAttributeName" keys/attributes.
 */

extension UIFont {
    func attributes(with color: UIColor) -> StringAttributes {
        return [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): self,
                NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): color]
    }
}
