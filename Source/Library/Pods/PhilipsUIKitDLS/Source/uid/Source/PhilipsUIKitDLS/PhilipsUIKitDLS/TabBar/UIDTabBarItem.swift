/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

/**
 *  A UIDTabBarItem is the standard Tab Bar Item to use as per DLS guideline.
 *  In InterfaceBuilder it is possible to create a TabBarItem and give it the class UIDTabBar,
 *  the styling and layout setup will be done immediately.
 *
 *  - Since: 2017.5.0
 */

@objcMembers open class UIDTabBarItem: UITabBarItem {
    
    weak var tabBar: UIDTabBar?
    
    open override var title: String? {
        didSet {
            if tabBar?.tabController?.tabBarType == .iconOnly {
                super.title = nil
            }
        }
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        if badgeValue != nil {
            customBadgeValue = badgeValue
        }
    }
    
    override open var badgeValue: String? {
        didSet {
            customBadgeValue = badgeValue
        }
    }
    
    var customBadgeValue: String? {
        didSet {
            tabBar?.didSet(badgeValue: customBadgeValue, of: self)
        }
    }
}
