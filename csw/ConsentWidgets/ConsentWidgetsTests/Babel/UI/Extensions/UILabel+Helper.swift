// © Koninklijke Philips N.V., 2018. All rights reserved.

import UIKit
import Foundation

extension UILabel {
    public func isTruncated() -> Bool {
        let label = UILabel(frame: frame)
        label.font = font
        label.numberOfLines = 0
        label.lineBreakMode = lineBreakMode
        label.text = text
        label.attributedText = attributedText
        label.fitsResizingHeight()

        if Int(label.frame.size.width) > Int(frame.size.width) {
            return true
        }

        if Int(label.frame.size.height) > Int(frame.size.height) {
            return true
        }

        return false
    }

    public func hasScrollViewAncestor() -> Bool {
        var ancestor = superview
        
        while(ancestor != nil) {
            if ancestor is UIScrollView {
                return true
            }

            ancestor = ancestor?.superview
        }

        return false
    }

    public func fitsResizingHeight() {
        let size = self.sizeThatFits(CGSize(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        frame = CGRect(origin: frame.origin, size: size)
    }
}

extension UILabel {
    func addBorder() {
        layer.borderColor = UIColor.red.cgColor;
        layer.borderWidth = 3.0;
    }
}
