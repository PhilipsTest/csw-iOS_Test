/** © Koninklijke Philips N.V., 2017. All rights reserved. */

import UIKit

/// - Since: 3.0.0
@objcMembers open
class UIDTableViewHeaderView: UITableViewHeaderFooterView {
    
    /// - Since: 3.0.0
    open var title = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    /// The title can be set using titleLabel
    let titleLabel = UILabel.makePreparedForAutoLayout()
    
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
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
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
        setupTitleLabel()
        configureDefaultProperties()
        configureTheme()
    }
    
    func configureDefaultProperties() {
        if self.responds(to: #selector(setter: layoutMargins)) {
            layoutMargins = .zero
        }
        
        if self.responds(to: #selector(setter: preservesSuperviewLayoutMargins)) {
            preservesSuperviewLayoutMargins = false
        }
        textLabel?.isHidden = true
        detailTextLabel?.isHidden = true
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.font = UIFont(uidFont: .book, size: UIDTableViewHeaderFontSize)
        titleLabel.textColor = theme?.contentItemTertiaryText
        
        var visualStringConstraints = [String]()
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                    constant: UIDTableViewCellConstants.contentLayoutMargins.left),
                titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                     constant: -UIDTableViewCellConstants.contentLayoutMargins.left)
                ])
        } else {
            visualStringConstraints.append("H:|-marginOffset-[titleLabel]-marginOffset-|")
        }
        
        visualStringConstraints.append("V:|[titleLabel]|")
        let bindingViewsInfo: [String:UIView] = ["titleLabel": titleLabel]
        let metrics: [String : Any] = ["marginOffset": UIDTableViewCellConstants.contentLayoutMargins.left]
        addConstraints(visualStringConstraints, metrics: metrics, views: bindingViewsInfo)
    }
    
    func configureTheme() {
        guard let theme = theme else {
            return
        }
        titleLabel.textColor = theme.contentItemTertiaryText
        contentView.backgroundColor = theme.contentSecondaryBackground
    }
    
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: UIDTableViewHeaderHeight)
    }
}
