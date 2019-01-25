/* Copyright (c) Koninklijke Philips Electronics N.V. 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

/*
 *************************************************************
        How to Use "sizeToFit(_ size: CGSize)" API
 *************************************************************
 
 Suppose User want to know about the height of its text with fixed width.
 Then
 Use this api as below:
 
 let label = ....
 let labelWidth = label.frame.size.width
 let inputSize = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
 let labelSize = label.sizeToFit(inputSize)
 
 Use label Height as: labelSize.height
 */
public extension UILabel {
   @objc public func sizeToFit(_ size: CGSize) -> CGSize {
        return sizeToFit(size, font: font)
    }
    
   @objc public func sizeToFit(_ size: CGSize, font: UIFont) -> CGSize {
        return text?.sizeToFit(size, font: font) ?? CGSize.zero
    }
}

protocol LabelSize {
    var attributedText: NSAttributedString? { get }
    var text: String? { get }
    func sizeToFitting(_ size: CGSize, font: UIFont?, lineBreakMode: NSLineBreakMode) -> CGSize
}

extension LabelSize {
    func sizeToFitting(_ size: CGSize, font: UIFont?, lineBreakMode: NSLineBreakMode) -> CGSize {
        let label = UILabel()
        label.frame.origin = CGPoint.zero
        label.frame.size = size
        label.numberOfLines = 0
        label.lineBreakMode = lineBreakMode
        font.ifNotNil { label.font = $0 }
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.size
    }
    
    var attributedText: NSAttributedString? { return nil }
    
    var text: String? { return nil }
}

extension String: LabelSize {
    var text: String? {
        return self
    }
    
    var attributedText: NSAttributedString? {
        return NSAttributedString(string: self)
    }
    
    func sizeToFit(_ size: CGSize, font: UIFont?, lineBreakMode: NSLineBreakMode = .byWordWrapping) -> CGSize {
        return sizeToFitting(size, font: font, lineBreakMode: lineBreakMode)
    }
}

extension NSAttributedString: LabelSize {
    var text: String? {
        return self.string
    }
    
    var attributedText: NSAttributedString? {
        return self
    }
    
    func sizeToFit(_ size: CGSize, font: UIFont?, lineBreakMode: NSLineBreakMode = .byWordWrapping) -> CGSize {
        return sizeToFitting(size, font: font, lineBreakMode: lineBreakMode)
    }
}
