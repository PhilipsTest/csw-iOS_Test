/* Copyright (c) Koninklijke Philips Electronics N.V. 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

public extension UIViewController {
    /**
     * Add ChildViewController inside specific container-view.
     *
     * - Since: 3.0.0
     */
   @objc public func addChildViewController(_ childViewController: UIViewController, containerView: UIView) {
        if !childViewControllers.contains(childViewController) {
            //Add ChildViewController.
            guard let childView = childViewController.view else { return}
            addChildViewController(childViewController)
            containerView.addSubview(childView)
            childViewController.didMove(toParentViewController: self)
            
            //Add Autolayout Constraints
            childView.translatesAutoresizingMaskIntoConstraints = false
            let views: [String: UIView] = ["childView": childView]
            var visualFormatConstraints = [String]()
            visualFormatConstraints.append("H:|[childView]|")
            visualFormatConstraints.append("V:|[childView]|")
            containerView.addConstraints(visualFormatConstraints, metrics: nil, views: views)
        }
    }
    
    /**
     * Remove currentViewController from its parent-viewController.
     *
     * - Since: 3.0.0
     */
   @objc public func removeChildViewControllerFromParent() {
        willMove(toParentViewController: nil)
        view.removeFromSuperview()
        removeFromParentViewController()
    }
}
