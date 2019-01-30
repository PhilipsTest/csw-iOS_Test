/* Copyright (c) Koninklijke Philips N.V., 2018
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsIconFontDLS

/**
 *  UIDExpanderDelegate is a protocol for DLS Expander.
 *  This protocol is responsible for giving the callbacks in DLS Expander.
 *
 *  - Since: 1805.0.0
 */

@objc
public protocol UIDExpanderDelegate: NSObjectProtocol {
    /// This method will call when the expander is about to expand
    /// - Since: 1805.0.0
    @objc optional func expanderPanelWillExpand(in expander: UIDExpander)
    /// This method will call when the expander finished expanding
    /// - Since: 1805.0.0
    @objc optional func expanderPanelDidExpand(in expander: UIDExpander)
    /// This method will call when the expander is about to collapse
    /// - Since: 1805.0.0
    @objc optional func expanderPanelWillCollapse(in expander: UIDExpander)
    /// This method will call when the expander finished collapsing
    /// - Since: 1805.0.0
    @objc optional func expanderPanelDidCollapse(in expander: UIDExpander)
}

/**
 *  An UIDExpander displays the DLS expander to user. It comes with a pre-bundled template of displaying
 *  two icons to the left and right and a title at the middle of the expander.
 *  This whole section can be customized according to user needs. Upon expansion, a custom view can be show to the user.
 *  The expand/collapse operation is taken care by the Expander through an API and also user click.
 *  In InterfaceBuilder it is possible to create a UIView and give it the class UIDExpander, the
 *  styling will be done immediately.
 *
 * - Since: 1805.0.0
 */
@IBDesignable
@objcMembers open class UIDExpander: UIView {
    
    /**
     * Use this variable to expand/collapse the Expander.
     * Also, use this variable to get the current staus of the Expander(expanded/collapsed).
     *
     * **Please note:** If the **expanderContentView** is not set this API has no effect.
     * Defaults to false
     *
     * - Since: 1805.0.0
     */
    @IBInspectable
    open var isExpanded: Bool = false {
        didSet {
            isExpanded ? expand() : collapse()
        }
    }
    
    /**
     * Use this variable to set the visibility of the Expander's separator.
     *
     * Defaults to true
     *
     * - Since: 1805.0.0
     */
    @IBInspectable
    open var isSeparatorVisible: Bool = true {
        didSet {
            expanderSeparator.isHidden = !isSeparatorVisible
        }
    }
    
    /**
     * Use this variable to set the Expander's title.
     *
     * Defaults to blank
     *
     * - Since: 1805.0.0
     */
    @IBInspectable
    open var expanderTitle: String? {
        didSet {
            expanderTitleLabel.text = expanderTitle
            configureTitleLabelVisibility()
        }
    }
    
    /**
     * The UIDTheme of the Expander.
     * Updates the Expander styling when set.
     *
     * Defaults to UIDThemeManager.sharedInstance.defaultTheme
     *
     * - Since: 1805.0.0
     */
    open var theme: UIDTheme? = UIDThemeManager.sharedInstance.defaultTheme {
        didSet {
            configureTheme()
        }
    }
    
    /**
     * Use this variable to set the delegate for Expander.
     *
     * Defaults to nil.
     *
     * - Since: 1805.0.0
     */
    open weak var expanderDelegate: UIDExpanderDelegate?
    
    /**
     * Use this variable to set a custom header panel to the Expander.
     *
     * **Please note:** Setting this will remove all default Expander Header Panel
     *  components and their functionalities.
     * Then, the click action of the Expander should also be handled by the custom view.
     *
     * - Since: 1805.0.0
     */
    open var expanderCustomPanelView: UIView? {
        didSet {
            configureCustomExpanderPanel()
        }
    }
    
    /**
     * Use this variable to set the custom content area of the Expander.
     *
     * This is the view which will display when the Expander is expanded.
     *
     * **Please note:** This value should be set in order to do the expand operation.
     *
     * - Since: 1805.0.0
     */
    open var expanderContentView: UIView? {
        didSet {
            containerView = expanderContentView
        }
    }
    
    /**
     * Use this variable to set the Expander's left icon.
     *
     * Defaults to nil
     *
     * - Since: 1805.0.0
     */
    open var expanderPanelIcon: PhilipsDLSIconType? {
        didSet {
            configureExpanderHeaderIcon()
            configureExpanderHeaderIconVisibility()
        }
    }
    
    /**
     * Use this variable to set the Expander's attributed title.
     *
     * - Since: 1805.0.0
     */
    open var expanderAttributedTitle: NSAttributedString? {
        didSet {
            expanderTitleLabel.attributedText = expanderAttributedTitle
            configureTitleLabelVisibility()
        }
    }
    
    /**
     * Use this variable to customize the Expander's title label.
     *
     * - Since: 1805.0.0
     */
    open var expanderTitleLabel: UIDLabel = UIDLabel.makePreparedForAutoLayout()
    
    var containerView: UIView?
    var expanderTitleLeadingWithContainer: NSLayoutConstraint?
    var expanderTitleLeadingWithPanelIcon: NSLayoutConstraint?
    
    var expanderPanelView = UIDView.makePreparedForAutoLayout()
    var expanderStackView = UIStackView.makePreparedForAutoLayout()
    var expanderMainStackView = UIStackView.makePreparedForAutoLayout()
    var chevronIconLabel = UIDLabel.makePreparedForAutoLayout()
    var expanderPanelIconLabel = UIDLabel.makePreparedForAutoLayout()
    var expanderSeparator = UIDSeparator.makePreparedForAutoLayout()
    var expanderButton = UIButton.makePreparedForAutoLayout()
    
    override init(frame: CGRect) {
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
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: UIDSize48)
    }
}

// MARK: Helper methods

extension UIDExpander {
    
    @objc func expanderButtonClicked() {
        if containerView != nil {
            isExpanded = !(expanderStackView.arrangedSubviews.count == 2)
        }
    }
    
    private func instanceInit() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        configureExpander()
        configureTheme()
    }
    
    private func configureTheme() {
        expanderPanelIconLabel.textColor = theme?.contentItemSecondaryIcon
        expanderTitleLabel.textColor = theme?.contentItemPrimaryText
        chevronIconLabel.textColor = theme?.contentItemSecondaryIcon
        expanderSeparator.theme = theme
    }
    
    private func configureSeparator() {
        expanderSeparator.heightAnchor.constraint(equalToConstant: UIDSeparatorHeight).isActive = true
    }
    
    private func configureExpanderMainStackView() {
        expanderMainStackView.axis = .vertical
        expanderMainStackView.constrainToSuperviewAccordingToLanguage()
    }
    
    private func configureExpanderStackView() {
        expanderStackView.axis = .vertical
        expanderStackView.isLayoutMarginsRelativeArrangement = true
        expanderStackView.layoutMargins = UIEdgeInsets(top: UIDSize12,
                                                       left: UIDSize16,
                                                       bottom: UIDSize12,
                                                       right: UIDSize16)
        expanderStackView.spacing = UIDSize12
    }
    
    private func configureExpanderPanelView() {
        expanderPanelView.backgroundColor = .clear
        expanderPanelView.heightAnchor.constraint(greaterThanOrEqualToConstant: UIDSize24).isActive = true
    }
    
    private func configureExpanderPanelTitleLabel() {
        expanderTitleLabel.text = expanderTitle
        expanderTitleLabel.numberOfLines = 3
        expanderTitleLabel.font = UIFont(uidFont: .medium, size: UIDSize16)
        expanderTitleLabel.lineBreakMode = .byWordWrapping
        expanderTitleLabel.backgroundColor = .clear
        
        expanderTitleLeadingWithContainer = expanderTitleLabel.leadingAnchor.constraint(equalTo:
            expanderPanelView.leadingAnchor)
        expanderTitleLeadingWithPanelIcon = expanderTitleLabel.leadingAnchor.constraint(equalTo:
            expanderPanelIconLabel.trailingAnchor, constant: UIDSize12)
        
        expanderTitleLabel.setContentHuggingPriority(.required, for: .vertical)
        expanderTitleLeadingWithContainer?.isActive = expanderPanelIcon == nil
        expanderTitleLeadingWithPanelIcon?.isActive = expanderPanelIcon != nil
        expanderTitleLabel.constrainToSuperviewTop()
        expanderTitleLabel.constrainToSuperviewBottom()
        configureTitleLabelVisibility()
    }
    
    private func configureTitleLabelVisibility() {
        expanderTitleLabel.isHidden = (expanderTitleLabel.text == nil || expanderTitleLabel.text?.count == 0)
    }
    
    private func configureExpanderHeaderIcon() {
        if let expanderPanelIcon = expanderPanelIcon {
            expanderPanelIconLabel.font = UIFont.iconFont(size: UIDSize24)
            expanderPanelIconLabel.text = PhilipsDLSIcon.unicode(iconType: expanderPanelIcon)
        }
    }
    
    private func configureExpanderHeaderIconVisibility() {
        let isExpanderIconVisible = expanderPanelIcon != nil
        expanderPanelIconLabel.isHidden = !isExpanderIconVisible
        expanderTitleLeadingWithContainer?.isActive = !isExpanderIconVisible
        expanderTitleLeadingWithPanelIcon?.isActive = isExpanderIconVisible
    }
    
    private func configureExpanderIcon() {
        configureExpanderHeaderIcon()
        expanderPanelIconLabel.textAlignment = .center
        expanderPanelIconLabel.backgroundColor = .clear
        
        expanderPanelIconLabel.widthAnchor.constraint(equalToConstant: UIDSize24).isActive = true
        expanderPanelIconLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        expanderPanelIconLabel.constrainToSuperviewLeading(to: UIDSize0)
        expanderPanelIconLabel.constrainToSuperviewTop()
        configureExpanderHeaderIconVisibility()
    }
    
    private func configureChevronIcon() {
        chevronIconLabel.font = UIFont.iconFont(size: UIDSize24)
        chevronIconLabel.text = PhilipsDLSIcon.unicode(iconType: .navigationDown)
        chevronIconLabel.textAlignment = .center
        chevronIconLabel.backgroundColor = .clear
        
        chevronIconLabel.widthAnchor.constraint(equalToConstant: UIDSize24).isActive = true
        chevronIconLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        chevronIconLabel.constrainToSuperviewTrailing(to: UIDSize0)
        chevronIconLabel.constrainToSuperviewTop()
        chevronIconLabel.leadingAnchor.constraint(equalTo: expanderTitleLabel.trailingAnchor,
                                                  constant: UIDSize12).isActive = true
    }
    
    private func configureExpanderClickAction() {
        expanderButton.backgroundColor = .clear
        expanderButton.addTarget(self, action: #selector(expanderButtonClicked), for: .touchUpInside)
        
        expanderButton.constrainToSuperviewTop()
        expanderButton.constrainToSuperviewLeading(to: UIDSize0)
        expanderButton.constrainToSuperviewTrailing(to: UIDSize0)
        expanderButton.bottomAnchor.constraint(equalTo: expanderPanelView.bottomAnchor,
                                               constant: expanderStackView.layoutMargins.bottom).isActive = true
    }
    
    private func addAllExpanderComponents() {
        addSubview(expanderMainStackView)
        expanderMainStackView.addArrangedSubviews([expanderStackView, expanderSeparator])
        expanderStackView.addArrangedSubview(expanderPanelView)
        expanderPanelView.addSubview(expanderPanelIconLabel)
        expanderPanelView.addSubview(expanderTitleLabel)
        expanderPanelView.addSubview(chevronIconLabel)
        addSubview(expanderButton)
    }
    
    private func configureExpander() {
        addAllExpanderComponents()
        configureExpanderMainStackView()
        configureSeparator()
        configureExpanderStackView()
        configureExpanderPanelView()
        configureExpanderPanelTitleLabel()
        configureExpanderIcon()
        configureChevronIcon()
        configureExpanderClickAction()
    }
    
    private func configureCustomExpanderPanel() {
        if let expanderCustomPanelView = expanderCustomPanelView {
            expanderStackView.removeArrangedSubview(expanderPanelView)
            expanderPanelView.removeAllSubviews()
            expanderPanelView.removeFromSuperview()
            expanderStackView.insertArrangedSubview(expanderCustomPanelView, at: 0)
        }
    }
    
    private func expand() {
        if let containerView = containerView {
            expanderDelegate?.expanderPanelWillExpand?(in: self)
            removeOldViewIfNeeded(withCallBack: false)
            expanderStackView.addArrangedSubview(containerView)
            chevronIconLabel.text = PhilipsDLSIcon.unicode(iconType: .navigationUp)
            expanderDelegate?.expanderPanelDidExpand?(in: self)
            expanderStackView.layoutMargins.bottom = UIDSize16
        }
    }
    
    @discardableResult
    private func removeOldViewIfNeeded(withCallBack callBack: Bool) -> Bool {
        if expanderStackView.arrangedSubviews.count == 2,
            let containerView = expanderStackView.arrangedSubviews.last {
            callBack ? expanderDelegate?.expanderPanelWillCollapse?(in: self) : ()
            expanderStackView.removeArrangedSubview(containerView)
            containerView.removeFromSuperview()
            return true
        }
        return false
    }
    
    private func collapse() {
        if removeOldViewIfNeeded(withCallBack: true) {
            chevronIconLabel.text = PhilipsDLSIcon.unicode(iconType: .navigationDown)
            expanderDelegate?.expanderPanelDidCollapse?(in: self)
            expanderStackView.layoutMargins.bottom = UIDSize12
        }
    }
}
