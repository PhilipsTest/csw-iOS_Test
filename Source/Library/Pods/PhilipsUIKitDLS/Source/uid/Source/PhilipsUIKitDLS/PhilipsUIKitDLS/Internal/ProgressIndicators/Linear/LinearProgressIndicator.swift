/** © Koninklijke Philips N.V., 2016. All rights reserved. */

extension UIDProgressIndicator {
    
    func drawLinearProgressIndicator(_ rect: CGRect) {
        if self.progressIndicatorStyle == .determinate {
            drawDeterminateLinearProgressIndicator(rect)
        } else {
            drawInDeterminateLinearProgressIndicator(rect)
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if self.progressIndicatorStyle == .indeterminate,
            self.progressIndicatorType == .linear,
            self.bounds.height > 0, self.bounds.width > 0 {
                drawInDeterminateLinearProgressIndicator(self.bounds)
        }
    }
}
