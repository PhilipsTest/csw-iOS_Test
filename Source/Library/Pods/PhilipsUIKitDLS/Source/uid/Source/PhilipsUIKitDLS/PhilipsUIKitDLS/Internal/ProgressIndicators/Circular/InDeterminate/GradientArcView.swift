/** © Koninklijke Philips N.V., 2016. All rights reserved. */

@objcMembers class GradientArcView: UIView {
    var property: CircularProgressIndicatorConfiguration?
    
    init(_ rect: CGRect, property: CircularProgressIndicatorConfiguration) {
        super.init(frame: rect)
        self.property = property
        instanceInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        instanceInit()
    }
    
    private func instanceInit() {
        self.backgroundColor = UIColor.clear
        self.layer.masksToBounds = true
    }
    
    override func draw(_ rect: CGRect) {
        guard let property = property else {
            return
        }
        
        let maxRatioFactor: CGFloat = 1.0
        let incrementRatioFactor: CGFloat = 0.001
        var currentAngle: CGFloat = 0.0
        var currentRatio: CGFloat = 0.0
        
        while currentRatio <= maxRatioFactor {
            let arcStartAngle: CGFloat = -CGFloat(Double.pi / 2)
            let arcEndAngle: CGFloat = currentRatio * UIDTwoMPi + arcStartAngle
            currentAngle = currentAngle == 0.0 ? arcStartAngle : arcEndAngle - 0.01
            
            let arc = UIBezierPath(arcCenter: property.center,
                                   radius: property.radius,
                                   startAngle: currentAngle,
                                   endAngle: arcEndAngle,
                                   clockwise: true)
            let strokeColor = gradientColor(currentRatio,
                                            startColor: property.startColor,
                                            endColor: property.endColor)
            strokeColor.setStroke()
            arc.lineWidth = property.lineWidth
            arc.stroke()
            currentRatio += incrementRatioFactor
        }
    }
    
    private func gradientColor(_ ratio: CGFloat, startColor: UIColor, endColor: UIColor) -> UIColor {
        let startColor = startColor.toRGBA()
        let endColor = endColor.toRGBA()
        let alpha = (startColor.alpha - endColor.alpha) * ratio + endColor.alpha
        
        return UIColor(red: startColor.red, green: startColor.green, blue: startColor.blue, alpha: alpha)
    }
}
