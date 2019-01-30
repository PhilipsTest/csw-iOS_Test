//  Copyright © 2016 Philips. All rights reserved.

/**
 *  Useful helpers for UIView
 *  Allows setting the corner radius, border color and border width of a UIView by accessingits layer
 */
extension UIView {
    
    /**
     *  Get or set the corner radius.
     *  - Since: 3.0.0
     */
   @objc public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    /**
     *  Get or set the border color.
     *  - Since: 3.0.0
     */
  @objc  public var borderColor: UIColor? {
        get {
            guard let color = self.layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    /**
     *  Get or set the border width.
     *  - Since: 3.0.0
     */
   @objc public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

}
