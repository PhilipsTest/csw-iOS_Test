/** © Koninklijke Philips N.V., 2016. All rights reserved. */

import Foundation

/**
 * A UIColor extension for mapping hexadecimal values to UIColors.
 * Code is taken from http://stackoverflow.com/questions/1560081/how-can-i-create-a-uicolor-from-a-hex-string. It says:
 * "I've got a solution that is 100% compatible with the hex format strings used by Android, which I found very helpful
 * when doing cross-platform mobile development. It lets me use one color palate for both platforms. Feel free to reuse
 * without attribution, or under the Apache license if you prefer."
 *
 * - Since: 3.0.0
 */
extension UIColor {
    
    /**
     * Get UIColor based on HexString.
     * @param hexString which will convert into UIColor.
     * @note How to use: UIColor.color(hexString: "#0a0c1e")
     * The string can have the following formats:
     * - `#RGB`
     * - `#ARGB`
     * - `#RRGGBB`
     * - `#AARRGGBB`
     *
     * - Since: 3.0.0
     */
   @objc public class func color(hexString: String) -> UIColor {
    let colorString: String = hexString.replacingOccurrences(of: "#", with: "")
        var alpha: CGFloat
        var red: CGFloat
        var blue: CGFloat
        var green: CGFloat
        switch colorString.count {
        case 3:
            // #RGB
            alpha = 1.0
            red = self.colorComponentFrom(string: colorString, start: 0, length: 1)
            green = self.colorComponentFrom(string: colorString, start: 1, length: 1)
            blue = self.colorComponentFrom(string: colorString, start: 2, length: 1)
        case 4:
            // #ARGB
            alpha = self.colorComponentFrom(string: colorString, start: 0, length: 1)
            red = self.colorComponentFrom(string: colorString, start: 1, length: 1)
            green = self.colorComponentFrom(string: colorString, start: 2, length: 1)
            blue = self.colorComponentFrom(string: colorString, start: 3, length: 1)
        case 6:
            // #RRGGBB
            alpha = 1.0
            red = self.colorComponentFrom(string: colorString, start: 0, length: 2)
            green = self.colorComponentFrom(string: colorString, start: 2, length: 2)
            blue = self.colorComponentFrom(string: colorString, start: 4, length: 2)
        case 8:
            // #AARRGGBB
            alpha = self.colorComponentFrom(string: colorString, start: 0, length: 2)
            red = self.colorComponentFrom(string: colorString, start: 2, length: 2)
            green = self.colorComponentFrom(string: colorString, start: 4, length: 2)
            blue = self.colorComponentFrom(string: colorString, start: 6, length: 2)
        default:
            return UIColor.clear
        }
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    private class func colorComponentFrom(string: String, start: Int, length: Int) -> CGFloat {
        let range = string.range(of: string)!
        let startIndex = string.index(range.lowerBound, offsetBy: start)
        let endIndex = string.index(range.lowerBound, offsetBy: start+length)
        let substring = (string[startIndex..<endIndex])
        let fullHex: String = length == 2 ? String(substring) : "\(substring)\(substring)"
        var hexComponent: UInt32 = 0
        Scanner(string: fullHex).scanHexInt32(&hexComponent)
        return CGFloat(hexComponent) / 255.0
    }
    
    // swiftlint:disable large_tuple
    /**
     * A UIColor extension to get Red,Green,Blue,Alpha values form UIColor.
     *
     * - Since: 3.0.0
     */
   public func toRGBA() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }
}
