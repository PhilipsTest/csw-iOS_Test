/* Copyright (c) Koninklijke Philips Electronics N.V. 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

public extension UIDSideBarViewController {
    /**
     * Set side-bar left,middle & right view-controllers respectively.
     *
     * - Since: 3.0.0
     */
   @objc public func setViewControllers(left: UIViewController?,
                                   middle: UIViewController,
                                   right: UIViewController?) {
        setViewController(left, type: .left)
        setViewController(middle, type: .middle)
        setViewController(right, type: .right)
    }
    
    /**
     * Set side-bar viewcontrollers with type left,middle & right.
     *
     * - Since: 3.0.0
     */
    @objc public func setViewController(_ viewController: UIViewController?, type: UIDSideBarViewControllerType) {
        guard let viewController = viewController else { return }
        if type == .left {
            setLeftSideBarViewController(viewController)
        } else if type == .middle {
            setMiddleSideBarViewController(viewController)
        } else {
            setRightSideBarViewController(viewController)
        }
    }
    
    /**
     * Set side-bar left viewcontroller.
     *
     * - Since: 3.0.0
     */
    @objc public func setLeftSideBarViewController(_ viewController: UIViewController) {
        if viewController !== leftViewController {
            if leftViewController != nil {
                leftViewController?.removeChildViewControllerFromParent()
            }
            leftViewController = viewController
            setViewController(viewController, containerView: leftView, type: .left)
        }
    }
    
    /**
     * Set side-bar middle viewcontroller.
     *
     * - Since: 3.0.0
     */
    @objc public func setMiddleSideBarViewController(_ viewController: UIViewController) {
        if viewController !== middleViewController {
            if middleViewController != nil {
                middleViewController?.removeChildViewControllerFromParent()
            }
            middleViewController = viewController
            setViewController(viewController, containerView: middleView, type: .middle)
        }
    }
    
    /**
     * Set side-bar right viewcontroller.
     *
     * - Since: 3.0.0
     */
    @objc public func setRightSideBarViewController(_ viewController: UIViewController) {
        if viewController !== rightViewController {
            if rightViewController != nil {
                rightViewController?.removeChildViewControllerFromParent()
            }
            rightViewController = viewController
            setViewController(viewController, containerView: rightView, type: .right)
        }
    }
    
    ///setup viewcontroller i.e Add childViewController, Add Autolayout constraints.
    func setViewController(_ viewController: UIViewController, containerView: UIView?, type: UIDSideBarViewControllerType) {
        guard let containerView = containerView else { return }
        delegate?.sideBar?(self, willAddViewController: viewController, ofType: type)
        addChildViewController(viewController, containerView: containerView)
        configureTheme()
        delegate?.sideBar?(self, didAddViewController: viewController, ofType: type)
    }
}
