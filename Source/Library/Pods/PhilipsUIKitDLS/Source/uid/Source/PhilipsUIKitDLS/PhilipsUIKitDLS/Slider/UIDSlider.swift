/* Copyright (c) Koninklijke Philips Electronics N.V. 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

/**
 *  A UIDSlider is the standard slider to use.
 *  In InterfaceBuilder it is possible to create a Slider and give it the class UIDSlider,
 *  the styling will be done immediately
 *
 *  - Since: 2017.5.0
 */
 @objcMembers open class UIDSlider: UISlider {
    
    ///Slider Constant.
    static let trackHeight: CGFloat = 4.0
    static let thumbHeight: CGFloat = UIDSize20 * 2
    
    /**
     * PhilipsUIKitDLS Theme Reference.
     *
     * Default value is UIDThemeManager's defaultTheme.
     *
     * - Since: 2017.5.0
     */
    open var theme = UIDThemeManager.sharedInstance.defaultTheme {
        didSet {
            configureTheme()
        }
    }
    
    //Internal variables.
    var minimumTrackView: UIView?
    var maximumTrackView: UIView?
    var minimumConstraint: NSLayoutConstraint?
    var maximumConstraint: NSLayoutConstraint?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        instanceInit()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        instanceInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func layoutSubviews() {
        setupWidth()
        super.layoutSubviews()
    }
    
    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if super.continueTracking(touch, with: event) { setupWidth() }
        return true
    }
    
    open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let continueTracking = super.continueTracking(touch, with: event)
        if continueTracking { setupWidth() }
        return continueTracking
    }
}

extension UIDSlider {
    func instanceInit() {
        configureThumb()
        configureTrack()
        configureTheme()
    }
    
    func configureThumb() {
        setThumbImage(thumbImageForNormalState(), for: .normal)
        setThumbImage(thumbImageForHighlightedState(), for: .highlighted)
    }
    
    func configureTrack() {
        setMinimumTrackImage(UIColor.clear.createImage(), for: .normal)
        setMaximumTrackImage(UIColor.clear.createImage(), for: .normal)
        setupTracks()
    }
    
    func configureTheme() {
        minimumTrackView?.backgroundColor = theme?.trackDefaultOnBackground
        maximumTrackView?.backgroundColor = theme?.trackDefaultOffBackground
    }

    func thumbImageForNormalState() -> UIImage? {
        let thumbView = UIView(frame: CGRect(x: 0, y: 0, width: UIDSlider.thumbHeight, height: UIDSlider.thumbHeight))
        thumbView.layer.cornerRadius = thumbView.frame.size.height / 2
        thumbView.backgroundColor = .clear
        let innerView = UIView(frame: CGRect(x: 0, y: 0, width: UIDSize16, height: UIDSize16))
        innerView.center = thumbView.center
        innerView.backgroundColor = theme?.thumbDefaultBackground
        innerView.layer.cornerRadius = innerView.frame.size.height / 2
        if let theme = theme {
            let dropShadow = UIDDropShadow(level: .level1, theme: theme)
            innerView.apply(dropShadow: dropShadow)
        }
        thumbView.addSubview(innerView)
        return thumbView.drawImage()
    }
    
    func thumbImageForHighlightedState() -> UIImage? {
        let thumbView = UIView(frame: CGRect(x: 0, y: 0, width: UIDSlider.thumbHeight, height: UIDSlider.thumbHeight))
        thumbView.layer.cornerRadius = thumbView.frame.size.height / 2
        thumbView.backgroundColor = theme?.thumbDefaultPressedBorder
        let innerView = UIView(frame: CGRect(x: 0, y: 0, width: UIDSize24, height: UIDSize24))
        innerView.center = thumbView.center
        innerView.backgroundColor = theme?.thumbDefaultBackground
        innerView.layer.cornerRadius = innerView.frame.size.height / 2
        if let theme = theme {
            let dropShadow = UIDDropShadow(level: .level1, theme: theme)
            innerView.apply(dropShadow: dropShadow)
        }
        thumbView.addSubview(innerView)
        return thumbView.drawImage()
    }

    func setupTracks() {
        let sliderValue = CGFloat((Float(frame.size.width - UIDSlider.thumbHeight) / maximumValue) * value)
        
        (minimumTrackView, maximumTrackView) = (UIView.makePreparedForAutoLayout(), UIView.makePreparedForAutoLayout())
        minimumTrackView?.isUserInteractionEnabled = false
        maximumTrackView?.isUserInteractionEnabled = false
        
        if let maximumTrackView = maximumTrackView {
            addSubview(maximumTrackView)
            NSLayoutConstraint(item: maximumTrackView, attribute: .trailing, relatedBy: .equal,
                               toItem: self, attribute: .trailing, multiplier: 1.0, constant: -UIDSlider.thumbHeight / 2).isActive = true
            NSLayoutConstraint(item: maximumTrackView, attribute: .centerY, relatedBy: .equal,
                               toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: maximumTrackView, attribute: .height, relatedBy: .equal,
                               toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: UIDSlider.trackHeight).isActive = true
            maximumConstraint = NSLayoutConstraint(item: maximumTrackView, attribute: .leading, relatedBy: .equal,
                                                   toItem: self, attribute: .leading, multiplier: 1.0, constant: sliderValue + UIDSlider.thumbHeight / 2)
            if let maximumConstraint = maximumConstraint { maximumConstraint.isActive = true }
        }
        
        if let minimumTrackView = minimumTrackView {
            addSubview(minimumTrackView)
            NSLayoutConstraint(item: minimumTrackView, attribute: .leading, relatedBy: .equal,
                               toItem: self, attribute: .leading, multiplier: 1.0, constant: UIDSlider.thumbHeight / 2).isActive = true
            NSLayoutConstraint(item: minimumTrackView, attribute: .centerY, relatedBy: .equal,
                               toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: minimumTrackView, attribute: .height, relatedBy: .equal,
                               toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: UIDSlider.trackHeight).isActive = true
            minimumConstraint = NSLayoutConstraint(item: minimumTrackView, attribute: .trailing, relatedBy: .equal,
                                                   toItem: self, attribute: .leading, multiplier: 1.0, constant: sliderValue - UIDSlider.thumbHeight / 2)
            if let minimumConstraint = minimumConstraint { minimumConstraint.isActive = true }
        }
    }
    
    func setupWidth() {
        let factor = value / maximumValue
        if let currentThumbImage = currentThumbImage {
            let sliderMininumValue = (frame.size.width - currentThumbImage.size.width - UIDSlider.thumbHeight / 4) * CGFloat(factor)
            minimumConstraint?.constant = sliderMininumValue + currentThumbImage.size.width / 2
            maximumConstraint?.constant = sliderMininumValue + currentThumbImage.size.width / 2
        }
    }
}
