/** © Koninklijke Philips N.V., 2016. All rights reserved. */

extension UIDProgressIndicator {
    
    private var animationDuration: TimeInterval {
        return 0.9
    }
    
    func drawInDeterminateLinearProgressIndicator(_ rect: CGRect) {
        // Progress Bar Track
        if let context = UIGraphicsGetCurrentContext() {
            context.saveGState()
            context.setLineWidth(self.intrinsicContentSize.height)
            if let strokeColor = (theme?.trackDetailOffBackground?.cgColor) {
                context.setStrokeColor(strokeColor)
            }
            context.beginPath()
            context.move(to: CGPoint(x: 0, y: rect.size.height/2))
            context.addLine(to: CGPoint(x: rect.size.width, y: rect.size.height/2))
            context.strokePath()
            context.restoreGState()
        }
        //Animating Progress Bar
        removeAllSubviews()
        if isAnimating {
            self.animateInDeterminateLinearProgressView()
        }
    }
    
    private func animateInDeterminateLinearProgressView() {
        let fillColor = theme?.trackDetailOnBackground
        let progressLeadingView = progressImageView(color: fillColor)
        let progressTrailingView = progressImageView(color: fillColor)
        self.addSubview(progressLeadingView)
        self.addSubview(progressTrailingView)
        self.startProgressViewAnimation(leadingView: progressLeadingView, trailingView: progressTrailingView)
    }
    
    private func progressImageView(color: UIColor?) -> UIView {
        let progressView = InDeterminateLinearProgressView(frame: self.bounds, color: color)
        return progressView.toImageView()
    }
    
    private func startProgressViewAnimation(leadingView: UIView, trailingView: UIView) {
        self.animateProgressLeadingView(leadingView, trailingView: trailingView)
        self.animateProgressTrailingView(trailingView)
    }
    
    private func animateProgressLeadingView(_ leadingView: UIView, trailingView: UIView) {
        UIView.animate(withDuration: self.animationDuration, delay: 0.0, options: .curveLinear, animations: {
            var frame = leadingView.frame
            frame.origin.x = LayoutDirection.isRightToLeft ? 0 : leadingView.frame.width
            leadingView.frame = frame
        }) { (finished) in
            var frame = leadingView.frame
            frame.origin.x = LayoutDirection.isRightToLeft ? leadingView.frame.width : 0
            leadingView.frame = frame
            if finished {
                self.startProgressViewAnimation(leadingView: leadingView, trailingView: trailingView)
            }
        }
    }
    
    private func animateProgressTrailingView(_ trailingView: UIView) {
        var frame = trailingView.frame
        frame.origin.x = LayoutDirection.isRightToLeft ? 0 : -trailingView.frame.width
        trailingView.frame = frame
        UIView.animate(withDuration: self.animationDuration, delay: 0.0, options: .curveLinear, animations: {
            var frame = trailingView.frame
            frame.origin.x = LayoutDirection.isRightToLeft ? -trailingView.frame.width : 0
            trailingView.frame = frame
        })
    }
}
