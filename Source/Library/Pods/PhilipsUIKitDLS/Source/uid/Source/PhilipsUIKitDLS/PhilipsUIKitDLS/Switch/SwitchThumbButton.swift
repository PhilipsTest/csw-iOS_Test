//  Copyright (c) 2015 Koninklijke Philips N.V. All rights reserved.

import UIKit

fileprivate let thumbSize = CGSize(width: 24, height: 24)
fileprivate let highlightedThumbRadius: CGFloat = 20

class SwitchThumbButton: UIButton {
    var theme = UIDThemeManager.sharedInstance.defaultTheme

    let highlightedThumbLayer = CAShapeLayer()
    let thumbLayer = CAShapeLayer()
    
    func configure() {
        self.backgroundColor = UIColor.clear
        if let theme = theme {
            apply(dropShadow: UIDDropShadow(level: .level1, theme: theme))
        }
        translatesAutoresizingMaskIntoConstraints = false
        constrain(toSize: thumbSize)
        constrainVerticallyCenteredToParent()
        cornerRadius = min(thumbSize.width, thumbSize.height) * 0.5
        setupThumbLayer()
        setupHighlightedThumbLayer()
    }
    
    private func setupThumbLayer() {
        let rect = CGRect(origin: .zero, size: thumbSize)
        let path = UIBezierPath(roundedRect:rect, cornerRadius: thumbSize.width * 0.5)
        thumbLayer.path = path.cgPath
        thumbLayer.strokeColor = UIColor.clear.cgColor
        thumbLayer.borderColor = UIColor.clear.cgColor
        thumbLayer.shadowColor = UIColor.clear.cgColor
        thumbLayer.lineWidth = 0
        layer.insertSublayer(thumbLayer, below: layer)
        thumbLayer.borderWidth = 0
    }

    private func setupHighlightedThumbLayer() {
        let highLightedThumbDiameter = highlightedThumbRadius * 2
        let offsetValue = (frame.width - highLightedThumbDiameter) * 0.5
        let highlightedBounds = CGRect(origin: .zero,
                size: CGSize(width: highLightedThumbDiameter, height: highLightedThumbDiameter))
        let highlightedRect = highlightedBounds.offsetBy(dx: offsetValue*0.20, dy: offsetValue*0.20)
        let path = UIBezierPath(roundedRect: highlightedRect, cornerRadius: highlightedThumbRadius)
        highlightedThumbLayer.path = path.cgPath
        highlightedThumbLayer.frame = highlightedRect
        highlightedThumbLayer.opacity = 0.0
        highlightedThumbLayer.strokeColor = UIColor.clear.cgColor
        highlightedThumbLayer.lineWidth = 0
        layer.insertSublayer(highlightedThumbLayer, below: thumbLayer)
    }

    func highlightThumbAnimationToAppear(_ appear: Bool) {
        highlightedThumbLayer.animateByOpacityToAppear(appear)
    }
}
