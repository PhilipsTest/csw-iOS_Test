//  Copyright © 2016 Philips. All rights reserved.

import UIKit

fileprivate let contentSize = CGSize(width: 48, height: 24)
fileprivate let trackSize = CGSize(width: 40, height: 16)
fileprivate let stateChangeTransitionTime: CGFloat =  0.1
fileprivate let trackRadius = trackSize.height * 0.5

/**
 *  A UIDSwitch is the standard switch to use.
 *  In InterfaceBuilder it is possible to create a UIView and give it the class UIDSwitch, the styling will be done
 *  immediately.
 *
 * - Since: 3.0.0
 */

@IBDesignable
@objcMembers open class UIDSwitch: UIControl {
    let contentView = UIView()

    let trackView = UIView()
    let onTrackView = UIView()
    let offTrackView = UIView()

    var thumbButton = SwitchThumbButton()
    var leadingThumbConstraint: NSLayoutConstraint!

    private let tapGestureRecognizer = UITapGestureRecognizer()
    
    /**
     *  Configure the control's theme.
     *  - Since: 3.0.0
     */
    open var theme: UIDTheme? = UIDThemeManager.sharedInstance.defaultTheme {
        didSet {
            configureTheme()
        }
    }
        
    /**
     *  Set to true if is 'on'.
     *  - Since: 3.0.0
     */
    @IBInspectable
    open var isOn: Bool = true {
        didSet {
            updateSwitchUI()
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        instanceInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        instanceInit()
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        instanceInit()
    }
    
    private func instanceInit() {
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        setupContentView()
        setupTrackView()
        setupThumb()
        setupOnTrackView()
        setupOffTrackView()
        self.layoutIfNeeded()
        setupGesture()
        contentView.bringSubview(toFront: thumbButton)
        configureTheme()
        transitState(toOn: self.isOn, animated: false, ignoringEvents: true)
        if LayoutDirection.isRightToLeft {
            transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    
    private func setupContentView() {
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.constrain(toSize: contentSize)
        contentView.constrainCenterToParent()
        contentView.backgroundColor = UIColor.clear
    }
    
    private func setupGesture() {
        contentView.isUserInteractionEnabled = true
        contentView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.addTarget(self, action: #selector(tappedOnContentArea))
    }
    
    private func setupTrackView() {
        contentView.addSubview(trackView)
        trackView.translatesAutoresizingMaskIntoConstraints = false
        trackView.constrain(toSize: trackSize)
        trackView.constrainCenterToParent()
        trackView.cornerRadius = min(trackSize.width, trackSize.height) * 0.5
        trackView.clipsToBounds = true
    }
    
    private func setupOnTrackView() {
        trackView.addSubview(onTrackView)
        onTrackView.translatesAutoresizingMaskIntoConstraints = false
        onTrackView.constrainToSuperview(to: .zero)
        onTrackView.constrain(toHeight: trackSize.height)

        let onConstraint = NSLayoutConstraint(item: onTrackView,
                                              attribute: .right,
                                              relatedBy: .equal,
                                              toItem: thumbButton,
                                              attribute: .centerX,
                                              multiplier: 1.0,
                                              constant:0)
        contentView.addConstraint(onConstraint)
    }
    
    private func setupOffTrackView() {
        trackView.addSubview(offTrackView)
        offTrackView.translatesAutoresizingMaskIntoConstraints = false
        offTrackView.constrain(toHeight: trackSize.height)
        offTrackView.constrainToSuperviewRight(to: 0)
        offTrackView.constrainToSuperviewTop(0)
        let offConstraint = NSLayoutConstraint(item: offTrackView,
                                              attribute: .left,
                                              relatedBy: .equal,
                                              toItem: thumbButton,
                                              attribute: .centerX,
                                              multiplier: 1.0,
                                              constant:0)
        contentView.addConstraint(offConstraint)
    }

    private func setupThumb() {
        contentView.addSubview(thumbButton)
        thumbButton.configure()

        let constraintX = NSLayoutConstraint(item: thumbButton,
                                             attribute: .centerX,
                                             relatedBy: .equal,
                                             toItem: trackView,
                                             attribute: .left,
                                             multiplier: 1.0,
                                             constant:trackSize.height*0.5)
        constraintX.isActive = true
        contentView.addConstraint(constraintX)
        leadingThumbConstraint = constraintX

        thumbButton.addTarget(self, action: #selector(thumbDragged(sender:withEvent:)), for: .touchDragInside)
        thumbButton.addTarget(self, action: #selector(thumbTapped(sender:)),
                              for: [.touchUpInside, .touchCancel, .touchUpOutside])
        thumbButton.addTarget(self, action: #selector(thumbTouchDown(sender:)), for: .touchDown)
    }
    
    /**
     *  Set the state of the switch to On or Off, optionally animating the transition.
     *  Setting the switch to either position does not result in an action message being sent.
     *
     *  @param on true if the switch should be turned to the On position;
            false if it should be turned to the Off position.
            If the switch is already in the designated position, nothing happens.
     *  @param animated animate the transition of the switch; otherwise false.
     *
     *  - Since: 3.0.0
     */
   @objc open func setOn(_ isOn: Bool, animated: Bool) {
        transitState(toOn: isOn, animated: animated, ignoringEvents: true)
    }
    
    @IBInspectable
    open override var isEnabled: Bool {
        didSet {
            configureTheme()
        }
    }
    
    ///Invoked by setValue(_:forKey:) when it finds no property for a given key. In this case 'isEnabled'
  @objc override open func setValue(_ value: Any?, forUndefinedKey key: String) {
        if let value = value as? Bool, key == "isEnabled" {
            self.isEnabled = value
            return
        }
        super.setValue(value, forUndefinedKey: key)
    }
    
    open override var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    private func updateSwitchUI() {
        var thumbOffset: CGFloat = trackRadius
        if isOn {
            thumbOffset = trackView.frame.size.width - trackRadius
        }
        leadingThumbConstraint.constant = thumbOffset
        setNeedsUpdateConstraints()
        configureTheme()
    }

    private func transitState(toOn: Bool, animated: Bool, ignoringEvents: Bool) {
        let thumbOffset: CGFloat = toOn ? trackView.frame.size.width - trackRadius :trackRadius
        
        leadingThumbConstraint.constant = thumbOffset
        self.setNeedsUpdateConstraints()
        
        let layoutUpdateStartClosure: () -> Void = {
            self.isUserInteractionEnabled = false
            self.layoutIfNeeded()
        }
        let layoutUpdateFinishClosure: () -> Void = {
           // isFinished in
            self.isUserInteractionEnabled = true
            self.isOn = toOn
            if !ignoringEvents {
                self.sendActions(for: [.valueChanged, .touchUpInside])
            }
        }
        
        if animated {
            thumbButton.highlightThumbAnimationToAppear(false)
            UIView.animate(withDuration: TimeInterval(stateChangeTransitionTime),
                           delay: 0, options: [.curveEaseInOut, .allowUserInteraction],
                           animations: layoutUpdateStartClosure) { _ in
                            layoutUpdateFinishClosure()
            }
        } else {
            layoutUpdateStartClosure()
            layoutUpdateFinishClosure()
        }
    }

     func thumbDragged(sender: UIButton, withEvent event: UIEvent) {
        let touch = (event.touches(for:sender)?.first)!
        let previousPosition = touch.previousLocation(in: sender)
        let position = touch.location(in: sender)
        let diffX = position.x - previousPosition.x
        
        var newConstant: CGFloat = leadingThumbConstraint.constant + diffX
        let minX = trackRadius
        let maxX = trackView.frame.size.width - trackRadius
        newConstant = min(maxX, newConstant)
        newConstant = max(minX, newConstant)
        leadingThumbConstraint.constant = newConstant
        setNeedsUpdateConstraints()
    }
    
    func thumbTouchDown(sender: UIButton) {
        thumbButton.highlightThumbAnimationToAppear(true)
    }
    
    func thumbTapped(sender: UIButton) {
        transitState(toOn: !self.isOn, animated: true, ignoringEvents: false)
    }
    
    func tappedOnContentArea() {
        transitState(toOn: !self.isOn, animated: true, ignoringEvents: false)
    }
    
    private func configureTheme() {
        if isEnabled {
            thumbButton.thumbLayer.fillColor = theme?.thumbDefaultBackground?.cgColor
            onTrackView.backgroundColor = theme?.trackDefaultOnBackground
            offTrackView.backgroundColor = theme?.trackDefaultOffBackground
            thumbButton.highlightedThumbLayer.fillColor = theme?.thumbDefaultFocusBorder?.cgColor
        } else {
            thumbButton.thumbLayer.fillColor = theme?.thumbDefaultDisabledBackground?.cgColor
            onTrackView.backgroundColor = theme?.trackDefaultDisabledBackground
            offTrackView.backgroundColor = theme?.trackDefaultDisabledBackground
        }
    }
}
