/** © Koninklijke Philips N.V., 2017. All rights reserved. */

import UIKit

/// - Since: 3.0.0
@IBDesignable
@objcMembers open class UIDHeaderView: UIView {
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
    
    /// Title to be set to the header.
    /// - Since: 3.0.0
    @IBInspectable
    open var title: String = "" {
        didSet {
            headerLabel.text = title
        }
    }
    
    /// - Since: 3.0.0
    open let headerLabel: UILabel = UILabel.makePreparedForAutoLayout()
    
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
        configureLabel()
        configureTheme()
    }
    
    func configureLabel() {
        addSubview(headerLabel)
        headerLabel.font = UIFont(uidFont:.book, size: UIDTableViewHeaderFontSize)
        var visualStringConstraints = [String]()
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                headerLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                     constant: UIDTableViewCellConstants.contentLayoutMargins.left),
                headerLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                      constant: -UIDTableViewCellConstants.contentLayoutMargins.left)
                ])
        } else {
            visualStringConstraints.append("H:|-(paddingX)-[headerLabel]-(paddingX)-|")
        }
        visualStringConstraints.append("V:|[headerLabel]|")
        let bindingViewsInfo: [String:UIView] = ["headerLabel": headerLabel]
        let metrics: [String : Any] = ["paddingX": UIDTableViewCellConstants.contentLayoutMargins.left]
        addConstraints(visualStringConstraints, metrics: metrics, views: bindingViewsInfo)
    }
    
    func configureTheme() {
        if let currentTheme = theme {
            headerLabel.textColor = currentTheme.contentItemTertiaryText
            backgroundColor = currentTheme.contentSecondaryBackground
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: UIDTableViewHeaderHeight)
    }
}
