/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

public extension UIDTheme {
    
    /**
     *  Utility method to find whether the given Color Range supports the given Accent Color Range
     *
     * - Parameter colorRange: The Color Range to be applied
     * - Parameter accentColorRange: The Accent Color Range against which validity will be checked
     *
     * - returns: Whether it is a valid Accent Color Range or not
     * - Since: 3.0.0
     */
    
   @objc public static func isValidAccent(for colorRange: UIDColorRange, with accentColorRange: UIDColorRange) -> Bool {
        var isValid = false
        let allSupportedAccentsForColor = UIDTheme.supportedAccentColors(for: colorRange)
        if allSupportedAccentsForColor.count > 0 {
            isValid = allSupportedAccentsForColor.contains(accentColorRange)
        }
        return isValid
    }
    
    /**
     *  Utility method to get list of supported Accent Color Ranges for a certain Color Range
     *
     * - Parameter colorRange: The Color Range whose supported Accent Color ranges is needed
     *
     * - returns: List of Supported Accent Color Ranges for the given Color Range
     * - Since: 3.0.0
     */
    
   public static func supportedAccentColors(for colorRange: UIDColorRange) -> [UIDColorRange] {
        var supportedColorRanges = [UIDColorRange]()
        switch colorRange {
        case .groupBlue:
            supportedColorRanges = [.purple, .pink, .orange, .green, .aqua]
        case .blue:
            supportedColorRanges = [.purple, .pink, .orange, .green, .aqua]
        case .aqua:
            supportedColorRanges = [.purple, .pink, .orange, .blue]
        case .green:
            supportedColorRanges = [.purple, .pink, .orange]
        case .orange:
            supportedColorRanges = [.purple, .aqua, .blue]
        case .pink:
            supportedColorRanges = [.purple, .orange]
        case .purple:
            supportedColorRanges = [.pink, .orange, .green, .aqua, .blue]
        case .gray:
            supportedColorRanges = [.purple, .pink, .orange, .green, .aqua, .blue, .groupBlue]
        default:
            break
        }
        
        return supportedColorRanges
    }
}

extension UIDTheme {

    static func defaultAccent(for colorRange: UIDColorRange) -> UIDColorRange? {
        return UIDTheme.supportedAccentColors(for: colorRange).first
    }
}
