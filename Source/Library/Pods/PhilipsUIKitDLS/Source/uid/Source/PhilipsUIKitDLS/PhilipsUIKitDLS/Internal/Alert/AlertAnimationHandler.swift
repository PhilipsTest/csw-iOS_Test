/** © Koninklijke Philips N.V., 2016. All rights reserved. */

import UIKit

let alertBackgroundAnimationDuration: TimeInterval = 0.2

class AlertAnimationHandler: NSObject, UIViewControllerAnimatedTransitioning {
    var layoutAppearing: Bool = false

   @objc public convenience init(layoutAppearing isAppearing: Bool) {
        self.init()
        layoutAppearing = isAppearing
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let key = layoutAppearing ? UITransitionContextViewControllerKey.to : UITransitionContextViewControllerKey.from
        guard let controller = transitionContext.viewController(forKey: key) else {
            return
        }

        controller.view.layer.opacity =  0.0

        if layoutAppearing {
            transitionContext.containerView.addSubview(controller.view)
        }

        let presentedFrame = transitionContext.finalFrame(for: controller)
        let animationDuration = transitionDuration(using: transitionContext)

        controller.view.frame = presentedFrame
        UIView.animate(withDuration: animationDuration, animations: {
            controller.view.alpha = 1
            controller.view.layer.opacity =  self.layoutAppearing ? 1.0 : 0.0
        }) { finished in
            transitionContext.completeTransition(finished)
        }
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return alertBackgroundAnimationDuration
    }
}
