/** © Koninklijke Philips N.V., 2016. All rights reserved. */

extension UIDProgressIndicator {
    
    func drawInDeterminateCircularProgressIndicator(_ rect: CGRect) {
        let animationDuration = self.circularProgressIndicatorSize.animationDuration
        if indeterminateGradientLayer == nil {
            let minSize = min(rect.size.width, rect.size.height)
            let strokeWidth = self.circularProgressIndicatorSize.strokeWidth
            let property = CircularProgressIndicatorConfiguration(lineWidth: strokeWidth,
                                                                  animationDuration: animationDuration,
                                                                  startColor: (theme?.trackDetailOnBackground)!,
                                                                  size: minSize)
            let gradientArcView = GradientArcView(rect, property: property)
            let gradientImageView = gradientArcView.toImageView()
            self.addSubview(gradientImageView)
            indeterminateGradientLayer = gradientImageView.layer
        }
        
        if let indeterminateGradientLayer = indeterminateGradientLayer {
            circularAnimation = CircularProgressIndicatorAnimation(animationDuration)
            circularAnimation?.performAnimation(withLayer: indeterminateGradientLayer, shouldAnimate: isAnimating)
        }
    }
}
