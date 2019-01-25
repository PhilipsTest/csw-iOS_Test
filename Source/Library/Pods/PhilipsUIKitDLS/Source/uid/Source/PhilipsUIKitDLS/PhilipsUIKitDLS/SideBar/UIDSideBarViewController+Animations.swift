/* Copyright (c) Koninklijke Philips Electronics N.V. 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

/// Show/Hide Sidebar Animation.
extension UIDSideBarViewController {
    func showLeftSideBar() {
        isLeftSideBarVisible = true
        leftSideBarMenuOriginXConstraint?.constant = 0
        leftView?.setNeedsUpdateConstraints()
        UIView.animate(withDuration: UIDSideBarAnimationDuration, animations: {
            UIApplication.shared.keyWindow?.windowLevel = UIWindowLevelStatusBar
            self.view.layoutIfNeeded()
        }) { (_) in
            self.delegate?.sideBar?(self, didShowSideBarOfType: .left)
        }
        if shouldShadowVisible { addLeftSideBarShadow() }
    }
    
    func showRightSideBar() {
        isRightSideBarVisible = true
        rightSideBarMenuOriginXConstraint?.constant = UIDevice.width - rightSideBarWidth
        rightView?.setNeedsUpdateConstraints()
        UIView.animate(withDuration: UIDSideBarAnimationDuration, animations: {
            self.view.layoutIfNeeded()
            UIApplication.shared.keyWindow?.windowLevel = UIWindowLevelStatusBar
        }) { (_) in
            self.delegate?.sideBar?(self, didShowSideBarOfType: .left)
        }
        if shouldShadowVisible { addRightSideBarShadow() }
    }
    
    func hideLeftSideBar() {
        isLeftSideBarVisible = false
        leftSideBarMenuOriginXConstraint?.constant = -leftSideBarWidth
        leftView?.setNeedsUpdateConstraints()
        UIView.animate(withDuration: UIDSideBarAnimationDuration, animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            UIApplication.shared.keyWindow?.windowLevel = UIWindowLevelNormal
            self.removeLeftSideBarShadow()
            self.delegate?.sideBar?(self, didHideSideBarOfType: .left)
        }
    }
    
    func hideRightSideBar() {
        isRightSideBarVisible = false
        rightSideBarMenuOriginXConstraint?.constant = UIDevice.width
        rightView?.setNeedsUpdateConstraints()
        UIView.animate(withDuration: UIDSideBarAnimationDuration, animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            UIApplication.shared.keyWindow?.windowLevel = UIWindowLevelNormal
            self.removeRightSideBarShadow()
            self.delegate?.sideBar?(self, didHideSideBarOfType: .right)
        }
    }
}

/// Add/Remove Sidebar shadow.
extension UIDSideBarViewController {
    func addLeftSideBarShadow() {
        if let theme = theme {
            let dropShadow = UIDDropShadow(level: .level3, theme: theme)
            leftView?.apply(dropShadow: dropShadow)
        }
    }
    
    func removeLeftSideBarShadow() {
        leftView?.removeDropShadow()
    }
    
    func addRightSideBarShadow() {
        if let theme = theme {
            let dropShadow = UIDDropShadow(level: .level3, theme: theme)
            rightView?.apply(dropShadow: dropShadow)
        }
    }
    
    func removeRightSideBarShadow() {
        rightView?.removeDropShadow()
    }
}
