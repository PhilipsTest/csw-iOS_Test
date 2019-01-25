/* Copyright (c) Koninklijke Philips Electronics N.V. 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsIconFontDLS

enum SplashViewConstants {
    static let mainViewMargin: CGFloat = 16
    static let shieldRatio: CGFloat = 0.146

    enum Phone {
        static let fontSize: CGFloat = 24
        static let lineHeight: CGFloat = 28
    }
    
    enum Pad {
        static let fontSize: CGFloat = 32
        static let lineHeight: CGFloat = 36
    }
}

/// - Since: 2017.5.0
@objcMembers open class UIDSplashView: UIView {
    
    let contentView = UIView.makePreparedForAutoLayout()
    
    let shieldLabel = UILabel.makePreparedForAutoLayout()
    
    let applicationTitleLabel = UILabel.makePreparedForAutoLayout()
    
    private let gradientLayer = RadialGradientLayer()
    
    private let imageLayer = CALayer()
    
    /// UIDTheme used for styling the alert controller.
    /// By default it takes the theme set in UIDThemeManager.sharedInstance.
    /// - Since: 2017.5.0
    open var theme = UIDThemeManager.sharedInstance.defaultTheme {
        didSet {
            configureTheme()
        }
    }
    
    /// colors Start and the End color
    /// - Since: 2017.5.0
    public var colors: [UIColor] = [UIColor.clear, UIColor.clear] {
        didSet {
            gradientLayer.colors = colors
        }
    }
    
    /// Image has high priority over gradient colors. Setting the image to nil
    ///  will make the gradient visible
    /// - Since: 2017.5.0
    public var image: UIImage? = nil {
        didSet {
            imageLayer.contents = image?.cgImage
            (imageLayer.isHidden, gradientLayer.isHidden) = (image != nil) ? (false, true) : (true, false)
        }
    }
    
    /// Device type should be either phone or pad.
    /// - Since: 2017.5.0
    public var deviceType: UIUserInterfaceIdiom = .phone
        
    var titleAttributes:(fontSize: CGFloat, lineHeight: CGFloat) {
        return deviceType == .phone ? (fontSize: SplashViewConstants.Phone.fontSize * scale,
                                       lineHeight: SplashViewConstants.Phone.lineHeight * scale)
            : (fontSize: SplashViewConstants.Pad.fontSize * scale,
               lineHeight: SplashViewConstants.Pad.lineHeight * scale)
    }
    
    /// Title is to be set for the splash screen
    /// - Since: 2017.5.0
    public var title = "" {
        didSet {
            applicationTitleLabel.attributedText = title.attributedString(lineSpacing: titleAttributes.lineHeight,
                                                                          textAlignment: .center)
        }
    }
    
    var scale: CGFloat = 1.0 {
        didSet {
            imageLayer.contentsScale = scale
            applicationTitleLabel.font = UIFont(uidFont: .book, size: titleAttributes.fontSize)
            title = {return title}()
        }
    }
    
    override open var frame: CGRect {
        didSet {
            shieldLabel.font = UIFont.iconFont(size: frame.size.height * SplashViewConstants.shieldRatio)
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if gradientLayer.superlayer == nil {
            layer.insertSublayer(gradientLayer, at: 0)
        }
        if imageLayer.superlayer == nil {
            layer.insertSublayer(imageLayer, at: 0)
        }
        
        imageLayer.frame = bounds
        gradientLayer.frame = bounds
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        instanceInit()
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        instanceInit()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        instanceInit()
    }
    
    func instanceInit() {
        colors = {colors}()
        configureContentView()
        configureTitleLabel()
        configureShield()
        setupContraints()
        backgroundColor = .clear
    }
    
    func configureContentView() {
        addSubviews([contentView])
        contentView.constrainCenterToParent()
        let bindingViewsInfo: [String:UIView] = ["contentView": contentView]
        var visualConstraints = [String]()
        let metrics: [String : Any] = ["paddingToMainView": SplashViewConstants.mainViewMargin]
        visualConstraints.append("H:|-(paddingToMainView)-[contentView]-(paddingToMainView)-|")
        addConstraints(visualConstraints,
                       metrics: metrics, views: bindingViewsInfo)
    }
    
    func configureShield() {
        contentView.addSubview(shieldLabel)
        shieldLabel.backgroundColor = .clear
        shieldLabel.text = PhilipsDLSIcon.unicode(iconType: .shield)
    }
    
    func configureTitleLabel() {
        contentView.addSubview(applicationTitleLabel)
        applicationTitleLabel.font = UIFont(uidFont: .book, size: titleAttributes.fontSize)
        applicationTitleLabel.backgroundColor = .clear
        applicationTitleLabel.text = title
        applicationTitleLabel.numberOfLines = 0
        applicationTitleLabel.textAlignment = .center
    }
    
    func setupContraints() {
        let spaceView = UIView.makePreparedForAutoLayout()
        contentView.addSubview(spaceView)
        shieldLabel.constrainHorizontallyCenteredToParent()
        spaceView.constrainHorizontallyCenteredToParent()
        spaceView.constrain(toWidth: UIDLineSpacing)
        spaceView.backgroundColor = .clear
        let views = ["spaceView": spaceView, "shieldLabel": shieldLabel, "applicationTitleLabel": applicationTitleLabel]
        let format = "V:|[shieldLabel][spaceView(shieldLabel)][applicationTitleLabel]|"
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: format,
                                                         options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(constraints)
        
        constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[applicationTitleLabel]|",
                                                     options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(constraints)
    }

    func configureTheme() {
        guard let theme = theme else { return }
        gradientLayer.backgroundColor = theme.splashScreenDefaultBackground?.cgColor
        gradientLayer.colors = [theme.lightDefaultLightCenter!, theme.lightDefaultLightEdge!]
        shieldLabel.textColor = theme.splashScreenDefaultIcon
        applicationTitleLabel.textColor = theme.splashScreenDefaultIcon
    }
}
