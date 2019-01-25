/* Copyright (c) Koninklijke Philips Electronics N.V. 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UIKit

 public extension UIFont {
    private static let dlsIconFontName = "iconfont"
    
    /**
     *  Get Philips Icon Font.
     *
     *  - Since: 3.0.0
     */
   @objc public class func iconFont(size: CGFloat) -> UIFont? {
        guard let font = UIFont(name: dlsIconFontName, size: size) else {
            loadIconFont()
            return UIFont(name: dlsIconFontName, size: size)
        }
        return font
    }
    
    private class func loadIconFont() {
        guard let fontPath = Bundle(for: PhilipsDLSIcon.self).path(forResource: dlsIconFontName, ofType: "ttf") else {
            return
        }
        if let fontData = NSData(contentsOfFile:fontPath) {
            loadFont(fontData: fontData)
        }
    }
    
    private class func loadFont(fontData: NSData?) {
        if let fontData = fontData {
            let fontDataProvider = CGDataProvider(data: fontData)
            // http://stackoverflow.com/questions/24900979/cgfontcreatewithdataprovider-hangs-in-airplane-mode
            let _ = UIFont.familyNames
            if let fontDataProvider = fontDataProvider {
                if let font = CGFont(fontDataProvider){
                    CTFontManagerRegisterGraphicsFont(font, nil)
                }
            }
        }
    }
}
