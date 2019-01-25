//  Copyright © 2016 Philips. All rights reserved.

import UIKit

public extension UIView {

    /// - Since: 3.0.0
    public class func makePreparedForAutoLayout() -> Self {
        let view = self.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    /// - Since: 3.0.0
    public func removeConstraintsOfSubviews() {
        for view in subviews {
            view.removeConstraints(view.constraints)
        }
    }
    
    /// - Since: 3.0.0
    public func addConstraints(_ visualStringConstraints: [String],
                               metrics: [String : Any]?,
                               views: [String : Any]) {
        for visualFormat in visualStringConstraints {
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: visualFormat,
                                                                           options: [],
                                                                           metrics: metrics,
                                                                           views: views))
        }
    }
    
    @discardableResult
    /// - Since: 3.0.0
    public func constrainToSuperviewLeft(_ constant: CGFloat = 0, multiplier: CGFloat = 1) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .left,
                                            relatedBy: .equal,
                                            toItem: superview,
                                            attribute: .left,
                                            multiplier: multiplier,
                                            constant: constant)
        constraint.isActive = true
        self.superview?.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    /// - Since: 3.0.0
    public func constrainToSuperviewTop(_ constant: CGFloat = 0, multiplier: CGFloat = 1) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .top,
                                            relatedBy: .equal,
                                            toItem: superview,
                                            attribute: .top,
                                            multiplier: multiplier,
                                            constant: constant)
        constraint.isActive = true
        self.superview?.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    /// - Since: 3.0.0
    public func constrainToSuperviewBottom(_ constant: CGFloat = 0, multiplier: CGFloat = 1) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .bottom,
                                            relatedBy: .equal,
                                            toItem: superview,
                                            attribute: .bottom,
                                            multiplier: multiplier,
                                            constant: constant)
        constraint.isActive = true
        self.superview?.addConstraint(constraint)
        return constraint
    }
    
    /// - Since: 3.0.0
    public func constrainToSuperview(to origin: CGSize, multiplier: CGFloat = 1) {
        constrainToSuperviewLeft(0)
        constrainToSuperviewTop(0)
    }
    
    /// - Since: 3.0.0
    public func constrainToSuperview() {
        constrainToSuperviewLeft(0)
        constrainToSuperviewRight(to: 0)
        constrainToSuperviewTop(0)
        constrainToSuperviewBottom()
    }
    
    /// - Since: 1805.0.0
    public func constrainToSuperviewAccordingToLanguage() {
        constrainToSuperviewLeading(to: 0)
        constrainToSuperviewTrailing(to: 0)
        constrainToSuperviewTop(0)
        constrainToSuperviewBottom()
    }
    
    @discardableResult
    /// - Since: 3.0.0
    public func constrainToSuperviewRight(to constant: CGFloat, multiplier: CGFloat = 1) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .right,
                                            relatedBy: .equal,
                                            toItem: superview,
                                            attribute: .right,
                                            multiplier: multiplier,
                                            constant: constant)
        constraint.isActive = true
        self.superview?.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    /// - Since: 2107.5.0
    public func constrainToSuperviewTrailing(to constant: CGFloat, multiplier: CGFloat = 1) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .trailing,
                                            relatedBy: .equal,
                                            toItem: superview,
                                            attribute: .trailing,
                                            multiplier: multiplier,
                                            constant: constant)
        constraint.isActive = true
        self.superview?.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    /// - Since: 2017.5.0
    public func constrainToSuperviewLeading(to constant: CGFloat, multiplier: CGFloat = 1) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .leading,
                                            relatedBy: .equal,
                                            toItem: superview,
                                            attribute: .leading,
                                            multiplier: multiplier,
                                            constant: constant)
        constraint.isActive = true
        self.superview?.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    /// - Since: 3.0.0
    public func constrain(toWidth width: CGFloat = 0,
                          multiplier: CGFloat = 1,
                          layoutPriority: Float = 1000) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .width,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: multiplier,
                                            constant: width)
        constraint.priority = UILayoutPriority(rawValue: layoutPriority)
        constraint.isActive = true
        addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    /// - Since: 3.0.0
    public func constrain(toHeight height: CGFloat = 0,
                          multiplier: CGFloat = 1,
                          layoutPriority: Float = 1000) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .height,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: multiplier,
                                            constant: height)
        constraint.priority = UILayoutPriority(rawValue: layoutPriority)
        constraint.isActive = true
        addConstraint(constraint)
        return constraint
    }
    
    /// - Since: 3.0.0
    public func constrain(toSize size: CGSize, multiplier: CGFloat = 1, layoutPriority: Float = 1000) {
        constrain(toWidth: size.width, multiplier: multiplier, layoutPriority: layoutPriority)
        constrain(toHeight: size.height, multiplier: multiplier, layoutPriority: layoutPriority)
    }
    
    /// - Since: 3.0.0
    public func constrainVerticallyCenteredToParent() {
        let constraint = NSLayoutConstraint(item: self, attribute: .centerY,
                                            relatedBy: .equal,
                                            toItem: superview,
                                            attribute: .centerY,
                                            multiplier: 1,
                                            constant: 0)
        constraint.isActive = true
        superview?.addConstraint(constraint)
    }
    
    /// - Since: 3.0.0
    public func constrainHorizontallyCenteredToParent() {
        let constraint = NSLayoutConstraint(item: self, attribute: .centerX,
                                            relatedBy: .equal,
                                            toItem: superview,
                                            attribute: .centerX,
                                            multiplier: 1,
                                            constant: 0)
        constraint.isActive = true
        superview?.addConstraint(constraint)
    }
    
    /// - Since: 3.0.0
    public func constrainCenterToParent() {
        constrainVerticallyCenteredToParent()
        constrainHorizontallyCenteredToParent()
    }
}
