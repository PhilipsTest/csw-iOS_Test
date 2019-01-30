/** © Koninklijke Philips N.V., 2016. All rights reserved. */

import Foundation
import PhilipsIconFontDLS
/**
 *  The UIDThemeManager manages themes project-wide.
 *  There are eight UIDTheme's to choose from, group-blue, blue, aqua, green, orange, pink, purple and gray.
 *
 *  After setting your theme, the whole
 *  app will have that theme by default. Most components do have a `setTheme` method where you can override the defaultTheme.
 *  Also colors set from InterfaceBuilder override the currentTheme colors.
 *
 * - Since: 3.0.0
 */
@objcMembers public class UIDThemeManager: NSObject {
    
    /**
     *  Get the singleton ThemeManager
     *
     *  @return sharedInstance
     *
     * - Since: 3.0.0
     */
    public static let sharedInstance = UIDThemeManager()
    
    /**
     *  Use this property to get access of "current-Theme" reference.
     *  @note This is read-only property for outside "UIDThemeManager" class.
     *
     * - Since: 3.0.0
     */
    public private(set) var defaultTheme: UIDTheme? = UIDTheme() {
        didSet {
            createWhiteTheme()
        }
    }
    
    /// - Since: 3.0.0
    public var whiteTheme: UIDTheme?
    
    func createWhiteTheme() {
        if let theme = self.defaultTheme {
            let tonalRange = theme.tonalRange == .veryLight || theme.tonalRange == .bright ? .ultraLight : theme.tonalRange
            let themeConfig = UIDThemeConfiguration(colorRange: theme.colorRange, tonalRange: tonalRange,
                                                    navigationTonalRange: theme.navigationTonalRange,
                                                    accentColorRange: theme.accentColorRange)
            self.whiteTheme = UIDTheme(themeConfiguration: themeConfig)
        }
    }
    
    /**
        Use this property to overwrite the Show/Hide of the back button text
        - Important:
        **Default is false**, means by-default there will be no-text with back-button. It will be just arrow only button.
     
        - Since: 3.0.0
     */
    public var showBackButtonText: Bool = false
    
    /**
     *  Set to true to use a transparent navigation bar.
     *  The tintColor / titleColor and hamburger button will be set to PUIColorTypeDark with a darkColor
     *
     * - Since: 3.0.0
     */
    public var navigationBarTransparent: Bool = false {
        didSet {
            if isNavigationBarStylingApplied == true { applyNavigationBarStyling() }
        }
    }
    
    /**
     * Set the color of the title / hamburger menu item
     * Default is white, you should use this only when navigation bar is transparent!
     *
     * - Since: 3.0.0
     */
    public var tintColor: UIColor = UIColor.white {
        didSet {
            if isNavigationBarStylingApplied == true { applyNavigationBarStyling() }
        }
    }
    
    private var isNavigationBarStylingApplied = true
    
    /**
     * Sets the default theme.
     *
     * Setting the default theme only affects PhilipsUIKitDLS components, not standard iOS components. There is one important
     * exception to this: the navigation bar. 
     * Since it is not possible for PhilipsUIKitDLS to have its own navigation bar class,
     * styling of the navigation bar will apply to **all** navigation bars in your app. Therefore, using the parameter
     * applyNavigationBarStyling you can decide whether you want to change the navigation bar as well.
     *
     * @param theme the new default theme that should be used by new components
     * @param applyNavigationBarStyling indicates whether styling of the navigation bar should also be applied
     *
     * - Since: 3.0.0
     */
    public func setDefaultTheme(theme: UIDTheme, applyNavigationBarStyling: Bool) {
        UIDFont.loadAllFonts()
        self.defaultTheme = theme
        UIViewController.arrowBackBarButtonItem()
        self.isNavigationBarStylingApplied = applyNavigationBarStyling
        self.tintColor = (self.defaultTheme?.navigationPrimaryText)!
        self.navigationBarTransparent = !applyNavigationBarStyling
    }
    
    /**
     Sets the NavigationBar shadow level.
     - Important:
     **Default is UIDNavigationShadowLevel.two**.
     
     - Since: 3.0.0
     */
    public func setNavigationBarShadowLevel(_ level: UIDNavigationShadowLevel) {
        self.setupNonTranslucentNavigationBar(withShadowLevel: level)
    }
    
    private func applyNavigationBarStyling() {
        self.setupNavigationBarTitleStyling()
        self.setupNavigationBarBackButton()
        
        if self.navigationBarTransparent {
            self.setupTranslucentNavigationBar()
        } else {
            self.setupNonTranslucentNavigationBar(withShadowLevel: .two)
        }
    }
    
    private func setupNavigationBarTitleStyling() {
        UINavigationBar.appearance().tintColor = self.tintColor
        UINavigationBar.appearance().barStyle = .blackTranslucent
        let titleFont = UIFont(uidFont:.medium, size: UIDFontSizeLarge)
        if let titleFont = titleFont {
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: self.tintColor,
                                                          .font: titleFont]
        }
    }
    
    private func setupTranslucentNavigationBar() {
        UINavigationBar.appearance().barTintColor = UIColor.clear
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().setBackgroundImage(nil, for: .compact)
        UINavigationBar.appearance().setBackgroundImage(nil, for: .default)
        UINavigationBar.appearance().shadowImage = nil
    }
    
    private func setupNonTranslucentNavigationBar(withShadowLevel level: UIDNavigationShadowLevel) {
        let color = self.defaultTheme?.navigationPrimaryBackground
        UINavigationBar.appearance().barTintColor = color
        UINavigationBar.appearance().isTranslucent = false
        let deviceWidth = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        let backgroundImage = color?.createImage(with: CGSize(width: deviceWidth, height: UIDNavigationBarHeight))
        UINavigationBar.appearance().setBackgroundImage(backgroundImage, for: .compact)
        UINavigationBar.appearance().setBackgroundImage(backgroundImage, for: .default)
        let shadowImage = self.navigationBarShadowImage(withShadowLevel: level)
        UINavigationBar.appearance().shadowImage = shadowImage
    }
    
    private func navigationBarShadowImage(withShadowLevel level: UIDNavigationShadowLevel) -> UIImage? {
        let deviceWidth = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        let shadowHeight = level == .one ? UIDPrimaryNavigationBarShadowHeight : UIDSecondaryNavigationBarShadowHeight
        let startColor = self.defaultTheme?.shadowLevelTwoShadow
        let endColor = startColor?.withAlphaComponent(0)
        let shadowView = UIView(frame: CGRect.zero)
        shadowView.frame.size = CGSize(width: deviceWidth, height: shadowHeight)
        let layer = CAGradientLayer()
        layer.colors = [startColor!.cgColor, endColor!.cgColor]
        layer.frame = shadowView.bounds
        shadowView.layer.addSublayer(layer)
        return shadowView.drawImage()
    }
    
    private func setupNavigationBarBackButton() {
        let image = navigationBarBackButtonImage()
        UINavigationBar.appearance().backIndicatorImage = image
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = image
        let barButtonTitleFont = UIFont(uidFont:.book, size: UIDFontSizeMedium)
        if let barButtonTitleFont = barButtonTitleFont {
            UIBarButtonItem.appearance().setTitleTextAttributes([.font: barButtonTitleFont], for: .normal)
        }
    }
    
    private func navigationBarBackButtonImage() -> UIImage? {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.clear
        button.frame = CGRect(x: 0, y: 0, width: UIDBarButtonSize, height: UIDBarButtonSize)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont.iconFont(size: UIDBarButtonSize)
        button.setTitle(PhilipsDLSIcon.unicode(iconType: .navigationLeft24), for: .normal)
        return button.drawImage()
    }
}
