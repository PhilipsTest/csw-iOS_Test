/** © Koninklijke Philips N.V., 2017. All rights reserved. */

import UIKit

/// - Since: 3.0.0
@objc
public enum UIDTableViewCellType: Int {
    /// Title with optional icon image
    /// - Since: 3.0.0
    case titleOnly
    
    /// Title with description
    /// - Since: 3.0.0
    case titleWithDescription
}

/// - Since: 3.0.0
@objcMembers open
class UIDTableViewCell: UITableViewCell {
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
    
    /// Label for the title
    /// - Since: 3.0.0
    open let titleLabel = UILabel.makePreparedForAutoLayout()
    
    /// Use IconImageView to set icon for the tile.
    /// - Since: 3.0.0
    open let iconImageView = UIImageView.makePreparedForAutoLayout()
    
    /// Description text. Default is nil
    /// - Since: 3.0.0
    open let descriptionLabel = UILabel.makePreparedForAutoLayout()
    
    /// Separator for the cell.
    let separatorView = UIDSeparator.makePreparedForAutoLayout()
    
    /// Type of the cell.
    /// - Since: 3.0.0
    open var cellType: UIDTableViewCellType = .titleOnly {
        didSet {
            configureLayoutBasedOnCellType()
        }
    }
    
    /// Hides or unhides separator. Default is true
    /// - Since: 3.0.0
    open var showSeparator = true {
        didSet {
            separatorView.isHidden = !showSeparator
        }
    }
    
    private let textStackView = UIStackView.makePreparedForAutoLayout()
    
    private var heightConstraint: NSLayoutConstraint!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        instanceInit()
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        instanceInit()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        instanceInit()
    }
    
    private func instanceInit() {
        configureDefaultProperties()
        configureContentView()
        configureLayoutBasedOnCellType()
        configureTheme()
    }
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        styleCell(for: selected)
    }
    
    override open func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        styleCell(for: highlighted)
    }
    
    func styleCell(for selected: Bool) {
        guard let theme = theme else {
            return
        }
        if selected == true {
            contentView.backgroundColor = theme.listItemDefaultOnBackground
            titleLabel.textColor = cellType == .titleOnly ? theme.listItemDefaultOnText : theme.contentItemPrimaryText
            descriptionLabel.textColor = theme.contentItemSecondaryText
            iconImageView.tintColor = cellType == .titleOnly ?
                theme.listItemDefaultOnIcon :
                theme.contentItemSecondaryText
        } else {
            contentView.backgroundColor = UIColor.clear
            titleLabel.textColor = cellType == .titleOnly ? theme.listItemDefaultOffText : theme.contentItemPrimaryText
            descriptionLabel.textColor = theme.contentItemSecondaryText
            iconImageView.tintColor = cellType == .titleOnly ?
                theme.listItemDefaultOffIcon :
                theme.contentItemSecondaryText
        }
        separatorView.theme = theme
    }
    
    func configureDefaultProperties() {
        separatorInset = .zero
        selectionStyle = .none
        
        if responds(to: #selector(setter: layoutMargins)) {
            layoutMargins = .zero
        }
        
        if responds(to: #selector(setter: preservesSuperviewLayoutMargins)) {
            preservesSuperviewLayoutMargins = false
        }
        
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
    }
    
    func configureContentView() {
        heightConstraint = NSLayoutConstraint(item: self, attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil, attribute: .notAnAttribute,
                                              multiplier: 0, constant: 48)
        NSLayoutConstraint.activate([heightConstraint])
        
        configureTextStackView()
        configureSeparatorView()
    }
    
    func configureSeparatorView() {
        addSubview(separatorView)
        separatorView.constrain(toHeight: 1, multiplier: 0)
        var visualStringConstraints = [String]()
        visualStringConstraints.append("H:|[separatorView]|")
        visualStringConstraints.append("V:[separatorView]|")
        let bindingViewsInfo: [String:UIView] = ["separatorView": separatorView]
        addConstraints(visualStringConstraints, metrics: nil, views: bindingViewsInfo)
    }
    
    func configureTextStackView() {
        addSubview(textStackView)
        
        let titleStackView = configureTitleStackView()
        textStackView.addArrangedSubview(titleStackView)
        textStackView.addArrangedSubview(descriptionLabel)
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        textStackView.spacing = 8
        textStackView.axis = .vertical
        textStackView.constrainVerticallyCenteredToParent()
        
        var visualStringConstraints = [String]()
        let metrics: [String : Any] = ["paddingX": UIDTableViewCellConstants.contentLayoutMargins.left]
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                textStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                       constant: UIDTableViewCellConstants.contentLayoutMargins.left),
                textStackView.trailingAnchor.constraintGreaterThanOrEqualToSystemSpacingAfter(safeAreaLayoutGuide.trailingAnchor,
                                                                                              multiplier: -UIDTableViewCellConstants.contentLayoutMargins.left)
                ])
        } else {
            visualStringConstraints.append("H:|-(paddingX)-[textStackView]-(>=paddingX)-|")
        }
        let bindingViewsInfo: [String:UIView] = ["textStackView": textStackView]
        addConstraints(visualStringConstraints, metrics: metrics, views: bindingViewsInfo)
    }
    
    func configureTitleStackView() -> UIStackView {
        configureTitleImageView()
        let titleStackView = UIStackView.makePreparedForAutoLayout()
        titleStackView.addArrangedSubview(iconImageView)
        iconImageView.contentMode = .scaleAspectFit
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.spacing = UIDTableViewCellConstants.TitleOnly.titleIconSpacing
        return titleStackView
    }
    
    func configureTitleImageView() {
        let width = UIDTableViewCellConstants.TitleOnly.iconSize
        iconImageView.addConstraints([
            NSLayoutConstraint(item: iconImageView, attribute: .height,
                               relatedBy: .equal, toItem: nil,
                               attribute: .notAnAttribute, multiplier: 0, constant: width),
            NSLayoutConstraint(item: iconImageView, attribute: .width,
                               relatedBy: .equal, toItem: nil,
                               attribute: .notAnAttribute, multiplier: 0, constant: width)])
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if cellType == .titleOnly {
            let showImage = (iconImageView.image != nil)
            iconImageView.isHidden = (showImage ? false :true)
        }
    }
    
    func configureLayoutBasedOnCellType() {
        if cellType == .titleOnly {
            let fontType = UIDTableViewCellConstants.TitleOnly.fontType
            let fontSize = UIDTableViewCellConstants.TitleOnly.fontSize
            titleLabel.font = UIFont (uidFont: fontType, size: fontSize)
            descriptionLabel.isHidden = true
            iconImageView.isHidden = false
            heightConstraint.constant = UIDTableViewCellConstants.TitleOnly.height
        } else {
            let titleFontType = UIDTableViewCellConstants.TitleWithDescription.titleFontType
            let titleFontSize = UIDTableViewCellConstants.TitleWithDescription.titleFontSize
            titleLabel.font = UIFont (uidFont: titleFontType, size: titleFontSize)
            
            let descFontType = UIDTableViewCellConstants.TitleWithDescription.descriptionFontType
            let descFontSize = UIDTableViewCellConstants.TitleWithDescription.descriptionFontSize
            descriptionLabel.font = UIFont (uidFont: descFontType, size: descFontSize)
            descriptionLabel.isHidden = false
            iconImageView.isHidden = true
            descriptionLabel.numberOfLines = 1
            heightConstraint.constant = UIDTableViewCellConstants.TitleWithDescription.height
        }
    }
    
    func configureTheme() {
        styleCell(for: false)
    }
}
