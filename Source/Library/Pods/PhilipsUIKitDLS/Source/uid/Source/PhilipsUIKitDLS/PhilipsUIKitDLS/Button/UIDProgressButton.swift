//  Copyright © 2016 Philips. All rights reserved.

import Foundation

/// A UIDProgressButton is a type of UIDButton. The styling can be done as like that of UIDButton. This class can be
/// used for showing progress option when some operation is in progress.
/// - Since: 3.0.0
@objcMembers open class UIDProgressButton: UIDButton {
    
    /// Short text that provides detail about the reason for progress.
    /// - Since: 3.0.0
    @IBInspectable
    open var progressTitle: String? = nil {
        didSet {
            if let overlayProgressView = overlayProgressView {
                overlayProgressView.title = progressTitle
            }
        }
    }
    
    /// Style of the progress indicator, by default it is indeterminate.
    /// It can be either determinate or indeterminate.
    /// - Since: 3.0.0
    open var progressIndicatorStyle: UIDProgressIndicatorStyle = .indeterminate {
        didSet {
            if let overlayProgressView = overlayProgressView {
                overlayProgressView.activityIndicator.progressIndicatorStyle = progressIndicatorStyle
            }
        }
    }
    
    /// Show/Hide the activity indicator in a UIDProgressButton.
    /// The activity indicator is always displayed in the center of the
    ///  button if no progress text is provided else indicator is placed at the center.
    /// - Since: 3.0.0
    @IBInspectable
    open var isActivityIndicatorVisible: Bool = false {
        didSet {
            if isActivityIndicatorVisible {
                if overlayProgressView == nil {
                    createOverlayProgressView()
                    configuration.configureProgressTitle(of: self)
                }
                overlayProgressView?.startAnimating()
            } else {
                overlayProgressView?.stopAnimating()
                overlayProgressView?.removeFromSuperview()
                overlayProgressView = nil
            }
            isEnabled = !isActivityIndicatorVisible
            titleLabel?.layer.setTransformToHide(willHide: isActivityIndicatorVisible)
            imageView?.layer.setTransformToHide(willHide: isActivityIndicatorVisible)
        }
    }
    
    /// Updates the 'determinate' progressIndicator progress when the progressIndicatorStyle == .determinate
    /// Pass a float number between 0.0 and 1.0 which will equivalent to 0% - 100%.
    /// - Since: 3.0.0
    open var progress: CGFloat = 0.0 {
        didSet {
            progress = CGFloat(min(1.0, max(0.0, Double(progress))))
            if let overlayProgressView = overlayProgressView {
                overlayProgressView.activityIndicator.progress = progress
            }
        }
    }
    
    var overlayProgressView: ButtonOverlayProgressView?
    var progressViewWidthLayoutConstraint: NSLayoutConstraint?
    
    private func createOverlayProgressView() {
        let overlayProgressView = ButtonOverlayProgressView.makePreparedForAutoLayout()
        overlayProgressView.title = progressTitle
        overlayProgressView.activityIndicator.progressIndicatorStyle = progressIndicatorStyle
        overlayProgressView.activityIndicator.progress = progress
        addSubview(overlayProgressView)
        overlayProgressView.constrainCenterToParent()
        let widthConstraint = NSLayoutConstraint(item: overlayProgressView,
                                                 attribute: .width,
                                                 relatedBy: .lessThanOrEqual,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1,
                                                 constant: bounds.size.width)
        overlayProgressView.addConstraint(widthConstraint)
        progressViewWidthLayoutConstraint = widthConstraint
        self.overlayProgressView = overlayProgressView
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        progressViewWidthLayoutConstraint?.constant = bounds.size.width
    }
}

extension CALayer {
    func setTransformToHide(willHide: Bool) {
        transform = willHide ? CATransform3DMakeScale(0.0, 0.0, 0.1) : CATransform3DIdentity
    }
}
