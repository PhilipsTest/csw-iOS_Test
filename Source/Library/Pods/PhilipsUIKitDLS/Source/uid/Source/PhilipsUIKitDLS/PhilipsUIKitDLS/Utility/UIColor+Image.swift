//  Copyright © 2016 Philips. All rights reserved.

/**
 *  Creating images from a single color
 */

public extension UIColor {
    
    /**
     *  Create a 1x1 UIImage filled in the object's color, opaque
     *  Can be used as background images, by stretching them to the appropriate size
     *
     *  @return UIImage
     * - Since: 3.0.0
     */
    
   @objc public func createImage() -> UIImage? {
        var rect = CGRect.zero
        rect.size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
    
    /// - Since: 3.0.0
   @objc public func createImage(with size: CGSize) -> UIImage? {
        var rect = CGRect.zero
        rect.size = CGSize(width:size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
