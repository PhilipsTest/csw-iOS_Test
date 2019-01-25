/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsIconFontDLS

/**
 *  UIDAboutViewDelegate is a protocol for About Screen.
 *  This protocol is responsible for Handling click events in the About Screen.
 *
 *  - Since: 2017.5.0
 */

@objc
public protocol UIDAboutViewDelegate: NSObjectProtocol {
    /// Implement this method to configure the click action when Terms And Clonditions Link is clicked
    /// - Since: 2017.5.0
    func termsAndConditionsLinkClicked()
    /// Implement this method to configure the click action when Privacy Policy Link is clicked
    /// - Since: 2017.5.0
    func privacyPolicyLinkClicked()
}

/**
 *  A UIDAboutView is the DLS conformed About View to use.
 *  In InterfaceBuilder it is possible to create a UIView and give it the class UIDAboutView,
 *  the whole View will be configured automatically
 *
 *  - Since: 2017.5.0
 */

@IBDesignable
@objcMembers open class UIDAboutView: UIView {
    
    /**
     * The shield Icon Label. Access it to do any customizations with the shield Icon.
     *
     * - Since: 2017.5.0
     */
    open var shieldLabel = UIDLabel.makePreparedForAutoLayout()
    /**
     * The Application Name Label. Access it to do any customizations with the Application Name.
     *
     * - Since: 2017.5.0
     */
    open var applicationNameLabel = UIDLabel.makePreparedForAutoLayout()
    /**
     * The Version Label. Access it to do any customizations with the Version.
     *
     * - Since: 2017.5.0
     */
    open var versionLabel = UIDLabel.makePreparedForAutoLayout()
    /**
     * The Copyright Label. Access it to do any customizations with the Copyright.
     *
     * - Since: 2017.5.0
     */
    open var copyrightLabel = UIDLabel.makePreparedForAutoLayout()
    /**
     * The Terms and Conditions Label. Access it to do any customizations with the Terms and Conditions.
     *
     * - Since: 2017.5.0
     */
    open var termsAndConditionLabel = UIDHyperLinkLabel.makePreparedForAutoLayout()
    /**
     * The Privacy Policy Label. Access it to do any customizations with the Privacy Policy.
     *
     * - Since: 2017.5.0
     */
    open var privacyPolicyLabel = UIDHyperLinkLabel.makePreparedForAutoLayout()
    /**
     * The Disclosure Statement Label. Access it to do any customizations with the Disclosure Statement.
     *
     * - Since: 2017.5.0
     */
    open var disclosureStatementLabel = UIDLabel.makePreparedForAutoLayout()
    
    /**
     * UIDAboutView's Delegate.
     *
     * - Since: 2017.5.0
     */
    weak public var delegate: UIDAboutViewDelegate?
    
    /**
     * Application Name to be set
     *
     * Default is Blank.
     *
     * - Since: 2017.5.0
     */
    @IBInspectable
    open var applicationName: String = "" {
        didSet {
            applicationNameLabel.text = applicationName
        }
    }
    
    /**
     * Version to be set
     *
     * Default is Blank.
     *
     * - Since: 2017.5.0
     */
    @IBInspectable
    open var version: String = "" {
        didSet {
            versionLabel.text = version
        }
    }
    
    /**
     * Copyright to be set
     *
     * Default is Blank.
     *
     * - Since: 2017.5.0
     */
    @IBInspectable
    open var copyright: String = "" {
        didSet {
            copyrightLabel.text = copyright
        }
    }
    
    /**
     * Terms and Conditions Link Text to be set
     *
     * Default is Blank.
     *
     * - Since: 2017.5.0
     */
    @IBInspectable
    open var termsAndConditionsLinkText: String = "" {
        didSet {
            configureTermsAndConditionLink()
        }
    }
    
    /**
     * Privay Policy Link Text to be set
     *
     * Default is Blank.
     *
     * - Since: 2017.5.0
     */
    @IBInspectable
    open var privacyPolicyLinkText: String = "" {
        didSet {
            configurePrivacyPolicyLink()
        }
    }
    
    /**
     * Disclosure Statement to be set
     *
     * Default is Blank.
     *
     * - Since: 2017.5.0
     */
    @IBInspectable
    open var disclosureStatement: String = "" {
        didSet {
            disclosureStatementLabel.text = disclosureStatement
        }
    }
    
    let aboutScrollView = UIScrollView.makePreparedForAutoLayout()
    let aboutStackView = UIStackView.makePreparedForAutoLayout()
    let applicationNameView = UIDView.makePreparedForAutoLayout()
    let applicationDetailsView = UIDView.makePreparedForAutoLayout()
    
    var shieldSize: CGFloat {
        return 0.09 * max(UIScreen.main.bounds.size.height,
                          UIScreen.main.bounds.size.width)
    }
    
    var theme: UIDTheme? = UIDThemeManager.sharedInstance.whiteTheme {
        didSet {
            configureShieldTheme()
            configureTheme()
        }
    }
    
    var shieldTheme: UIDTheme?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        instanceInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        instanceInit()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        instanceInit()
    }
}

extension UIDAboutView {
    
    func instanceInit() {
        configureShieldTheme()
        setupMainScrollView()
        setupMainStackView()
        configureTheme()
    }
    
    func configureShieldTheme() {
        if let theme = theme {
            let shieldThemeConfiguration = UIDThemeConfiguration(colorRange: .philipsBrand,
                                                                 tonalRange: theme.tonalRange)
            shieldTheme = UIDTheme(themeConfiguration: shieldThemeConfiguration)
        }
    }
    
    func setupMainScrollView() {
        addSubview(aboutScrollView)
        aboutScrollView.showsHorizontalScrollIndicator = false
        aboutScrollView.showsVerticalScrollIndicator = false
        aboutScrollView.canCancelContentTouches = true
        aboutScrollView.delaysContentTouches = false
        aboutScrollView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        aboutScrollView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        aboutScrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        aboutScrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func setupMainStackView() {
        aboutScrollView.addSubview(aboutStackView)
        aboutStackView.axis = .vertical
        aboutStackView.spacing = UIDSize20*2
        aboutStackView.isLayoutMarginsRelativeArrangement = true
        aboutStackView.layoutMargins = UIEdgeInsets(top: 0, left: UIDSize16, bottom: 0, right: UIDSize16)
        aboutStackView.leftAnchor.constraint(equalTo: aboutScrollView.leftAnchor).isActive = true
        aboutStackView.rightAnchor.constraint(equalTo: aboutScrollView.rightAnchor).isActive = true
        aboutStackView.topAnchor.constraint(equalTo: aboutScrollView.topAnchor).isActive = true
        aboutStackView.bottomAnchor.constraint(equalTo: aboutScrollView.bottomAnchor).isActive = true
        aboutStackView.widthAnchor.constraint(equalTo: aboutScrollView.widthAnchor).isActive = true
        setupApplicationNameView()
        createApplicationDetailsView()
        aboutStackView.addArrangedSubviews([applicationNameView, applicationDetailsView])
    }
    
    func setupApplicationNameView() {
        setupShieldLabel()
        setupApplicationNameLabel()
        applicationNameView.backgroundColor = .clear
        applicationNameView.addSubview(shieldLabel)
        applicationNameView.addSubview(applicationNameLabel)
        
        shieldLabel.centerXAnchor.constraint(equalTo: applicationNameView.centerXAnchor).isActive = true
        shieldLabel.topAnchor.constraint(equalTo: applicationNameView.topAnchor, constant: shieldSize).isActive = true
        
        applicationNameLabel.leftAnchor.constraint(equalTo: applicationNameView.leftAnchor).isActive = true
        applicationNameLabel.rightAnchor.constraint(equalTo: applicationNameView.rightAnchor).isActive = true
        applicationNameLabel.bottomAnchor.constraint(equalTo: applicationNameView.bottomAnchor).isActive = true
        applicationNameLabel.centerXAnchor.constraint(equalTo: applicationNameView.centerXAnchor).isActive = true
        applicationNameLabel.topAnchor.constraint(equalTo: shieldLabel.bottomAnchor, constant: shieldSize).isActive = true
    }
    
    func setupShieldLabel() {
        shieldLabel.font = UIFont.iconFont(size: shieldSize)
        shieldLabel.text = PhilipsDLSIcon.unicode(iconType: .shield)
        shieldLabel.backgroundColor = .clear
        shieldLabel.numberOfLines = 0
    }
    
    func setupApplicationNameLabel() {
        applicationNameLabel.font = UIFont(uidFont: .light, size: UIDSize20)
        applicationNameLabel.text = applicationName
        applicationNameLabel.backgroundColor = .clear
        applicationNameLabel.numberOfLines = 0
        applicationNameLabel.textAlignment = .center
    }
    
    func createApplicationDetailsView() {
        setupVersionLabel()
        setupCopyrightLabel()
        setupTermsAndConditionsLabel()
        setupPrivacyPolicyLabel()
        setupDisclosureLabel()
        applicationDetailsView.backgroundColor = .clear
        
        let applicationDetailsStackView = UIStackView.makePreparedForAutoLayout()
        applicationDetailsStackView.spacing = UIDSize24
        applicationDetailsStackView.axis = .vertical
        
        let applicationLegalDetailsStackView = UIStackView.makePreparedForAutoLayout()
        applicationLegalDetailsStackView.spacing = UIDSize16
        applicationLegalDetailsStackView.axis = .vertical
        applicationLegalDetailsStackView.addArrangedSubviews([versionLabel, copyrightLabel])
        
        let appOtherDetailsStackView = UIStackView.makePreparedForAutoLayout()
        appOtherDetailsStackView.spacing = UIDSize24
        appOtherDetailsStackView.axis = .vertical
        appOtherDetailsStackView.addArrangedSubviews([termsAndConditionLabel, privacyPolicyLabel, disclosureStatementLabel])
        
        applicationDetailsStackView.addArrangedSubviews([applicationLegalDetailsStackView, appOtherDetailsStackView])
        
        applicationDetailsView.addSubview(applicationDetailsStackView)
        applicationDetailsStackView.leftAnchor.constraint(equalTo: applicationDetailsView.leftAnchor).isActive = true
        applicationDetailsStackView.rightAnchor.constraint(equalTo: applicationDetailsView.rightAnchor).isActive = true
        applicationDetailsStackView.topAnchor.constraint(equalTo: applicationDetailsView.topAnchor).isActive = true
        applicationDetailsStackView.bottomAnchor.constraint(equalTo: applicationDetailsView.bottomAnchor).isActive = true
    }
    
    func setupVersionLabel() {
        versionLabel.numberOfLines = 0
        versionLabel.backgroundColor = .clear
        versionLabel.font = UIFont(uidFont: .bold, size: UIDSize16)
        versionLabel.text = version
    }
    
    func setupCopyrightLabel() {
        copyrightLabel.numberOfLines = 0
        copyrightLabel.backgroundColor = .clear
        copyrightLabel.font = UIFont(uidFont: .book, size: UIDSize16)
        copyrightLabel.text = copyright
    }
    
    func setupTermsAndConditionsLabel() {
        termsAndConditionLabel.theme = theme
        termsAndConditionLabel.backgroundColor = .clear
        termsAndConditionLabel.numberOfLines = 0
        termsAndConditionLabel.lineBreakMode = .byWordWrapping
        termsAndConditionLabel.font = UIFont(uidFont: .book, size: UIDSize16)
        configureTermsAndConditionLink()
    }
    
    func configureTermsAndConditionLink() {
        termsAndConditionLabel.text = termsAndConditionsLinkText
        let termsAndConditionModel = UIDHyperLinkModel()
        termsAndConditionLabel.addLink(termsAndConditionModel) { [weak self] _ in
            self?.delegate?.termsAndConditionsLinkClicked()
        }
    }
    
    func setupPrivacyPolicyLabel() {
        privacyPolicyLabel.theme = theme
        privacyPolicyLabel.backgroundColor = .clear
        privacyPolicyLabel.numberOfLines = 0
        privacyPolicyLabel.lineBreakMode = .byWordWrapping
        privacyPolicyLabel.font = UIFont(uidFont: .book, size: UIDSize16)
        configurePrivacyPolicyLink()
    }
    
    func configurePrivacyPolicyLink() {
        privacyPolicyLabel.text = privacyPolicyLinkText
        let privacyPolicyModel = UIDHyperLinkModel()
        privacyPolicyLabel.addLink(privacyPolicyModel) { [weak self] _ in
            self?.delegate?.privacyPolicyLinkClicked()
        }
    }
    
    func setupDisclosureLabel() {
        disclosureStatementLabel.numberOfLines = 0
        disclosureStatementLabel.backgroundColor = .clear
        disclosureStatementLabel.font = UIFont(uidFont: .book, size: UIDSize16)
        disclosureStatementLabel.text = disclosureStatement
    }
    
    func configureTheme() {
        aboutScrollView.backgroundColor = theme?.aboutScreenFullScreenBackground
        shieldLabel.textColor = shieldTheme?.aboutScreenDefaultShield
        applicationNameLabel.textColor = theme?.aboutScreenDefaultTitle
        versionLabel.textColor = theme?.aboutScreenDefaultSubtitle
        copyrightLabel.textColor = theme?.aboutScreenDefaultText
        disclosureStatementLabel.textColor = theme?.aboutScreenDefaultText
    }
}
