//  Copyright © 2016 Philips. All rights reserved.

import UIKit

fileprivate let totalLineSpacing: CGFloat = 26

/**
 *  A UIDTextView is the standard text view to use.
 *  In InterfaceBuilder it is possible to create a UITextView and give it the class UIDTextView, the styling will be done
 *  immediately.
 *  Maps to the multi-line variant of the DLS specification of the TextBox.
 *
 *  - Since: 3.0.0
 */
@IBDesignable
@objcMembers open class UIDTextView: UITextView {
    
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
     *  Use this to show/hide UIDTextView border.
     *  - Since: 3.0.0
     */
    @IBInspectable
    open var isBordered: Bool = true {
        didSet {
            if oldValue != isBordered {
                configureBorder(isFocussed: isFirstResponder)
            }
        }
    }
    
    open override var isEditable: Bool {
        didSet {
            configureTheme()
        }
    }
    
    open override var isUserInteractionEnabled: Bool {
        didSet {
            isEditable = isUserInteractionEnabled
        }
    }
    
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        instanceInit()
    }
    
    convenience public init(frame: CGRect) {
        self.init(frame: frame, textContainer: nil)
        instanceInit()
    }
    
    convenience public init() {
        self.init(frame: CGRect.zero, textContainer: nil)
        instanceInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        isBordered = !(!isBordered)
        instanceInit()
    }
    
    func instanceInit() {
        layoutManager.delegate = self
        clipsToBounds = true
        cornerRadius = UIDCornerRadius
        configureTheme()
        textContainer.lineFragmentPadding = 0
        textContainerInset =  UIEdgeInsets(top: UIDInsetSize,
                                           left: UIDInsetSize,
                                           bottom: UIDInsetSize,
                                           right: UIDInsetSize)
        font = UIFont(uidFont: .book, size: UIDFontSizeMedium)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(editingDidBegin(note:)),
                                               name: .UITextViewTextDidBeginEditing,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(editingDidEnd(note:)),
                                               name: .UITextViewTextDidEndEditing,
                                               object: nil)
    }
    
     func editingDidBegin(note: Notification) {
        if let textView = note.object as? UIDTextView, textView == self {
            configureThemeForFocus()
        }
    }
    
     func editingDidEnd(note: Notification) {
        if let textView = note.object as? UIDTextView, textView == self {
            configureTheme()
        }
    }
    
    private func configureTheme() {
        if isEditable {
            backgroundColor = theme?.textBoxDefaultBackground
            textColor = theme?.textBoxDefaultText
        } else {
            backgroundColor = theme?.textBoxDefaultDisabledBackground
            textColor = theme?.textBoxDefaultDisabledText
        }
        configureBorder(isFocussed: isFirstResponder)
    }
    
    private func configureThemeForFocus() {
        backgroundColor = theme?.textBoxDefaultFocusBackground
        configureBorder(isFocussed: isFirstResponder)
    }
    
    func configureBorder(isFocussed: Bool) {
        borderWidth = 0
        if isBordered {
            if isFocussed {
                borderColor = theme?.textBoxDefaultFocusBorder
                borderWidth = theme?.textBoxFocusBorderWidth ?? 0
            } else {
                borderColor = isEditable ? theme?.textBoxDefaultBorder : theme?.textBoxDefaultDisabledBorder
                borderWidth = theme?.textBoxNormalBorderWidth ?? 0
            }
        }
    }
}

extension UIDTextView : NSLayoutManagerDelegate {
    
    /// Handling line in multi-line text views:
    /// Under each line, except for the last line, make sure that the total space between baselines equals 26 pt
    /// Under the last line, line space is 0
    ///
    /// - parameter layoutManager:                TextView's layoutManager, used to determine whether we are determining
    ///                                           line spacing of the last line or not.
    /// - parameter lineSpacingAfterGlyphAt:      Method will be called for the last glyph
    ///                                           before each line break (hard break or word wrap).
    /// - parameter withProposedLineFragmentRect: Not used in the delegate: proposed rect for the line fragment.
    ///
    /// - returns: 0 for the last line, 26 - point size of the font otherwise
    /// - Since: 3.0.0
  @objc public func layoutManager(_ layoutManager: NSLayoutManager,
                              lineSpacingAfterGlyphAt glyphIndex: Int,
                              withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        if let font = font, glyphIndex + 1 < layoutManager.numberOfGlyphs {
            return totalLineSpacing - font.pointSize
        }
        return 0
    }
}
