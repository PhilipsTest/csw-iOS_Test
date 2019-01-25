//  Copyright © 2017 Philips. All rights reserved.

public extension UIImage {
    /// - Since: 3.0.0
    @objc public func applying(tintColor color: UIColor) -> UIImage? {
        let image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        guard let generatedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        return generatedImage
    }
}
