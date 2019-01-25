/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsIconFontDLS 

private let ratingLabelHeight: CGFloat = 16
private let ratingLabelStarSpacing: CGFloat = 8
private let ratingLabelFontSize: CGFloat = 14

/**
 * The types of Rating Bar (UIDRatingBarType) that are available.
 * In code, you should use these types. Unfortunately, Interface Builder doesn't support enums yet,
 * so if you configure the Rating Bar in Interface Builder, you have to use the numeric values.
 *
 * - Since: 3.0.0
 */
@objc
public enum UIDRatingBarType: Int {
    /// default Rating Bar Type: (numerical value: 0). You can click this Rating Bar and give your ratings in this type
    /// - Since: 3.0.0
    case input
    /// This is a display Rating Bar Type: (numerical value: 1).
    /// You can view the Ratings in this type
    /// - Since: 3.0.0
    case starOnlyDisplay
    /// This is a display Rating Bar Type: (numerical value: 2).
    /// You can view the Ratings Value as text and one Star is visible in this type
    /// - Since: 3.0.0
    case miniDisplay
    /// This is a display Rating Bar Type: (numerical value: 3).
    /// You can view the Ratings Value as text and also the selected Stars in this type
    /// - Since: 3.0.0
    case valueDisplay
}

/**
 *  A UIDRatingBar is the standard Rating Bar to use as per DLS guideline.
 *  In InterfaceBuilder it is possible to create a UIView and give it the class UIDRatingBar,
 *  the styling and layout setup will be done immediately.
 *
 *  @note Use "ratingBarType" API to update the Rating Bar type anytime. @see ratingBarType
 *
 *  - Since: 3.0.0
 */
@IBDesignable
@objcMembers open class UIDRatingBar: UIControl {
    
    // MARK: Variable Declarations
    
    /**
     * Use this API to update the Rating Value anytime.
     *
     * Default value is 0.0.
     *
     * - Since: 3.0.0
     */
    @IBInspectable
    public var ratingValue: CGFloat = 0.0 {
        didSet {
            rating = CGFloat(max(0, min(ratingValue, CGFloat(maximumNumberOfStars))))
        }
    }
    
    /**
     * Use this API to update the Rating Text anytime.
     *
     * Default value is Blank.
     *
     * - Since: 3.0.0
     */
    @IBInspectable
    public var ratingText: String = "" {
        didSet {
            if ratingBarType == .miniDisplay || ratingBarType == .valueDisplay {
                ratingLabel?.text = ratingText
                resizeRatingBar()
                setNeedsDisplay()
            }
        }
    }
    
    // swiftlint:disable valid_ibinspectable
    /**
     * Type of Rating Bar.
     *
     * Default value is UIDRatingBarType.input.
     *
     * - Since: 3.0.0
     */
    @IBInspectable
    public var ratingBarType: UIDRatingBarType = .input {
        didSet {
            if oldValue != ratingBarType {
                removeAllSubviews()
                resizeRatingBar()
                setUpRatingBarStackView()
            }
        }
    }
    // swiftlint:enable valid_ibinspectable
    
    var ratingStarsStackView: UIStackView!
    var ratingLabel: UILabel?
    
    var ratingBarWidthConstraint: NSLayoutConstraint!
    var ratingBarHeightConstraint: NSLayoutConstraint!
    
    var theme: UIDTheme? {
        return UIDThemeManager.sharedInstance.defaultTheme
    }
    
    var ratingLabelWidth: CGFloat {
        return ratingLabel != nil && ratingBarType != .input ? (ratingLabel?.width)! + ratingLabelStarSpacing : 0.0
    }
    
    var maximumNumberOfStars: Int {
        return ratingBarType == .miniDisplay ? 1 : 5
    }
    
    var ratingStarWidth: CGFloat {
        return ratingBarType == .input ? 48 : 20
    }
    
    var ratingStarHeight: CGFloat {
        return ratingBarType == .input ? 48 : 16
    }
    
    var ratingStarIconWidth: CGFloat {
        return ratingBarType == .input ? 32 : 16
    }
    
    var ratingStarIconHeight: CGFloat {
        return ratingBarType == .input ? 32 : 16
    }
    
    var ratingBarHeight: CGFloat {
        return ratingBarType == .input ? 48 : 16
    }
    
    var ratingBarWidth: CGFloat {
        return ratingBarType == .miniDisplay || ratingBarType == .valueDisplay ?
            (ratingStarWidth * CGFloat(maximumNumberOfStars)) + ratingLabelWidth :
            ratingStarWidth * CGFloat(maximumNumberOfStars)
    }
    
    private(set)var rating: CGFloat = 0.0 {
        didSet {
            for (index, subview) in ratingStarsStackView.arrangedSubviews.enumerated() {
                guard let container = subview as? RatingStarContainer else { continue }
                let star = container.ratingStar
                
                if ratingBarType == .miniDisplay {
                    star.progress = 1.0
                    continue
                }
                
                if index < Int(ceil(rating)) {
                    if index < Int(floor(rating)) {
                        star.progress = 1.0
                    } else {
                        star.progress = rating - floor(rating)
                    }
                } else {
                    star.progress = 0
                }
            }
        }
    }
    
    // MARK: Default methods
    public override init(frame: CGRect) {
        super.init(frame: frame)
        instanceInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        instanceInit()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        instanceInit()
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        instanceInit()
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard ratingBarType == .input else {
            return
        }
        handle(touches: touches, shouldSendValueChangedAction: false)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        guard ratingBarType == .input else {
            return
        }
        handle(touches: touches, shouldSendValueChangedAction: true)
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard ratingBarType == .input else {
            return
        }
        handle(touches: touches, shouldSendValueChangedAction: true)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard ratingBarType == .input else {
            return
        }
        handle(touches: touches, shouldSendValueChangedAction: true)
    }
}

// MARK: Helper methods

extension UIDRatingBar {
    
    fileprivate func instanceInit() {
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        deActivateDimensionConstraintsForRatingBar()
        removeAllSubviews()
        setUpRatingBarStackView()
        ratingBarType = { ratingBarType }()
        ratingValue = { ratingValue }()
    }
    
    fileprivate func setUpStarStackView() {
        ratingStarsStackView = UIStackView.makePreparedForAutoLayout()
        ratingStarsStackView.backgroundColor = UIColor.clear
        ratingStarsStackView.alignment = .center
        ratingStarsStackView.axis = .horizontal
        ratingStarsStackView.distribution = .fillEqually
        ratingStarsStackView.spacing = 0
        addSubview(ratingStarsStackView)
        ratingStarsStackView.constrain(toHeight: ratingBarHeight)
        ratingStarsStackView.constrainToSuperviewTop()
        ratingStarsStackView.constrainToSuperviewTrailing(to: 0)
    }
    
    fileprivate func setUpRatingLabel() {
        ratingLabel = UILabel.makePreparedForAutoLayout()
        if let ratingLabel = ratingLabel {
            ratingLabel.backgroundColor = UIColor.clear
            ratingLabel.textAlignment = .center
            ratingLabel.numberOfLines = 0
            ratingLabel.lineBreakMode = .byWordWrapping
            ratingLabel.font = UIFont(uidFont: .medium, size: ratingLabelFontSize)
            ratingLabel.textColor = theme?.ratingBarDefaultOnText
            ratingLabel.text = ratingText
            addSubview(ratingLabel)
            resizeRatingBar()
            ratingLabel.constrain(toHeight: ratingLabelHeight)
            ratingLabel.constrainToSuperviewTop()
            let constratint = NSLayoutConstraint(item: ratingStarsStackView,
                                                 attribute: .leading,
                                                 relatedBy: .equal,
                                                 toItem: ratingLabel,
                                                 attribute: .trailing,
                                                 multiplier: 1,
                                                 constant: ratingLabelStarSpacing)
            addConstraint(constratint)
        }
    }
    
    fileprivate func setUpStars() {
        ratingStarsStackView.removeAllSubviews()
        for _ in 1...maximumNumberOfStars {
            let designatedSize = CGSize(width: ratingStarWidth, height: ratingStarHeight)
            let starLabel = RatingStarContainer(designatedSize: designatedSize)
            starLabel.fontSize = ratingStarIconWidth
            ratingStarsStackView.addArrangedSubview(starLabel)
            starLabel.theme = theme
        }
    }
    
    fileprivate func setUpRatingBarStackView() {
        setUpStarStackView()
        
        switch ratingBarType {
        case .input, .starOnlyDisplay:
            setUpStars()
        case .miniDisplay, .valueDisplay:
            setUpStars()
            setUpRatingLabel()
        }
    }
    
    fileprivate func resizeRatingBar() {
        ratingBarWidthConstraint.constant = ratingBarWidth
        ratingBarHeightConstraint.constant = ratingBarHeight
        setNeedsUpdateConstraints()
    }
    
    fileprivate func deActivateDimensionConstraintsForRatingBar() {
        var widthConstraint: NSLayoutConstraint!
        var heightConstraint: NSLayoutConstraint!
        
        if let firstWidthConstraint = self.constraints.first(where: {$0.firstAttribute == .width && $0.isActive == true}) {
            widthConstraint = firstWidthConstraint
            widthConstraint.constant = ratingBarWidth
        } else {
            widthConstraint = NSLayoutConstraint(item: self,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1,
                                                 constant: ratingBarWidth)
            widthConstraint.isActive = true
            addConstraint(widthConstraint)
        }
        
        if let firstHeightConstraint = self.constraints.first(where: {$0.firstAttribute == .height && $0.isActive == true}) {
            heightConstraint = firstHeightConstraint
            heightConstraint.constant = ratingBarHeight
        } else {
            heightConstraint = NSLayoutConstraint(item: self,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1,
                                                  constant: ratingBarHeight)
            heightConstraint.isActive = true
            addConstraint(heightConstraint)
        }
        
        setNeedsUpdateConstraints()
        
        ratingBarWidthConstraint = widthConstraint
        ratingBarHeightConstraint = heightConstraint
    }
    
    fileprivate func handle(touches: Set<UITouch>, shouldSendValueChangedAction: Bool) {
        let touch = touches.first
        if let point = touch?.location(in: ratingStarsStackView) {
            if ratingStarsStackView.frame.contains(point) {
                let startX = LayoutDirection.isRightToLeft ? frame.size.width - point.x : point.x
                ratingValue = ceil((startX / ratingStarsStackView.frame.size.width) * CGFloat(maximumNumberOfStars))
                if shouldSendValueChangedAction == true {
                    sendActions(for: .valueChanged)
                }
            }
        }
    }
}

private extension UILabel {
    
    var width: CGFloat {
        let labelSize = sizeToFit(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                        height: ratingLabelHeight))
        return labelSize.width
    }
}
