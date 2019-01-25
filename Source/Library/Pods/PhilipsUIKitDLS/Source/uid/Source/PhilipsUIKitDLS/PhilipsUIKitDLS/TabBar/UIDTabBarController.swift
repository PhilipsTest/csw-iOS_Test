/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

/**
 * The types of Tab Bar Controller (UIDTabBarType) that are available.
 * In code, you should use these types. Unfortunately, Interface Builder doesn't support enums yet,
 * so if you configure the Tab Bar Controller in Interface Builder, you have to use the numeric values.
 *
 * - Since: 2017.5.0
 */

@objc
public enum UIDTabBarType: Int {
    /// default Tab Bar Controller Type: (numerical value: 0).
    /// In this type,user can see both Icon and Title of the Tab Bar Item
    /// - Since: 2017.5.0
    case iconWithTitle
    /// This is a icon only Tab Bar Type: (numerical value: 1).
    /// In this type,user can see only the Icon of the Tab Bar Item
    ///
    /// - Important:
    /// This type only works with **Tab Bar Item** of **Custom type** .
    /// This will not work with System Tab Bar Item Types (like Favourite,Contacts,etc)
    /// - Since: 2017.5.0
    case iconOnly
}

/**
 *  A UIDTabBarController is the standard Tab Bar Controller to use as per DLS guideline.
 *  In InterfaceBuilder it is possible to create a TabBarController and give it the class UIDTabBarController,
 *  the styling and layout setup will be done immediately.
 *
 *
 * - Important:
 * In Order to make the Tab Bar Controller DLS Compliant, please change **Tab Bar class to UIDTabBar** and
 * **Tab Bar Item class to UIDTabBarItem**. Failing to do so,might end up in Unexpected Behaviour.
 *  - Since: 2017.5.0
 */
@IBDesignable
@objcMembers open class UIDTabBarController: UITabBarController {
    
    open var theme: UIDTheme? = UIDThemeManager.sharedInstance.defaultTheme {
        didSet {
            configureTheme()
            createShadowForTab()
        }
    }
    
    // swiftlint:disable valid_ibinspectable
    /**
     * Type of Tab Bar Controller.
     *
     * Default value is UIDTabBarType.iconWithTitle
     *
     * - Since: 2017.5.0
     */
    @IBInspectable
    public var tabBarType: UIDTabBarType = .iconWithTitle {
        didSet {
            if oldValue != tabBarType {
                tabBar.layoutSubviews()
                view.setNeedsLayout()
            }
        }
    }
    // swiftlint:enable valid_ibinspectable
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        if let tabBar = tabBar as? UIDTabBar {
            tabBar.tabController = self
        }
        instanceInit()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupMoreItemForIcon()
        createShadowForTab()
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard #available(iOS 11.0, *) else {
            var tabFrame = tabBar.frame
            tabFrame.size.height = tabBarType == .iconOnly ? 48 : 56
            tabFrame.origin.y = view.frame.size.height - tabFrame.size.height
            self.tabBar.frame = tabFrame
            return
        }
    }
}

extension UIDTabBarController {
    
    func instanceInit() {
        configureTheme()
    }
    
    func createShadowForTab() {
        if let theme = theme {
            let shadow = UIDDropShadow(radius: UIDSize8/4,
                                       offset: CGSize(width: 0, height: 0),
                                       color:theme.brushes.shadowLevelTwo(tonalRange:
                                        theme.tonalRange).color(in: theme.colorRange))
            tabBar.apply(dropShadow: shadow)
        }
    }
    
    func setUpTabs() {
        tabBar.items?.forEach({
            if let image = $0.image {
                $0.image = imageFor(image: image)?.withRenderingMode(.alwaysOriginal)
                if let version = Float(UIDevice.current.systemVersion), version < 11.0 {
                    $0.imageInsets = UIEdgeInsets(top: -UIDSize8/4, left: 0, bottom: UIDSize8/4, right: 0)
                    $0.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -UIDSize8/4)
                }
            }
        })
        setupTabForIconOnly()
    }
    
    func setupTabForIconOnly() {
        guard let tabBarItems = tabBar.items, tabBarType == .iconOnly else { return }
        
        tabBarItems.forEach {
            $0.title = nil
            $0.imageInsets = UIEdgeInsets(top: UIDSize8/2, left: 0, bottom: -UIDSize8/2, right: 0)
        }
    }
    
    func setupMoreItemForIcon() {
        let tabTitle = tabBarType == .iconOnly ? nil : moreNavigationController.title
        let tabImage = UIImage.imageWithIconFontType(.threeDotsHorizontal, iconSize: UIDSize24)
        moreNavigationController.tabBarItem = UIDTabBarItem(title: tabTitle, image: tabImage, tag: 0)
    }
    
    func configureTheme() {
        tabBar.barTintColor = theme?.contentPrimaryBackground
        tabBar.tintColor = theme?.tabsDefaultOnIcon
        tabBar.backgroundColor = theme?.contentPrimaryBackground
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        
        if let titleFont = UIFont(uidFont: .book, size: UIDSize24/2),
            let titleColorNormal = theme?.tabsDefaultOffText,
            let titleColorSelected = theme?.tabsDefaultOnText {
            UITabBarItem.appearance(whenContainedInInstancesOf:
                [UIDTabBar.self]).setTitleTextAttributes([.foregroundColor: titleColorNormal,
                                                          .font: titleFont],
                                                         for: .normal)
            UITabBarItem.appearance(whenContainedInInstancesOf:
                [UIDTabBar.self]).setTitleTextAttributes([.foregroundColor: titleColorSelected,
                                                          .font: titleFont],
                                                         for: .selected)
        }
        setUpTabs()
    }
    
   @objc func imageFor(image: UIImage) -> UIImage? {
        var generatedImage: UIImage?
        let size = image.size
        let scale: CGFloat = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let context = UIGraphicsGetCurrentContext()
        
        if let imageCGImage = image.cgImage,
            let imageColor = theme?.tabsDefaultOffIcon,
            let context = context {
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1, y: -1)
            context.clip(to: CGRect(origin: .zero, size: size), mask: imageCGImage)
            context.setFillColor(UIColor.white.withAlphaComponent(imageColor.cgColor.alpha).cgColor)
            context.fill(CGRect(origin: .zero, size: size))
            context.setFillColor(imageColor.cgColor)
            context.fill(CGRect(origin: .zero, size: size))
            generatedImage = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return generatedImage
    }
}
