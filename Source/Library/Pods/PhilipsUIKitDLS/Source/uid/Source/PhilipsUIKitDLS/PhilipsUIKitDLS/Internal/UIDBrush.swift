//  Copyright © 2016 Philips. All rights reserved.

import Foundation
import UIKit

extension UIDColorLevel {
    func level(withOffset offset: Int) -> UIDColorLevel? {
        return UIDColorLevel(rawValue: rawValue + offset)
    }
}

/// - Since: 3.0.0
public struct UIDBrushComponents {
    var colorLevel: UIDColorLevel?
    var offset: Int = 0
    var alpha: CGFloat = 1
    
    init(colorLevel: UIDColorLevel? = nil, offset: Int = 0, alpha: CGFloat = 1) {
        self.colorLevel = colorLevel
        self.offset = offset
        self.alpha = alpha
    }
}

/// - Since: 3.0.0
public struct UIDBrush {
    var colorLevel: UIDColorLevel
    var alpha: CGFloat = 1
    var offset: Int
    var fixedColorRange: UIDColorRange?
    var hexColorString: String?
    
    init(colorLevel: UIDColorLevel, fixedColorRange: UIDColorRange? = nil, alpha: CGFloat = 1, offset: Int = 0) {
        self.colorLevel = colorLevel
        self.fixedColorRange = fixedColorRange
        self.alpha = alpha
        self.offset = offset
    }
    
    init(brush: UIDBrush? = nil, components: UIDBrushComponents) {
        if let brush = brush {
            self.colorLevel = brush.colorLevel
            self.fixedColorRange = brush.fixedColorRange
            self.alpha = components.alpha == 1 ? brush.alpha : components.alpha
            self.offset = brush.offset + components.offset
            self.hexColorString = brush.hexColorString
        }
        
        if let colorLevel = brush?.colorLevel {
            self.colorLevel = colorLevel
        } else {
            self.colorLevel = components.colorLevel!
        }
        
        if let offset = brush?.offset {
            self.offset = offset
        } else {
            self.offset = components.offset
        }
        
        self.alpha = components.alpha == 1 ? self.alpha : components.alpha
        self.fixedColorRange = self.fixedColorRange ?? nil
    }
    
    init(fixedColorRange: UIDColorRange, components: UIDBrushComponents) {
        self.fixedColorRange = fixedColorRange
        self.colorLevel = components.colorLevel ?? .color0
        self.offset = 0
        self.alpha = 1
    }
    
    init(brush: UIDBrush, alpha: CGFloat = 1, offset: Int = 0) {
        self.colorLevel = brush.colorLevel
        self.fixedColorRange = brush.fixedColorRange
        self.alpha = alpha == 1 ? brush.alpha : alpha
        self.offset = brush.offset + offset
        self.hexColorString = brush.hexColorString
    }
    
    init(hexColorStr: String, alpha: CGFloat = 1) {
        self.hexColorString = hexColorStr
        self.colorLevel = .color0
        self.offset = 0
        self.alpha = alpha
        fixedColorRange = nil
    }
    
    init() {
        self.init(colorLevel:.color0)
    }
    
    func color(in colorRange: UIDColorRange) -> UIColor? {
        if let hexColorString = hexColorString {
            return UIColor.color(hexString: hexColorString).withAlphaComponent(alpha)
        }
        
        guard let resultingLevel = colorLevel.level(withOffset: offset) else {
            return nil
        }
        let range = fixedColorRange ?? colorRange
        return UIColor.color(range: range, level: resultingLevel)?.withAlphaComponent(alpha)
    }
    
    func colorFromHex() -> UIColor? {
        guard  let hexColorString = self.hexColorString else {
            return nil
        }
        return UIColor.color(hexString: hexColorString)
    }
}
