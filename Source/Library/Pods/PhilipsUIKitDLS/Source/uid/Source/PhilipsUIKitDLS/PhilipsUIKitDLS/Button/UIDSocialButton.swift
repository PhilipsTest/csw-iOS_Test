/** © Koninklijke Philips N.V., 2017. All rights reserved. */

import UIKit
import PhilipsIconFontDLS

/// Types of social media supported
/// - Since: 3.0.0
@objc
public enum SocialMediaType: Int {
    /// - amazon: amazon type
    /// - Since: 3.0.0
    case amazon
    /// - facebook: face book type
    /// - Since: 3.0.0
    case facebook
    /// - googlePlus: googlePlus type
    /// - Since: 3.0.0
    case googlePlus
    /// - instagram: instagram type
    /// - Since: 3.0.0
    case instagram
    /// - pinterest: pinterest type
    /// - Since: 3.0.0
    case pinterest
    /// - linkedin: linkedin type
    /// - Since: 3.0.0
    case linkedin
    /// - sinaweibo: sinaweibo type
    /// - Since: 3.0.0
    case sinaweibo
    /// - stumbleupon: stumbleupon type
    /// - Since: 3.0.0
    case stumbleupon
    /// - twitter: twitter type
    /// - Since: 3.0.0
    case twitter
    ///  vkontakte: vKontakte type
    /// - Since: 3.0.0
    case vkontakte
    /// - weChat: weChat type
    /// - Since: 3.0.0
    case weChat
    /// - youtube: youtube type
    /// - Since: 3.0.0
    case youtube
    /// - qq : qq type
    /// - Since: 3.0.0
    case qq
    /// - qzone : qzone Type
    /// - Since: 3.0.0
    case qzone
    
}
/// Type of social button
/// - Since: 3.0.0
@objc
public enum SocialButtonType: Int {
    /// - primary: primary type
    /// - Since: 3.0.0
    case primary
    /// - white: secondary type
    /// - Since: 3.0.0
    case white
}

/// A UIDSocial:)Button is the standard button to use social icons.
/// In InterfaceBuilder it is possible to create a UIButton and give it the class UIDSocialButton, the styling will be done
/// immediately.
/// **Please note:** The button must have type "Custom" (`UIButtonTypeCustom`) in order to work correctly.
/// - Since: 3.0.0
@IBDesignable
@objcMembers open class UIDSocialButton: UIButton {
    /**
     * PhilipsUIKitDLS Theme Reference.
     *
     * Default value is UIDThemeManager's defaultTheme.
     *
     * - Since: 3.0.0
     */
    open var theme = UIDThemeManager.sharedInstance.defaultTheme {
        didSet {
            configureTheme()
        }
    }
    
    /// get or set the social media type. eg. facebook, twitter
    /// - Since: 3.0.0
    public var socialMediaType: SocialMediaType = .facebook {
        didSet {
            configureButton()
        }
    }
    
    /// get or set the social button type.
    /// - Since: 3.0.0
    public var socialButtonType: SocialButtonType = .primary {
        didSet {
            configureButton()
        }
    }
    
    let myImageView = UIImageView.makePreparedForAutoLayout()
    
    /// get or set the image name via code or storyboard.
    /// - Since: 3.0.0
    @IBInspectable
    public var imageName: String = "" {
        didSet {
            image = UIImage(named: imageName)
        }
    }
    
    /// get or set the image.
    /// - Since: 3.0.0
    public var image: UIImage? = nil {
        didSet {
            configureButton()
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        instanceInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        instanceInit()
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        instanceInit()
    }
    
    func instanceInit() {
        clipsToBounds = true
        cornerRadius = UIDCornerRadius
        contentEdgeInsets  = UIEdgeInsets.zero
        titleLabel?.font = UIFont.legacyIconFont(size: UIDSocialIconSize)
        configureButton()
    }
    
    func configureButton() {
        clearStyles()
        configureType()
        configureTheme()
    }
    
    func configureType() {
        let title = getSymbolForCurrentSocialType()
        titleLabel?.isHidden = false
        imageView?.isHidden = true
        setTitle(title, for: .normal)
    }
    
    func configureTheme() {
        let normalColor, pressedColor, textColor, textPressedColor: UIColor?
        
        switch socialButtonType {
        case .primary:
            normalColor = theme?.buttonSocialMediaPrimaryIcon
            pressedColor = theme?.buttonSocialMediaPrimaryIcon
            textColor = theme?.buttonSocialMediaPrimaryBackground
            textPressedColor = theme?.buttonSocialMediaPrimaryPressedBackground
        case .white:
            normalColor = theme?.buttonSocialMediaWhiteIcon
            pressedColor = theme?.buttonSocialMediaWhiteIcon
            textColor = theme?.buttonSocialMediaWhiteBackground
            textPressedColor = theme?.buttonSocialMediaWhitePressedBackground
        }
        
        if let normalColor = normalColor,
            let pressedColor = pressedColor,
            let textColor = textColor,
            let textPressedColor = textPressedColor {
            if let image = image {
                setImage(image.applying(tintColor: normalColor), for: .normal)
                setImage(image.applying(tintColor: pressedColor), for: .highlighted)
                setBackgroundImage(textColor.createImage(), for: .normal)
                setBackgroundImage(textPressedColor.createImage(), for: .highlighted)
            } else {
                setTitleColor(textColor, for: .normal)
                setTitleColor(textPressedColor, for: .highlighted)
                setBackgroundImage(normalColor.createImage(), for: .normal)
                setBackgroundImage(pressedColor.createImage(), for: .highlighted)
            }
        }
    }
    
    func clearStyles() {
        let states: [UIControlState] = [.normal, .highlighted, .disabled, .selected]
        states.forEach { (state) in
            setImage(nil, for: state)
            setTitle(nil, for: state)
            setTitleColor(nil, for: state)
            setBackgroundImage(nil, for: state)
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width :UIDSocialIconSize, height : UIDSocialIconSize)
    }
    
    // swiftlint:disable cyclomatic_complexity
    func getSymbolForCurrentSocialType() -> String {
        switch socialMediaType {
        case .facebook:
            titleLabel?.font = UIFont.iconFont(size: UIDSocialIconSize)
            return PhilipsDLSIcon.unicode(iconType: .socialMediaFacebook)
        case .googlePlus:
            titleLabel?.font = UIFont.iconFont(size: UIDSocialIconSize)
            return PhilipsDLSIcon.unicode(iconType: .socialMediaGooglePlus)
        case .amazon:
            return PUIKitLegacyIcon.unicode(iconType: .socialMediaAmazon)
        case .instagram:
            return PUIKitLegacyIcon.unicode(iconType: .socialMediaInstagram)
        case .pinterest:
            return PUIKitLegacyIcon.unicode(iconType: .socialMediaPinterest)
        case .linkedin:
            return PUIKitLegacyIcon.unicode(iconType: .socialMediaLinkedin)
        case .sinaweibo:
            return PUIKitLegacyIcon.unicode(iconType: .socialMediaSinaweibo)
        case .stumbleupon:
            return PUIKitLegacyIcon.unicode(iconType: .socialMediaStumbleupon)
        case .twitter:
            titleLabel?.font = UIFont.iconFont(size: UIDSocialIconSize)
            return PhilipsDLSIcon.unicode(iconType: .socialMediaTwitter)
        case .vkontakte:
            return PUIKitLegacyIcon.unicode(iconType: .socialMediaVkontacte)
        case .weChat:
            return PUIKitLegacyIcon.unicode(iconType: .socialMediaWechat)
        case .youtube:
            return PUIKitLegacyIcon.unicode(iconType: .socialMediaYoutube)
        case .qq:
            return PUIKitLegacyIcon.unicode(iconType: .socialMediaQq)
        case .qzone:
            return PUIKitLegacyIcon.unicode(iconType: .socialMediaQzone)
        }
    }
}

// Temperory fix for removing the dependency of Legacy PUI Icon Font Files
private extension UIFont {
    private static let puiLegacyIconFontName = "PUIKitLegacyIcon"
    
   class func legacyIconFont(size: CGFloat) -> UIFont? {
        guard let font = UIFont(name: puiLegacyIconFontName, size: size) else {
            loadLegacyIconFont()
            return UIFont(name: puiLegacyIconFontName, size: size)
        }
        return font
    }
    
     class func loadLegacyIconFont() {
        guard let fontPath = Bundle(for: UIDButton.self).path(forResource: puiLegacyIconFontName, ofType: "ttf") else {
            return
        }
        if let fontData = NSData(contentsOfFile:fontPath) {
            loadLegacyFont(fontData: fontData)
        }
    }
    
     class func loadLegacyFont(fontData: NSData?) {
        if let fontData = fontData {
            let fontDataProvider = CGDataProvider(data: fontData)
            // http://stackoverflow.com/questions/24900979/cgfontcreatewithdataprovider-hangs-in-airplane-mode
            let _ = UIFont.familyNames
            if let fontDataProvider = fontDataProvider {
                if let font = CGFont(fontDataProvider){
                    CTFontManagerRegisterGraphicsFont(font, nil)
                }
            }
        }
    }
}

 enum PUIKitLegacyIconType :Int {
    case socialMediaAmazon = 0xE620
    case socialMediaInstagram = 0xE622
    case socialMediaPinterest = 0xE608
    case socialMediaLinkedin = 0xE607
    case socialMediaSinaweibo = 0xE628
    case socialMediaStumbleupon = 0xE609
    case socialMediaVkontacte = 0xE62A
    case socialMediaWechat = 0xE62E
    case socialMediaYoutube = 0xE60B
    case socialMediaQq = 0xE624
    case socialMediaQzone = 0xE626
}

  class PUIKitLegacyIcon: NSObject {
    class func unicode(iconType: PUIKitLegacyIconType) -> String {
        return String(format: "%C", unichar(iconType.rawValue))
    }
}

// Temperory fix for removing the dependency of Legacy PUI Icon Font Files - End
