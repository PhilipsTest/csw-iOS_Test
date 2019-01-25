//  Copyright © 2016 Philips. All rights reserved.

import UIKit

/**
 *  A UIDTextField is the standard text field to use.
 *  In InterfaceBuilder it is possible to create a UITextField and give it the class UIDTextField, the styling will be done
 *  immediately.
 *  Maps to the single line variant of the DLS specification of the TextBox.
 *
 *  - Since: 3.0.0
 */
@IBDesignable
@objcMembers open class UIDTextField: UITextField {
    
    /**
     *  Set the validation message.
     *  - Since: 3.0.0
     */
    @IBInspectable
    open var validationMessage: String = "" {
        didSet {
            if let validationMessageView = validationMessageView {
                validationMessageView.validationMessage = validationMessage
                layoutSubviews()
            }
        }
    }
    
    /**
     *  Set the bottom constraint for validation view.
     *  - Since: 3.0.0
     */
    @IBOutlet public weak var bottomConstraint: NSLayoutConstraint! {
        didSet {
            originalBottomConstant = bottomConstraint.constant
        }
    }
    
    /**
     *  Configure the control's theme.
     *  - Since: 3.0.0
     */
    public var theme: UIDTheme? = UIDThemeManager.sharedInstance.defaultTheme {
        didSet {
            configureTheme()
        }
    }
    
    /**
     * Check any time, validation-view of UIDTextField is visible or not.
     * @note default value is "false"
     *
     * - Since: 3.0.0
     */
    open internal(set) var isValidationVisible: Bool = false {
        didSet {
            configureTheme()
        }
    }
    
    /**
     *  Configure the text field placeholder text.
     *  Refreshes placeholder when set.
     *  - Since: 3.0.0
     */
    open override var placeholder: String? {
        didSet {
            configurePlaceholder()
        }
    }
    
    open override var isEnabled: Bool {
        didSet {
            configureTheme()
        }
    }
    
    open override var isUserInteractionEnabled: Bool {
        didSet {
            isEnabled = isUserInteractionEnabled
        }
    }
    
    /**
     *  Use this to show/hide UIDTextField border.
     *  - Since: 2018.1.0
     */
    @IBInspectable
    open var isBordered: Bool = true {
        didSet {
            if oldValue != isBordered {
                configureTheme()
            }
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        instanceInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        instanceInit()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if let validationMessageView = validationMessageView,
            let validationLabel = validationMessageView.validationMessageLabel,
            let validationIconView = validationMessageView.validationIconView {
            let textFieldWidth = frame.size.width - validationIconView.frame.size.width - 8
            let labelNewHeight = validationLabel.labelHeight(textFieldWidth)
            var labelFrame = validationLabel.frame
            labelFrame.size.width = textFieldWidth
            labelFrame.size.height = labelNewHeight
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.001) {
                validationLabel.frame = labelFrame
            }
            bottomConstraint?.constant = labelNewHeight + originalBottomConstant + UIDFontSizeMedium/2
            superview?.layoutIfNeeded()
        }
        super.layoutSubviews()
    }
    
    var placeholderColor: UIColor? {
        didSet {
            configurePlaceholder()
        }
    }
    
    var validationMessageView: UIDInlineDataValidationView?
    var originalBottomConstant: CGFloat = 0
    
    func instanceInit() {
        clipsToBounds = true
        borderStyle = .none
        cornerRadius = UIDCornerRadius
        configureTheme()
        configurePlaceholder()
        
        addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
    }
    
    func editingDidBegin() {
        configureThemeForFocus()
    }
    
    func editingDidEnd() {
        configureTheme()
    }
    
    func configureTheme() {
        if state.contains(.disabled) {
            backgroundColor = theme?.textBoxDefaultDisabledBackground
            textColor = theme?.textBoxDefaultDisabledText
            borderColor = theme?.textBoxDefaultDisabledBorder
            placeholderColor = theme?.textBoxDefaultDisabledHintText
        } else {
            if isValidationVisible {
                backgroundColor = theme?.textBoxDefaultValidatedBackground
                textColor = theme?.textBoxDefaultValidatedText
                borderColor = theme?.textBoxDefaultValidatedBorder
                placeholderColor = theme?.textBoxDefaultHintText
            } else {
                backgroundColor = theme?.textBoxDefaultBackground
                textColor = theme?.textBoxDefaultText
                borderColor = theme?.textBoxDefaultBorder
                placeholderColor = theme?.textBoxDefaultHintText
            }
        }
        borderWidth = isBordered ? (theme?.textBoxNormalBorderWidth ?? 0) : 0
    }
    
    func configureThemeForFocus() {
        backgroundColor = theme?.textBoxDefaultFocusBackground
        textColor = theme?.textBoxDefaultText
        borderColor = theme?.textBoxDefaultFocusBorder
        borderWidth = isBordered ? (theme?.textBoxNormalBorderWidth ?? 0) : 0
    }
    
    private func configurePlaceholder() {
        font = UIFont(uidFont: .book, size: UIDFontSizeMedium)
        if let placeholder = placeholder, let font = font, let placeholderColor = placeholderColor {
            let attributes = [NSAttributedStringKey.foregroundColor: placeholderColor,
                              NSAttributedStringKey.font: font]
            attributedPlaceholder = NSAttributedString(string: placeholder, attributes:attributes)
        }
    }
    
    func rect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: UIDInsetSize, dy: 0)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.textRect(forBounds: bounds)
        rect = self.rect(forBounds: rect)
        return rect
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.editingRect(forBounds: bounds)
        if LayoutDirection.isRightToLeft {
            rect.origin.x = UIDInsetSize * 2
            rect.size.width -= UIDSize20/2
        } else {
            rect = self.rect(forBounds: rect)
        }
        return rect
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.placeholderRect(forBounds: self.bounds)
        if LayoutDirection.isRightToLeft {
            return rect
        }
        rect.origin.x = UIDInsetSize
        return rect
    }
    
    open override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width, height: UIDControlHeight)
    }
}

extension UIDTextField {
    public func setValidationView(_ visible: Bool) {
        setValidationView(visible, animated: false)
    }
    
    public func setValidationView(_ visible: Bool, animated: Bool) {
        if visible {
            showValidationView(animated)
        } else {
            hideValidationView(animated)
        }
    }
    
    func applyConstraintsToValidationView() {
        if let superview = superview, let validationMessageView = validationMessageView {
            superview.addSubview(validationMessageView)
            var constraints = [NSLayoutConstraint]()
            constraints.append(NSLayoutConstraint(item: validationMessageView, attribute: .leading,
                                                  relatedBy: .equal,
                                                  toItem: self, attribute: .leading, multiplier: 1.0,
                                                  constant: 0.0))
            
            constraints.append(NSLayoutConstraint(item: validationMessageView, attribute: .trailing,
                                                  relatedBy: .equal, toItem: self,
                                                  attribute: .trailing, multiplier: 1.0,
                                                  constant: 0.0))
            
            constraints.append(NSLayoutConstraint(item: validationMessageView, attribute: .top,
                                                  relatedBy: .equal, toItem: self,
                                                  attribute: .bottom, multiplier: 1.0,
                                                  constant: 8.0))
            superview.addConstraints(constraints)
            superview.layoutIfNeeded()
            bottomConstraint?.constant = validationMessageView.frame.size.height + originalBottomConstant
        }
    }
    
    func showValidationView(_ animated: Bool) {
        if validationMessageView == nil {
            validationMessageView = UIDInlineDataValidationView.makePreparedForAutoLayout()
            validationMessageView?.validationMessage = validationMessage
            applyConstraintsToValidationView()
            configureTheme()
            let animationClosure = {
                self.isValidationVisible = true
                self.validationMessageView?.alpha = 1.0
            }
            if animated {
                validationMessageView?.alpha = 0.0
                UIView.animate(withDuration: 0.3,
                               delay: 0.0,
                               options: .curveEaseInOut,
                               animations: animationClosure,
                               completion: nil)
            } else {
                animationClosure()
            }
        }
    }
    
    func hideValidationView(_ animated: Bool) {
        let completionClosure = {
            self.bottomConstraint?.constant = self.originalBottomConstant
            self.validationMessageView?.removeFromSuperview()
            self.validationMessageView = nil
            self.isValidationVisible = false
            self.superview?.layoutIfNeeded()
            (self.isFirstResponder) ? self.configureThemeForFocus(): self.configureTheme()
        }
        if let validationMessageView = validationMessageView {
            if animated {
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                    validationMessageView.alpha = 0.0
                }, completion: { _ in
                    completionClosure()
                })
            } else {
                completionClosure()
            }
        }
    }
}

private extension UILabel {
    func labelHeight(_ width: CGFloat) -> CGFloat {
        var labelHeight: CGFloat = 0
        if let mediumFont = UIFont(uidFont: .medium, size: UIDFontSizeSmall) {
            let labelSize = sizeToFit(CGSize(width: width,
                                             height: CGFloat.greatestFiniteMagnitude),
                                      font: mediumFont)
            labelHeight = labelSize.height
        }
        return labelHeight
    }
}

