/** © Koninklijke Philips N.V., 2016. All rights reserved. */

extension UIDProgressIndicator {
    
    func drawDeterminateLinearProgressIndicator(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            let height = frame.size.height
            let width = frame.size.width
            let currentProgress = (progress * width)
            
            context.saveGState()
            context.setLineWidth(self.intrinsicContentSize.height)
            
            // Progress Bar Track
            if let strokeColor = (theme?.trackDetailOffBackground?.cgColor) {
                context.setStrokeColor(strokeColor)
            }
            context.beginPath()
            context.move(to: CGPoint(x: 0, y: height/2))
            context.addLine(to: CGPoint(x: width, y: height/2))
            context.strokePath()
            
            // Progress Bar Fill
            if let strokeColor = (theme?.trackDetailOnBackground?.cgColor) {
                context.setStrokeColor(strokeColor)
            }
            
            let startX = LayoutDirection.isRightToLeft ? width : 0
            let endY =  LayoutDirection.isRightToLeft ? width - currentProgress : currentProgress
            
            context.beginPath()
            context.move(to: CGPoint(x: startX, y: height/2))
            context.addLine(to: CGPoint(x: endY, y: height/2))
            context.strokePath()
            
            context.restoreGState()
        }
    }
}
