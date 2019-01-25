/** © Koninklijke Philips N.V., 2016. All rights reserved. */

extension CAShapeLayer {
    /**
     * Get Circle Shape ARC by using circular ProgressIndicator configuration.
     */
    convenience init(_ property: CircularProgressIndicatorConfiguration) {
        self.init()
        let startAngle: CGFloat = 0.75 * UIDTwoMPi
        let endAngle: CGFloat = startAngle + UIDTwoMPi
        
        let circlePath = UIBezierPath(
            arcCenter: property.center, radius: property.radius,
            startAngle: startAngle, endAngle: endAngle,
            clockwise: true)
        
        self.path = circlePath.cgPath
        self.fillColor = UIColor.clear.cgColor
        self.lineWidth = property.lineWidth
        self.strokeColor = property.strokeColor
    }
}
