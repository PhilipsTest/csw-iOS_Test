/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

/**
 *  A UIDTabBar is the standard Tab Bar to use as per DLS guideline.
 *  In InterfaceBuilder it is possible to create a TabBar and give it the class UIDTabBar,
 *  the styling and layout setup will be done immediately.
 *
 *  - Since: 2017.5.0
 */

@objcMembers
open class UIDTabBar: UITabBar {
    
    weak var tabController: UIDTabBarController?
    
    var notificationBadge: UIDNotificationBadgeLabel {
        let dlsBadge = UIDNotificationBadgeLabel.makePreparedForAutoLayout()
        dlsBadge.badgeType = .small
        return dlsBadge
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutBadges()
    }
    
    open override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
        super.setItems(items, animated: animated)
        items?.forEach { ($0 as? UIDTabBarItem)?.tabBar = self }
        tabController?.setUpTabs()
    }
}

extension UIDTabBar {
    
    func layoutBadges() {
        guard let tabBarItems = items else { return }
        tabBarItems.forEach { self.didSet(badgeValue: $0.badgeValue, of: $0) }
    }
    
   @objc func didSet(badgeValue: String?, of tabItem: UITabBarItem) {
        guard tabItem is UIDTabBarItem, let tabItemIndex = items?.index(of: tabItem) else { return }
        
        let barButtons = subviews
            .filter { String(describing: type(of: $0)).contains("TabBarButton") }
            .sorted { $0.frame.origin.x < $1.frame.origin.x }
        
        let tabBarButton = barButtons[tabItemIndex]
        for badgeView in tabBarButton.subviews {
            let className = String(describing: type(of: badgeView))
            guard className.contains("BadgeView") else { continue }
            var dlsBadge: UIDNotificationBadgeLabel!
            badgeView.backgroundColor = .clear
            for badgeSubview in badgeView.subviews {
                if !(badgeSubview is UIDNotificationBadgeLabel) {
                    badgeSubview.isHidden = true
                } else {
                    dlsBadge = badgeSubview as? UIDNotificationBadgeLabel
                }
            }
            if dlsBadge == nil {
                dlsBadge = notificationBadge
                badgeView.addSubview(dlsBadge)
                dlsBadge.constrainToSuperviewTop()
                dlsBadge.constrainToSuperviewLeft()
            }
            if let badge = badgeValue, let badgeCount = Int(badge) {
                dlsBadge?.badgeCount = badgeCount
            } else {
                dlsBadge?.badgeCount = 0
            }
            break
        }
    }
}
