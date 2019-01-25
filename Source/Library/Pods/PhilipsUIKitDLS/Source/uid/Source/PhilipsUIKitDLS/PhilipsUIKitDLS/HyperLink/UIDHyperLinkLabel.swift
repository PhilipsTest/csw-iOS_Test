/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

/**
 * The model whose values have to be set to configure the Hyperlink.
 *
 * - Since: 3.0.0
 */

@objcMembers public class UIDHyperLinkModel: NSObject {
    /// This is the range of the label text which will be turned into a Hyperlink.
    /// **By default it's the full length of the label text.**
    /// - Since: 3.0.0
    public var highlightRange: NSRange?
    fileprivate var highlightHandler: ((NSRange) -> Void)!
    /// This is a boolean which will decide whether the HyperLink is Underlined or not.
    /// **By default the Hyperlink will be Underlined.**
    /// - Since: 3.0.0
    public var isUnderlined: Bool = true
    /// This is a boolean which will decide whether the HyperLink is Visited or not.
    /// If you want to load a Hyperlink in Visited state set this value to true
    /// **By default the Hyperlink will be in not Visited state.**
    /// - Since: 3.0.0
    public var isVisited: Bool = false
    /// This will the Hyperlink color. If you want to set some different color to the Hyperlink set this value.
    /// - Since: 3.0.0
    public var normalLinkColor: UIColor?
    /// This will the Hyperlink Highlighted color.
    /// If you want to set some different **highlighted** color to the Hyperlink set this value.
    /// - Since: 3.0.0
    public var highlightedLinkColor: UIColor?
    /// This will the Hyperlink Visited color.
    /// If you want to set some different **visited** color to the Hyperlink set this value.
    /// - Since: 3.0.0
    public var visitedLinkColor: UIColor?
}

/**
 *  A UIDHyperLinkLabel is the standard HyperLink to use as per DLS guideline.
 *  In InterfaceBuilder it is possible to create a UILabel/UIDLabel and give it the class UIDHyperLinkLabel.
 *
 *  @note Set UIDHyperLinkModel property values to configure the HyperLink as is needed
 *
 *  - Since: 3.0.0
 */

@IBDesignable
@objcMembers open class UIDHyperLinkLabel: UIDLabel {
    
    let textStorage = NSTextStorage()
    let layoutManager = NSLayoutManager()
    let textContainer = NSTextContainer()
    
    //MARK Variable declarations
    
    var linkList = [UIDHyperLinkModel]()
    
    var defaultLinkRange: NSRange? {
        var range: NSRange?
        
        if let labelText = text {
            range = NSRange(location: 0, length: labelText.unicodeScalars.count)
        }
        return range
    }
    
    fileprivate var backUpAttribute: NSAttributedString?
    fileprivate var hyperLinkLabelTextColor: UIColor?
    
    open override var numberOfLines: Int {
        didSet {
            textContainer.maximumNumberOfLines = numberOfLines
        }
    }
    
    open override var lineBreakMode: NSLineBreakMode {
        didSet {
            textContainer.lineBreakMode = lineBreakMode
        }
    }
    
    override open var attributedText: NSAttributedString? {
        didSet {
            updateTextStorage()
        }
    }
    
    open override var text: String? {
        didSet {
            if oldValue != text {
                linkList.removeAll()
            }
        }
    }
    
    open override var font: UIFont! {
        didSet {
            updateTextStorage()
        }
    }
    
    open override var textColor: UIColor! {
        didSet {
            hyperLinkLabelTextColor = textColor
            updateTextStorage()
        }
    }
    
    open override var textAlignment: NSTextAlignment {
        didSet {
            updateTextStorage()
        }
    }
    
    //MARK Default methods
    
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
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        instanceInit()
    }
    
    open override var intrinsicContentSize: CGSize {
        let superSize = super.intrinsicContentSize
        textContainer.size = CGSize(width: superSize.width, height: CGFloat.greatestFiniteMagnitude)
        let size = layoutManager.usedRect(for: textContainer)
        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }
    
    open override func drawText(in rect: CGRect) {
        let range = NSRange(location: 0, length: textStorage.length)
        
        textContainer.size = rect.size
        let newOrigin = CGPoint.zero
        
        layoutManager.drawBackground(forGlyphRange: range, at: newOrigin)
        layoutManager.drawGlyphs(forGlyphRange: range, at: newOrigin)
    }
    
    /**
     *  This will create a HyperLink with the given values of UIDHyperLinkModel.
     *
     *  - Important:
     *  1. To set custom values to configure the HyperLink,set the values of UIDHyperLinkModel according to the requirement.
     *      If not set,it will take default values. **For default values @see UIDHyperLinkModel**
     *
     * - Parameter linkDetails: UIDHyperLinkModel object to be used to configure the HyperLink
     * - Parameter handler: The callback which will be triggered on click of the HyperLink
     * - Since: 3.0.0
     */
    
    public func addLink(_ linkDetails: UIDHyperLinkModel, handler: @escaping ((NSRange) -> Void)) {
        if let attributedText = attributedText, attributedText.length > 0 {
            setUpAttributes(with: linkDetails, handler: handler)
            updateTextStorage()
            makeLinksClickable()
        }
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        backUpAttribute = attributedText
        
        if let indexOfCharacterTouched = getTouchedCharacterIndex(for: touches) {
            if let linkDetailsToBeSet = getHyperLinkModelToChangeAppearance(indexOfCharacterTouched),
                let highlightRange = linkDetailsToBeSet.highlightRange,
                let hyperLinkAttributedText = attributedText,
                let foregroundColor = linkDetailsToBeSet.highlightedLinkColor {
                let mutableAttributedText = NSMutableAttributedString(attributedString: hyperLinkAttributedText)
                mutableAttributedText.addAttribute(.foregroundColor,
                                                   value: foregroundColor,
                                                   range: highlightRange)
                attributedText = mutableAttributedText
                updateTextStorage()
            }
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        attributedText = backUpAttribute
        
        if let indexOfCharacterTouched = getTouchedCharacterIndex(for: touches) {
            if let linkDetailsToBeSet = getHyperLinkModelToChangeAppearance(indexOfCharacterTouched),
                let highlightRange = linkDetailsToBeSet.highlightRange,
                let hyperLinkAttributedText = attributedText,
                let foregroundColor = linkDetailsToBeSet.visitedLinkColor {
                let mutableAttributedText = NSMutableAttributedString(attributedString: hyperLinkAttributedText)
                mutableAttributedText.addAttribute(.foregroundColor,
                                                   value: foregroundColor,
                                                   range: highlightRange)
                attributedText = mutableAttributedText
                linkDetailsToBeSet.isVisited = true
                linkDetailsToBeSet.highlightHandler(highlightRange)
                updateTextStorage()
            }
        }
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        attributedText = backUpAttribute
        updateTextStorage()
    }
}

//MARK Helper methods

extension UIDHyperLinkLabel {
    
    func makeLinksClickable() {
        if !isUserInteractionEnabled {
            isUserInteractionEnabled = true
        }
    }
    
    fileprivate func instanceInit() {
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines
    }
    
    fileprivate func setUpAttributes(with linkDetails: UIDHyperLinkModel, handler: @escaping ((NSRange) -> Void)) {
        let linkDetails = getLinkDetailsModel(with: linkDetails, handler: handler)
        if let attributedText = attributedText {
            let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
            if let highlightRange = linkDetails.highlightRange, mutableAttributedText.isValid(range: highlightRange) {
                var linkAttributes = [NSAttributedStringKey: Any]()
                if let oldLinkIndex = linkList.index(where: {
                    if let highlightedRange = $0.highlightRange {
                        return NSEqualRanges(highlightedRange, highlightRange)
                    }
                    return false
                }) {
                    linkList[oldLinkIndex] = linkDetails
                } else {
                    linkList.append(linkDetails)
                }
                
                linkAttributes[.underlineStyle] = linkDetails.isUnderlined ?
                    NSNumber(value: NSUnderlineStyle.styleSingle.rawValue as Int) :
                    NSNumber(value: NSUnderlineStyle.styleNone.rawValue as Int)
                
                linkAttributes[.foregroundColor] = linkDetails.isVisited ?
                    linkDetails.visitedLinkColor :
                    linkDetails.normalLinkColor
                mutableAttributedText.addAttributes(linkAttributes, range: highlightRange)
                self.attributedText = mutableAttributedText
            }
        }
    }
    
    private func addLinkAttributes() -> NSMutableAttributedString {
        
        guard let attributedLabelText = attributedText, let font = font else {
            return NSMutableAttributedString()
        }
        
        let range = NSRange(location: 0, length: attributedLabelText.length)
        var attributes = [NSAttributedStringKey: Any]()
        
        let mutAttrString = NSMutableAttributedString(attributedString: attributedLabelText)
        attributes[.font] = font
        attributes[.foregroundColor] = hyperLinkLabelTextColor
        
        var paragraphStyle = attributes[.paragraphStyle] as? NSMutableParagraphStyle
        if paragraphStyle == nil {
            paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle?.lineBreakMode = lineBreakMode
            paragraphStyle?.alignment = textAlignment
            paragraphStyle?.lineSpacing = 0
            attributes[.paragraphStyle] = paragraphStyle
        }
        
        mutAttrString.setAttributes(attributes, range: range)
        attributedText!.enumerateAttributes(in: range,
                                            options: .longestEffectiveRangeNotRequired) { (attributes, range, _) in
                                                if attributes.count > 0 {
                                                    mutAttrString.addAttributes(attributes, range: range)
                                                }
        }
        return mutAttrString
    }
    
    fileprivate func updateTextStorage() {
        defer {
            setNeedsDisplay()
        }
        guard let attributedText = attributedText, attributedText.length > 0 else {
            textStorage.setAttributedString(NSAttributedString())
            return
        }
        let mutAttrString = addLinkAttributes()
        textStorage.setAttributedString(mutAttrString)
    }
    
    private func getLinkDetailsModel(with linkDetails: UIDHyperLinkModel,
                                     handler: @escaping ((NSRange) -> Void)) -> UIDHyperLinkModel {
        let newLinkDetails = UIDHyperLinkModel()
        newLinkDetails.normalLinkColor = linkDetails.normalLinkColor ?? theme?.hyperlinkDefaultText
        newLinkDetails.highlightedLinkColor = linkDetails.highlightedLinkColor ?? theme?.hyperlinkDefaultPressedText
        newLinkDetails.visitedLinkColor = linkDetails.visitedLinkColor ?? theme?.hyperlinkDefaultVisitedText
        newLinkDetails.highlightRange = linkDetails.highlightRange ?? defaultLinkRange
        newLinkDetails.highlightHandler = handler
        newLinkDetails.isUnderlined = linkDetails.isUnderlined
        newLinkDetails.isVisited = linkDetails.isVisited
        return newLinkDetails
    }
    
    private func indexOfCharacter(atPoint point: CGPoint) -> Int? {
        var textBoundingBox = layoutManager.usedRect(for: textContainer)
        textBoundingBox.size = bounds.size
        
        if textBoundingBox.contains(point) {
            let textContainerOffset = CGPoint(
                x: (bounds.size.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                y: (bounds.size.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
            
            let locationOfTouchInTextContainer = CGPoint(
                x: point.x - textContainerOffset.x,
                y: point.y - textContainerOffset.y)
            
            let indexOfCharacter = layoutManager.characterIndex(
                for: locationOfTouchInTextContainer,
                in: textContainer,
                fractionOfDistanceBetweenInsertionPoints: nil)
            
            return indexOfCharacter
        }
        return nil
    }
    
    fileprivate func getHyperLinkModelToChangeAppearance(_ touchedCharacter: Int) -> UIDHyperLinkModel? {
        for linkAttribute in linkList {
            if let highlightRange = linkAttribute.highlightRange, touchedCharacter >= highlightRange.location &&
                touchedCharacter <= highlightRange.location + highlightRange.length {
                return linkAttribute
            }
        }
        return nil
    }
    
    fileprivate func getTouchedCharacterIndex(for touches: Set<UITouch>) -> Int? {
        let touch = touches.first
        if let locationOfTouchInLabel = touch?.location(in: self) {
            return indexOfCharacter(atPoint: locationOfTouchInLabel)
        }
        return nil
    }
}
