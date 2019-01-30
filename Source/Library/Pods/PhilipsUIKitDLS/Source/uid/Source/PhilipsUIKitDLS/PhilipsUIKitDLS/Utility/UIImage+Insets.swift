//  Copyright © 2016 Philips. All rights reserved.

import PhilipsIconFontDLS

public extension UIImage {
    
    /// - Since: 3.0.0
   @objc public func imageWithInsets(insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: size.width + insets.left + insets.right,
                   height: size.height + insets.top + insets.bottom), false, scale)
        UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
    
    /// - Since: 3.0.0
   @objc public func resizeImage(size newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// - Since: 3.0.0
   @objc public class func imageWithIconFontType(_ type: PhilipsDLSIconType,
                                             iconSize: CGFloat,
                                             iconColor: UIColor = .black) -> UIImage? {
        let label = UILabel()
        label.font = UIFont.iconFont(size: iconSize)
        label.text = PhilipsDLSIcon.unicode(iconType: type)
        label.textColor = iconColor
        label.sizeToFit()
        return label.drawImage()
    }
}
