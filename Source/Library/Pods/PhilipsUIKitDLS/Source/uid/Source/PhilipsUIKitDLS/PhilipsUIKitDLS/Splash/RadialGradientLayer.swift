/* Copyright (c) Koninklijke Philips Electronics N.V. 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class RadialGradientLayer: CALayer {
    
    var center: CGPoint {
        return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
    
    var radius: CGFloat {
        return max(bounds.width, bounds.height) / 2
    }
    
    var colors: [UIColor] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var cgColors: [CGColor] {
        return colors.map { $0.cgColor }
    }
    
    override init() {
        super.init()
        instanceInit()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        instanceInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
    }
    
    func instanceInit() {
        needsDisplayOnBoundsChange = true
    }
    
    override func draw(in ctx: CGContext) {
        ctx.saveGState()
        ctx.setBlendMode(.overlay)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations: [CGFloat] = [0.0, 1.0]
        guard let backGroundGradient = CGGradient(colorsSpace: colorSpace,
                                                  colors: cgColors as CFArray, locations: locations),
        let radientGradient = CGGradient(colorsSpace: colorSpace,
                                         colors: [backgroundColor ?? UIColor.clear.cgColor] as CFArray, locations: locations)
        else { return }

        ctx.drawRadialGradient(backGroundGradient, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: radius, options: CGGradientDrawingOptions(rawValue: 0))
        ctx.drawRadialGradient(radientGradient, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: radius, options: CGGradientDrawingOptions(rawValue: 0))
    }
}
