/* Copyright (c) Koninklijke Philips Electronics N.V. 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

extension UIView {
    @discardableResult
    func addSideBarMenuViewConstraints(_ view: UIView,
                                       originX: CGFloat,
                                       width: CGFloat) -> (NSLayoutConstraint?, NSLayoutConstraint?) {
        view.constrainToSuperviewTop(0)
        view.constrainToSuperviewBottom(0)
        let leftContraint = view.constrainToSuperviewLeft(originX)
        let widthContraint = view.constrain(toWidth: width)
        return (leftContraint, widthContraint)
    }
    
    func addSideBarMainViewConstraints(_ view: UIView) {
        let views: [String: UIView] = ["childView": view]
        var visualFormatConstraints = [String]()
        visualFormatConstraints.append("H:|[childView]|")
        visualFormatConstraints.append("V:|[childView]|")
        addConstraints(visualFormatConstraints, metrics: nil, views: views)
    }
}

public extension UIDevice {
    /**
     * Getter for Device width.
     *
     * - Since: 3.0.0
     */
   @objc public static var width: CGFloat {
        return UIDevice.size.width
    }
    
    /**
     * Getter for Device height.
     *
     * - Since: 3.0.0
     */
   @objc public static var height: CGFloat {
        return UIDevice.size.height
    }
    
    /**
     * Getter for Device size.
     *
     * - Since: 3.0.0
     */
   @objc public static var size: CGSize {
        return UIScreen.main.bounds.size
    }
    
    /**
     * Getter to check running Device is iPad or not.
     *
     * - Since: 3.0.0
     */
   @objc public static var isIpad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    /**
     * Getter for Navigation-Height.
     *
     * - Since: 3.0.0
     */
   @objc public static let navigationHeight: CGFloat = 44
}
