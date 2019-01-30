//  Copyright © 2016 Philips. All rights reserved.

import UIKit

/**
 *  The available fonts in the PhilipsUIKitDLS framework.
 * - Since: 3.0.0
 */
@objc public enum UIDFont: NSInteger {
    /**
     * Book font type
     * - Since: 3.0.0
     */
    case book
    
    /*
     * Bold font type
     * - Since: 3.0.0
     */
    case bold
    
    /*
     * Medium font type
     * - Since: 3.0.0
     */
    case medium
    
    /*
     * Light font type
     * - Since: 3.0.0
     */
    case light
}

extension UIDFont {
    func fontName() -> String {
        switch self {
        case .book: return "CentraleSansBook"
        case .bold: return "CentraleSansBold"
        case .medium: return "CentraleSansMedium"
        case .light: return "CentraleSansLight"
        }
    }
    
   static func loadAllFonts() {
        for fontType in 0...UIDFont.light.rawValue {
            if let fontName = UIDFont(rawValue: fontType)?.fontName() {
                loadFont(with: fontName)
            }
        }
    }
    
    private static func loadFont(with fontName: String) {
        let bundle = Bundle(for: UIDButton.self)
        if let fontPath = bundle.path(forResource: fontName, ofType: "ttf") {
            if let fontData = NSData(contentsOfFile:fontPath) {
                loadFont(with:fontData)
            }
        }
    }
    
    private static func loadFont(with data: NSData) {
        guard let fontProviderRef = CGDataProvider(data: data as CFData) else {
            return
        }
        let fontRef = CGFont(fontProviderRef)
        
        var registerError: Unmanaged<CFError>?
        var unRegisterError: Unmanaged<CFError>?
        CTFontManagerUnregisterGraphicsFont(fontRef!, &unRegisterError)
        CTFontManagerRegisterGraphicsFont(fontRef!, &registerError)
        registerError?.release()
        unRegisterError?.release()
    }
}

/**
 *  The Philips font category.
 */
extension UIFont {
    /**
     *  Get a Philips font
     *
     *  @param font UIDFont (like .book)
     *  @param size CGFloat
     *
     *  @return UIFont
     * - Since: 3.0.0
     */
   @objc public convenience init?(uidFont font: UIDFont, size: CGFloat) {
        self.init(name:font.fontName(), size:size)
    }
}
