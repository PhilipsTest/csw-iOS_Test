/** © Koninklijke Philips N.V., 2016. All rights reserved. */

extension UIDProgressIndicator {
    
    func drawDeterminateCircularProgressIndicator(_ rect: CGRect) {
        if progressShapeLayer == nil {
            let offColor = theme?.trackDetailOffBackground
            let minSize = min(rect.size.width, rect.size.height)
            let strokeWidth = self.circularProgressIndicatorSize.strokeWidth
            
            var configuration: CircularProgressIndicatorConfiguration?
            if let offColor = offColor {
                configuration = CircularProgressIndicatorConfiguration(lineWidth: strokeWidth,
                                                                       strokeColor: offColor,
                                                                       size: minSize)
            }
            
            if var configuration = configuration {
                backgroundShapeLayer = CAShapeLayer(configuration)
                if let backgroundShapeLayer = backgroundShapeLayer {
                    layer.addSublayer(backgroundShapeLayer)
                }
                
                let onColor = theme?.trackDetailOnBackground
                if let onColor = onColor {
                    configuration.strokeColor = onColor.cgColor
                }
                
                progressShapeLayer = CAShapeLayer(configuration)
                if let progressShapeLayer = progressShapeLayer {
                    layer.addSublayer(progressShapeLayer)
                }
            }
        }
        progressShapeLayer?.strokeStart = progress
        progressShapeLayer?.strokeEnd = 1
    }
}
