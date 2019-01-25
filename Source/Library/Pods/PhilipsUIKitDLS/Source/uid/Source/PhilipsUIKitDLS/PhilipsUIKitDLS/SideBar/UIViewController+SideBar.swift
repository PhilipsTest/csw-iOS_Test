/* Copyright (c) Koninklijke Philips Electronics N.V. 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

public extension UIViewController {
    /**
     * Access sideBar-view-controller Instance.
     *
     * - Since: 3.0.0
     */
  @objc public func sideBarViewController() -> UIDSideBarViewController? {
        var viewController: UIViewController? = self
        while viewController != nil {
            if viewController is UIDSideBarViewController {
                return viewController as? UIDSideBarViewController
            }
            viewController = viewController?.parent
        }
        return nil
    }
    
    /**
     * Show SideBar API.
     *
     * - Since: 3.0.0
     */
    @objc public func showSideBar( _ type: UIDSideBarType) {
        sideBarViewController()?.showSideBar(type)
    }
    
    /**
     * Hide SideBar API.
     *
     * - Since: 3.0.0
     */
    @objc public func hideSideBar( _ type: UIDSideBarType) {
        sideBarViewController()?.hideSideBar(type)
    }
    
    /**
     * isVisible SideBar API.
     *
     * - Since: 3.0.0
     */
    @objc public func isVisibleSideBar( _ type: UIDSideBarType) -> Bool {
        return (sideBarViewController()?.isVisibleSideBar(type))!
    }
}
