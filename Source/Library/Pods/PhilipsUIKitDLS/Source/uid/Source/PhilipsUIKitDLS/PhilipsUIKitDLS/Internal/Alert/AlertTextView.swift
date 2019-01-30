/** © Koninklijke Philips N.V., 2016. All rights reserved. */

import UIKit
let messageLineHeight: CGFloat = 22

class AlertTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        instanceInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        instanceInit()
    }
    
    private func instanceInit() {
        textContainerInset = .zero
        isEditable = false
        isSelectable = false
        
        if let paragraphStyle = NSMutableParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle,
            let messageFont = UIFont(uidFont:.book, size: UIDFontSizeMedium) {
            paragraphStyle.lineSpacing = messageLineHeight - UIDFontSizeMedium
            let attributes = [NSAttributedStringKey.font.rawValue : messageFont,
                              NSAttributedStringKey.paragraphStyle.rawValue : paragraphStyle]
            typingAttributes = attributes
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        let padding = textContainer.lineFragmentPadding
        textContainerInset = UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
    }
    
    override var intrinsicContentSize: CGSize {
        if text.isEmpty == false {
            return contentSize
        }
        return .zero
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !bounds.size.equalTo(intrinsicContentSize) {
            invalidateIntrinsicContentSize()
        }
    }
}
