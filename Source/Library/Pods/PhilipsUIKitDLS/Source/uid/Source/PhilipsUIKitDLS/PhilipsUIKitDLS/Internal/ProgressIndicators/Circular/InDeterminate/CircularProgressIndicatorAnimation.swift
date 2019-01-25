/** © Koninklijke Philips N.V., 2016. All rights reserved. */

struct CircularProgressIndicatorAnimation {
    private let antiClockWise = LayoutDirection.isRightToLeft ? -1 : 1 // -1 for Anti ClockWise, Use 1 for ClockWise
    private var animationDuration = 1.0
    
    init(_ animationDuration: TimeInterval) {
        self.animationDuration = animationDuration
    }
    
    func performAnimation(withLayer layer: CALayer, shouldAnimate: Bool) {
        if shouldAnimate {
            startAnimating(layer)
        } else {
            stopAnimating(layer)
        }
    }
    
    func startAnimating(_ layer: CALayer) {
        layer.add(transformRotationZ, forKey: "rotate")
    }
    
    func stopAnimating(_ layer: CALayer) {
        layer.removeAllAnimations()
    }
    
    var transformRotationZ: CABasicAnimation {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.duration = animationDuration
        animation.repeatCount = Float.infinity
        animation.fromValue = NSNumber(value: 0.0)
        animation.toValue = NSNumber(value: Float(antiClockWise) * Float(UIDTwoMPi))
        return animation
    }
}
