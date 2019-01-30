// © Koninklijke Philips N.V., 2018. All rights reserved.

import Foundation
import UIKit

extension UIView {
    func getViewTree() -> [UIView] {
        var list = [UIView]()
        list.append(contentsOf: subviews)

        for view in subviews {
            list.append(contentsOf: view.getViewTree())
        }

        return list
    }
}
