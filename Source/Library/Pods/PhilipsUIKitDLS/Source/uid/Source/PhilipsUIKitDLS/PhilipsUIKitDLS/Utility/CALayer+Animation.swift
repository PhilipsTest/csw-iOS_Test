//  Copyright © 2016 Philips. All rights reserved.

import UIKit

extension CALayer {
    func animateByOpacityToAppear(_ appear: Bool) {
        let fromValue, toValue: CGFloat
        let animationKey: String
        
        if appear {
            fromValue = 0
            toValue = 1
            animationKey = "transformationIn"
        } else {
            fromValue = 1
            toValue = 0
            animationKey = "transformationOut"
        }
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = fromValue
        opacityAnimation.toValue = toValue
        opacityAnimation.duration = 0.2
        opacityAnimation.autoreverses = false
        opacityAnimation.repeatCount = 1
        opacityAnimation.isRemovedOnCompletion = false
        opacityAnimation.fillMode = "forwards"
        add(opacityAnimation, forKey: animationKey)
    }
}
