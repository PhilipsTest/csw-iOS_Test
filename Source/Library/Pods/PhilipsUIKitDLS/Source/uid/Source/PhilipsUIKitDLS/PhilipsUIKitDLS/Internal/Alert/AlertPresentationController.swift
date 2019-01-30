/** © Koninklijke Philips N.V., 2016. All rights reserved. */

import UIKit

class AlertPresentationController: UIPresentationController {
    var theme: UIDTheme? = UIDThemeManager.sharedInstance.defaultTheme {
        didSet {
            backgroundView.backgroundColor = theme?.dimLayerStrongBackground
        }
    }

    lazy var backgroundView: UIView  = {
        let view = UIView.makePreparedForAutoLayout()
        view.backgroundColor = self.theme?.dimLayerStrongBackground
        view.alpha = 0.0
        return view
    }()
    
    override var shouldPresentInFullscreen: Bool {
        return false
    }

    override var shouldRemovePresentersView: Bool {
        return false
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        containerView?.insertSubview(backgroundView, at: 0)
        
        let bindingInfo: [String: UIView] = ["backgroundView": backgroundView]
        containerView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[backgroundView]|",
                                                                     options: [],
                                                                     metrics: nil,
                                                                     views: bindingInfo))
        containerView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundView]|",
                                                                     options: [],
                                                                     metrics: nil,
                                                                     views: bindingInfo))
        
        let closure = { self.backgroundView.alpha = 1.0 }
        guard let coordinator = presentedViewController.transitionCoordinator else {
            closure()
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in closure() })
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        let closure = { self.backgroundView.alpha = 0.0 }

        guard let coordinator = presentedViewController.transitionCoordinator else {
            closure()
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in closure() })
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        backgroundView.frame = containerView?.bounds ?? .zero
    }
}
