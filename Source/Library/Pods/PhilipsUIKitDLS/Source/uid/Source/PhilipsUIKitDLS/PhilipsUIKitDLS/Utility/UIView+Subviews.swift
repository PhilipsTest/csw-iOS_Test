//  Copyright © 2016 Philips. All rights reserved.

import UIKit

extension UIView {
    func removeAllSubviews() {
        let subviews = self.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    func addSubviews(_ subviews: [UIView]) {
        for subview in subviews {
            addSubview(subview)
        }
    }
}

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
    
    func removeAllArrangedSubviews() {
        for subview in subviews {
            removeArrangedSubview(subview)
        }
    }
    
    func removeArrangedSubviews(_ views: [UIView]) {
        views.forEach { removeArrangedSubview($0) }
    }
}
