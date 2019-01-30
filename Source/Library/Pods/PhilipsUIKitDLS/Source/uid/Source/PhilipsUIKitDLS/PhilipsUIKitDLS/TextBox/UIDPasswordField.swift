/** © Koninklijke Philips N.V., 2016. All rights reserved. */

import PhilipsIconFontDLS

fileprivate let UIDPasswordFieldPadding: CGFloat = 8

/**
    A **UIDPasswordField** is the standard password field to use.
 
    - Important:
    In InterfaceBuilder it is possible to create a UITextField and give it the class UIDPasswordField,
    the styling will be done immediately.
    Maps to the single line variant of the DLS specification of the TextBox.
 
     - Since: 3.0.0
 */
@objcMembers open class UIDPasswordField: UIDTextField {
    
    open override var isSecureTextEntry: Bool {
        didSet {
            configurePasswordField()
        }
    }
    
    override func instanceInit() {
        super.instanceInit()
        self.addShowHideButton()
        self.isSecureTextEntry = true
    }
    
    override func configureTheme() {
        super.configureTheme()
        self.rightView?.isHidden = state.contains(.disabled)
    }
    
    override func editingDidEnd() {
        self.isSecureTextEntry = true
        self.configureTheme()
    }
    
    override func rect(forBounds bounds: CGRect) -> CGRect {
        var rect = bounds
        if !LayoutDirection.isRightToLeft {
            rect.origin.x = UIDInsetSize
            rect.size.width -= UIDPasswordFieldPadding
            return rect
        }
        return super.rect(forBounds: bounds)
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.editingRect(forBounds: bounds)
        if LayoutDirection.isRightToLeft {
            rect.origin.x = UIDSize20 * 2
            rect.size.width += UIDInsetSize/2
            return rect
        }
        return rect
    }

    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return ((action == #selector(paste(_:))) || (action == #selector(resignFirstResponder)))
    }
    
    private func addShowHideButton() {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.clear
        button.frame = CGRect(x: 0, y: 0, width: UIDIconSize * 2, height: UIDIconSize * 2)
        button.titleLabel?.font = UIFont.iconFont(size: UIDIconSize)
        button.setTitle(PhilipsDLSIcon.unicode(iconType: .passwordHide), for: .normal)
        button.setTitleColor(theme?.textBoxDefaultShowHideIcon, for: .normal)
        button.setTitleColor(theme?.textBoxDefaultShowHideIcon, for: .highlighted)
        button.addTarget(self, action: #selector(showHideButtonTapped), for: .touchUpInside)
        self.rightView = button
        self.rightViewMode = .always
    }
    
    func showHideButtonTapped(sender: UIButton) {
        self.isSecureTextEntry = !self.isSecureTextEntry
        self.becomeFirstResponder()
    }
    
    private func configurePasswordField() {
        if let button = self.rightView as? UIButton {
            if self.isSecureTextEntry {
                button.setTitle(PhilipsDLSIcon.unicode(iconType: .passwordHide), for: .normal)
            } else {
                button.setTitle(PhilipsDLSIcon.unicode(iconType: .passwordShow), for: .normal)
                if let text = self.text {
                    self.attributedText = NSAttributedString(string: text)
                }
            }
        }
    }
}
