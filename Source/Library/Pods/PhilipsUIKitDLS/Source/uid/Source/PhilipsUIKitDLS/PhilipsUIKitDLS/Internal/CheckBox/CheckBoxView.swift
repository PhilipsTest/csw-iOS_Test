/** © Koninklijke Philips N.V., 2017. All rights reserved. */

import UIKit
import PhilipsIconFontDLS

class CheckBoxView: UIView {
    var theme: UIDTheme? = UIDThemeManager.sharedInstance.defaultTheme
    
    let contentView = UIView.makePreparedForAutoLayout()
    let checkLabel = UILabel.makePreparedForAutoLayout()
    let highlightedThumbLayer = CAShapeLayer()

   @objc override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        instanceInit()
    }
    
    var isChecked: Bool = true {
        didSet {
           configureTheme()
        }
    }
    
    var isEnabled: Bool = true {
        didSet {
            configureTheme()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        instanceInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
   @objc override open func awakeFromNib() {
        super.awakeFromNib()
        instanceInit()
    }
    
    func instanceInit() {
        backgroundColor = UIColor.clear
        setupCheckLabel()
        setupContentView()
        setupHighlightedThumbLayer()
        constrain(toSize: CGSize(width: UIDCheckBoxHeight, height: UIDCheckBoxHeight))
        setContentHuggingPriority(.required, for: .horizontal)
        setContentHuggingPriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    func setupCheckLabel() {
        contentView.addSubview(checkLabel)
        checkLabel.font = UIFont.iconFont(size: UIDFontSizeMedium)
        checkLabel.text = PhilipsDLSIcon.unicode(iconType: .checkMarkXBold32)
        checkLabel.textAlignment = .center
        checkLabel.constrainCenterToParent()
    }
    
    func setupContentView() {
        contentView.cornerRadius = UIDCornerRadius
        addSubview(contentView)
        var visualStringConstraints = [String]()
        let bindingViewsInfo: [String:UIView] = ["contentStackView": contentView]
        visualStringConstraints.append("H:|[contentStackView]|")
        visualStringConstraints.append("V:|[contentStackView]|")
        addConstraints(visualStringConstraints,
                                                  metrics: nil, views: bindingViewsInfo)
    }
    
    private func setupHighlightedThumbLayer() {
        let highLightedThumbDiameter = UIDCheckBoxHeight
        let offsetValue = -(highLightedThumbDiameter) * 0.25
        let highlightedBounds = CGRect(origin: .zero,
                                       size: CGSize(width: highLightedThumbDiameter*2, height: highLightedThumbDiameter*2))
        let highlightedRect = highlightedBounds.offsetBy(dx: offsetValue, dy: offsetValue)
        let path = UIBezierPath(roundedRect: highlightedRect, cornerRadius: UIDCheckBoxHeight)
        highlightedThumbLayer.path = path.cgPath
        highlightedThumbLayer.frame = highlightedRect
        highlightedThumbLayer.opacity = 0.0
        highlightedThumbLayer.strokeColor = UIColor.clear.cgColor
        highlightedThumbLayer.lineWidth = 0
        layer.insertSublayer(highlightedThumbLayer, below: contentView.layer)
    }
    
    func updateState() {
        if let theme = theme {
            if isChecked {
                contentView.backgroundColor = theme.checkBoxDefaultOnBackground
                checkLabel.textColor = theme.checkBoxDefaultOnIcon
            } else {
                contentView.backgroundColor = theme.checkBoxDefaultOffBackground
                checkLabel.textColor = UIColor.clear
            }
            highlightedThumbLayer.fillColor = theme.checkBoxDefaultFocusBorder?.cgColor
        }
    }
    
    func configureTheme() {
        if isEnabled {
            updateState()
        } else {
            contentView.backgroundColor = theme?.checkBoxDefaultDisabledBackground
            checkLabel.textColor = isChecked ? theme?.checkBoxDefaultDisabledIcon : UIColor.clear
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIDCheckBoxHeight, height: UIDCheckBoxHeight)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        highlightedThumbLayer.animateByOpacityToAppear(true)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        highlightedThumbLayer.animateByOpacityToAppear(false)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        highlightedThumbLayer.animateByOpacityToAppear(false)
    }
}
