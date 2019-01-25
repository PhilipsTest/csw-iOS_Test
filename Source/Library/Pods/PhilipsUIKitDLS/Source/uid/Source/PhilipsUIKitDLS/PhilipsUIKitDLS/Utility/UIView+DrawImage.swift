/** © Koninklijke Philips N.V., 2016. All rights reserved. */

import Foundation

@objc public extension UIView {
    /// Draw image of the view.
    ///
    /// - returns
    /// Optional UIImage object of the view.
    /// - Since: 3.0.0
    func drawImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /**
     * Get UIImageView of UIView.
     * - Since: 3.0.0
     */
    func toImageView() -> UIImageView {
        let image = self.drawImage()
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
}
