/* Copyright (c) Koninklijke Philips Electronics N.V. 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

let pageControlHeight: CGFloat = 48
let interPageSpacing: CGFloat = 8

/**
 *  UIDPageControlDelegate is a protocol for UIDPageControl.
 *  This protocal responsible to send event on page change.
 *
 *  - Since: 3.0.0
 */
@objc
public protocol UIDPageControlDelegate: NSObjectProtocol {
    // send event on validation icon-view tapped.
    // - Since: 3.0.0
    @objc
    optional func pageDidChange(_ pageControl: UIDPageControl)
}

/**
 *  A UIDPageControl is the standard page control to use as per DLS guideline.
 *  In InterfaceBuilder it is possible to create a UIView and give it the class UIDPageControl,
 *  the styling and layout setup will be done immediately.
 *
 *  - Since: 3.0.0
 */
@IBDesignable
@objcMembers open class UIDPageControl: UIView {
    
    /// number of dots in Page Control.
    /// - Since: 3.0.0
    @IBInspectable
    public var numberOfPages: Int = 2 {
        didSet {
            if numberOfPages < 2 {
                numberOfPages = 0
            }
            arrangeDots()
        }
    }
    
    /// current dot which is highlighted
    /// - Since: 3.0.0
    @IBInspectable
    public var currentPage: Int = 0 {
        didSet {
            currentPage = (min(numberOfPages-1, max(0, currentPage)))
            highlightCurrentPage()
        }
    }

    /**
     * Set delegate for change in highlighted dots.
     *
     * - Since: 3.0.0
     */
    weak open var delegate: UIDPageControlDelegate?
    
    let pageStackView = UIStackView.makePreparedForAutoLayout()

    var dots: [DotView] = []

    var selectedDot: DotView? {
        return (0 ..< numberOfPages ~= currentPage) ? dots[currentPage] : nil
    }
    
    /// UIDTheme used for styling the alert controller.
    /// By default it takes the theme set in UIDThemeManager.sharedInstance.
    /// - Since: 3.0.0
    public var theme: UIDTheme? = UIDThemeManager.sharedInstance.defaultTheme {
        didSet {
            configureTheme()
        }
    }
    
    func configureTheme() {
        dots.forEach { dot in
            dot.theme = theme
            dot.isHighlighted = dot == selectedDot ? true : false
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
        instanceInit()
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        instanceInit()
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width, height: pageControlHeight)
    }
}

extension UIDPageControl {
    func instanceInit() {
        addSubview(pageStackView)
        pageStackView.spacing = interPageSpacing
        clipsToBounds = true
        backgroundColor = UIColor.clear
        setupConstraints()
        setupGestures()
    }
    
    func moveTo(page: Int, ignoreCallBack: Bool) {
        currentPage = page
        if ignoreCallBack == false && 0 ..< numberOfPages ~= page {
            delegate?.pageDidChange?(self)
        }
    }
    
    func highlightCurrentPage() {
        dots.enumerated().forEach { (index, dot) in
            dot.isHighlighted = (currentPage == index) ? true : false
        }
    }
    
    func arrangeDots() {
        pageStackView.removeAllArrangedSubviews()
        dots.removeAll()
        
        for _ in 0..<numberOfPages {
            let dot = DotView.makePreparedForAutoLayout()
            dot.theme = theme
            pageStackView.addArrangedSubview(dot)
            dots.append(dot)
        }
        highlightCurrentPage()
    }
}

extension UIDPageControl {
    func setupConstraints() {
        pageStackView.constrainCenterToParent()
        constrain(toHeight: pageControlHeight)
        
        var layout = NSLayoutConstraint(item: pageStackView, attribute: .leading,
                                        relatedBy: .greaterThanOrEqual,
                                        toItem: self, attribute: .leading,
                                        multiplier: 1, constant: 0)
        layout.priority = .defaultLow
        addConstraint(layout)
        
        layout = NSLayoutConstraint(item: self, attribute: .trailing,
                                    relatedBy: .greaterThanOrEqual,
                                    toItem: pageStackView, attribute: .trailing,
                                    multiplier: 1, constant: 0)
        layout.priority = .defaultLow
        addConstraint(layout)
    }
    
    func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(tappedOnContentArea(gesture:)))
        addGestureRecognizer(tapGesture)
        
        let directions: [UISwipeGestureRecognizerDirection] = [.left, .right]
        directions.forEach { direction in
            let gesture = UISwipeGestureRecognizer(target: self,
                                                   action: #selector(swippedOnContentArea(gesture:)))
            gesture.direction = direction
            addGestureRecognizer(gesture)
        }
    }
    
   func swippedOnContentArea(gesture: UISwipeGestureRecognizer) {
        let nextPage = (gesture.direction == .left) ? (currentPage - 1) : (currentPage + 1)
        moveTo(page: nextPage, ignoreCallBack: false)
    }
    
    func tappedOnContentArea(gesture: UITapGestureRecognizer) {
        if let selectedDot = selectedDot {
            let touchPoint = gesture.location(in: self)
            let dotPoint = pageStackView.convert(selectedDot.center, to: self)
            let nextPage = touchPointIsOverflowing(touchPoint: touchPoint, from: dotPoint) ?
                (currentPage - 1) :
                (currentPage + 1)
            moveTo(page: nextPage, ignoreCallBack: false)
        }
    }
    
    func touchPointIsOverflowing(touchPoint: CGPoint, from dotPoint: CGPoint) -> Bool {
        return LayoutDirection.isRightToLeft ?
            touchPoint.x > dotPoint.x :
            touchPoint.x < dotPoint.x
    }
}
