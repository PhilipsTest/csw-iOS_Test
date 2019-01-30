/* Copyright (c) Koninklijke Philips Electronics N.V. 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

private let minimumRadioButtonSize: CGFloat = 48

/**
 *  UIDRadioButtonDelegate is a protocol for radio button.
 *  This protocal responsible to send event on radio button pressed.
 *
 *  - Since: 3.0.0
 */
@objc
public protocol UIDRadioButtonDelegate: NSObjectProtocol {
    /// Responsible to send event on radio button pressed.
    /// - Since: 3.0.0
    @objc
    optional func radioButtonPressed(_ radioButton: UIDRadioButton)
}

/**
 *  A UIDRadioButton is the standard Radio button to use.
 *  In InterfaceBuilder it is possible to create a UIButton and give it the class UIDRadioButton, the styling will be done
 *  immediately.
 *
 *  @note UIDRadioButton must have type 'custom' in order to work properly.
 *
 *  - Since: 3.0.0
 */
@objcMembers public class UIDRadioButton: UIButton {
    /**
     * The UIDTheme of the button.
     * Updates the Radio-button styling when set.
     *
     * Defaults to UIDThemeManager.sharedInstance.defaultTheme
     *
     * - Since: 3.0.0
     */
    public var theme: UIDTheme? = UIDThemeManager.sharedInstance.defaultTheme {
        didSet {
            configureTheme()
        }
    }
    
    /**
     * Call this API to select/un-select Radio-button.
     *
     * - Since: 3.0.0
     */
    public override var isSelected: Bool {
        get {
            return radioButtonView.isSelected
        }
        set(newValue) {
            radioButtonView.isSelected = newValue
            configureTheme()
        }
    }
    
    /**
     * Call this API to enable/disable Radio-button.
     *
     * - Since: 3.0.0
     */
    public override var isEnabled: Bool {
        get {
            return radioButtonView.isEnabled
        }
        set(newValue) {
            radioButtonView.isEnabled = newValue
            configureTheme()
        }
    }
    
    /**
     * Set Delegate to  get UIDRadioButtonDelegate notification.
     *
     * Default is nil. weak reference
     *
     * - Since: 3.0.0
     */
    weak public var delegate: UIDRadioButtonDelegate?
    
    /// RadionButtonView is just Group of Views which will looks like Radio-Button.
    let radioButtonView = RadioButtonView.makePreparedForAutoLayout()
    
    /**
     * Custom Init with Delegate.
     *
     * - Since: 3.0.0
     */
    public init(delegate: UIDRadioButtonDelegate) {
        super.init(frame: .zero)
        instanceInit()
        self.delegate = delegate
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
    
    public override func setTitle(_ title: String, for state: UIControlState = .normal, lineSpacing: CGFloat) {
        super.setTitle(title, lineSpacing: lineSpacing)
        configureTheme()
    }
}

extension UIDRadioButton {
    func instanceInit() {
        assert(buttonType == .custom, "UIDRadioButton must have type 'custom' in order to work properly.")
        backgroundColor = UIColor.clear
        configureRadioButtonView()
        configureTheme()
    }
    
    func configureRadioButtonView() {
        (radioButtonView.isEnabled, radioButtonView.isSelected) = (super.isEnabled, super.isSelected)
        radioButtonView.parent = self
        addSubview(radioButtonView)
        let views = ["radioButtonView": radioButtonView]
        let constraints = ["H:|[radioButtonView]|", "V:|[radioButtonView]|"]
        addConstraints(constraints, metrics: nil, views: views)
    }
    
    func configureTheme() {
        theme.ifNotNil {
            radioButtonView.configureTheme()
            guard let titleColor = isEnabled ? $0.labelRegularText : $0.labelRegularDisabledText,
                let attributedString = attributedTitle(for: .normal) else { return }
            let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
            let range = NSRange(location: 0, length: mutableAttributedString.string.count)
            mutableAttributedString.addAttribute(.foregroundColor, value: titleColor, range: range)
            mutableAttributedString.addAttribute(.font,
                                                 value: UIFont(uidFont:.book, size: UIDFontSizeMedium)!, range: range)
            radioButtonView.titleLabel.attributedText = mutableAttributedString
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.isHidden = true
    }
}

extension UIDRadioButton {
    var originX: CGFloat {
        return radioButtonView.outerCircle.frame.width + UIDInsetSize
    }
    
    var originY: CGFloat {
        return radioButtonView.outerCircle.frame.origin.y
    }
}

extension NSAttributedString {
    var font: UIFont? {
        var stringFont: UIFont?
        let range = NSRange(location: 0, length: string.count)
        enumerateAttribute(.font, in: range,
                           options: [.longestEffectiveRangeNotRequired],
                           using: { (value, _, isStop) in
                            if let value = value as? UIFont {
                                stringFont = value
                                isStop.pointee = true
                            }
        })
        return stringFont
    }
}
