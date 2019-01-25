/** © Koninklijke Philips N.V., 2016. All rights reserved. */

@objcMembers class InDeterminateLinearProgressView: UIView {
    var color: UIColor?
    
    init(frame: CGRect, color: UIColor?) {
        super.init(frame: frame)
        self.color = color
        instanceInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        instanceInit()
    }
    
    private func instanceInit() {
        self.layer.masksToBounds = true
        configureGradientLayer()
    }
    
    func configureGradientLayer() {
        if let startColor = color {
            let endColor = startColor.withAlphaComponent(0)
            let halfWidth = self.bounds.size.width / 2
            
            // Right
            var configuration = LinearProgressIndicatorConfiguration(startColor: startColor,
                                                                     endColor: endColor,
                                                                     bounds: self.frame,
                                                                     originX: halfWidth)
            let rightGradientLayer = CAGradientLayer(configuration: configuration)
            self.layer.addSublayer(rightGradientLayer)
            
            //Left
            configuration = LinearProgressIndicatorConfiguration(startColor: endColor,
                                                                 endColor: startColor,
                                                                 bounds: self.frame,
                                                                 originX: halfWidth - configuration.animatingViewWidth)
            let leftGradientLayer = CAGradientLayer(configuration: configuration)
            self.layer.addSublayer(leftGradientLayer)
        }
    }
}

private extension CAGradientLayer {
    convenience init(configuration: LinearProgressIndicatorConfiguration) {
        self.init()
        self.colors = [configuration.startColor.cgColor, configuration.endColor.cgColor]
        self.startPoint = configuration.startPoint
        self.endPoint = configuration.endPoint
        self.frame = configuration.progressViewBounds
    }
}

private struct LinearProgressIndicatorConfiguration {
    let startColor: UIColor
    let endColor: UIColor
    let progressViewBounds: CGRect
    let animatingViewWidth: CGFloat
    let startPoint = CGPoint(x: 0.0, y: 0.5)
    let endPoint = CGPoint(x: 1.0, y: 0.5)
    
    init(startColor: UIColor, endColor: UIColor, bounds: CGRect, originX: CGFloat) {
        self.startColor = startColor
        self.endColor = endColor
        self.animatingViewWidth = bounds.size.width * 0.2
        self.progressViewBounds = CGRect(x: originX,
                                         y: bounds.size.height / 2 - UIDProgressIndicatorHeight / 2,
                                         width: self.animatingViewWidth,
                                         height: UIDProgressIndicatorHeight)
    }
}
