/** © Koninklijke Philips N.V., 2017. All rights reserved. */

let UIDCheckBoxIconLabelSpacing: CGFloat = 12.0

import UIKit

/// - Since: 3.0.0
@IBDesignable
@objcMembers open class UIDCheckBox: UIControl {
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
    
    /**
     *  Set to true if is 'on'.
     *  - Since: 3.0.0
     */
    @IBInspectable
   @objc open var isChecked: Bool = true {
        didSet {
            updateState(toOn: isChecked)
        }
    }
    
    /**
     *  Set to true if it is 'multiline'.
     *  - Since: 3.0.0
     */
    @IBInspectable
   @objc open var isMultiline: Bool = false {
        didSet {
            contentStackView.alignment = .leading
        }
    }
    
    /**
     * Configure the title of CheckBox.
     *
     * - Since: 3.0.0
     */
    @IBInspectable
   @objc open var title: String? {
        didSet {
            configureTitleText()
        }
    }
    
    @IBInspectable
    open override var isEnabled: Bool {
        didSet {
            checkBoxView.isEnabled = isEnabled
            titleLabel.labelType = (isEnabled == true) ? .value : .disabled
            configureTheme()
        }
    }
    
    ///Invoked by setValue(_:forKey:) when it finds no property for a given key. In this case 'isEnabled'
   @objc override open func setValue(_ value: Any?, forUndefinedKey key: String) {
        if let value = value as? Bool, key == "isEnabled" {
            self.isEnabled = value
            return
        }
        super.setValue(value, forUndefinedKey: key)
    }
    
    let contentStackView = UIStackView.makePreparedForAutoLayout()
    let checkBoxView = CheckBoxView.makePreparedForAutoLayout()
    let titleLabel = UIDLabel.makePreparedForAutoLayout()
    
    private let tapGestureRecognizer = UITapGestureRecognizer()
    
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
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.clear
        setupTitleLabel()
        setupContentStackView()
        setupGesture()
        configureTheme()
    }
    
    func setupTitleLabel() {
        titleLabel.numberOfLines = 0
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.labelType = .value
        titleLabel.fontType = .book
        configureTitleText()
    }
    
    func configureTitleText() {
        guard let title = title else {
            titleLabel.isHidden = true
            return
        }
        titleLabel.isHidden = title.count == 0
        titleLabel.text(title, lineSpacing: UIDLineSpacing)
    }
    
    func setupContentStackView() {
        contentStackView.alignment = isMultiline ? .leading : .fill
        addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(checkBoxView)
        contentStackView.addArrangedSubview(titleLabel)
        
        contentStackView.spacing = UIDCheckBoxIconLabelSpacing
        setUpContentStackViewConstraints()
    }
    
    private func setUpContentStackViewConstraints() {
        var visualStringConstraints = [String]()
        let bindingViewsInfo: [String:UIView] = ["contentStackView": contentStackView]
        
        visualStringConstraints.append("H:|[contentStackView]|")
        visualStringConstraints.append("V:|[contentStackView]|")
        addConstraints(visualStringConstraints,
                       metrics: nil, views: bindingViewsInfo)
    }
    
    func updateState(toOn: Bool) {
        checkBoxView.isChecked = toOn
    }
    
    private func configureTheme() {
        checkBoxView.configureTheme()
        titleLabel.theme = theme
     }
    
    open override var intrinsicContentSize: CGSize {
        if isMultiline {
            return CGSize(width: super.intrinsicContentSize.width, height: super.intrinsicContentSize.height)
        }
        return CGSize(width: super.intrinsicContentSize.width, height: UIDCheckBoxHeight)
    }
        
    private func setupGesture() {
        addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.addTarget(self, action: #selector(tappedOnContentArea(tap:)))
    }
    
    func tappedOnContentArea(tap: UITapGestureRecognizer) {
        switch tap.state {
        case .began:
            checkBoxView.highlightedThumbLayer.animateByOpacityToAppear(true)
        default:
            checkBoxView.highlightedThumbLayer.animateByOpacityToAppear(false)
        }
        
        isChecked = !isChecked
        sendActions(for: [.valueChanged, .touchUpInside])
    }
}
