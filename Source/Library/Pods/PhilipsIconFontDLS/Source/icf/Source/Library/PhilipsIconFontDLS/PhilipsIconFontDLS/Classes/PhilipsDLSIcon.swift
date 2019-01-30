/* Copyright (c) Koninklijke Philips Electronics N.V. 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

/**
 *  The types of Philips Icon that are available inside PhilipsIconFont.ttf file.
 *
 * - Since: 3.0.0
 */
@objc
public enum PhilipsDLSIconType :Int {
    /// - Since: 3.0.0
    case star = 0xF001
    /// - Since: 3.0.0
    case warning = 0xF002
    /// - Since: 3.0.0
    case balloonSpeech = 0xF003
    /// - Since: 3.0.0
    case capture = 0xF004
    /// - Since: 3.0.0
    case checkMarkXBold24 = 0xF005
    /// - Since: 3.0.0
    case checkMarkXBold32 = 0xF006
    /// - Since: 3.0.0
    case checkMarkXBold = 0xF007
    /// - Since: 3.0.0
    case circlePlay = 0xF008
    /// - Since: 3.0.0
    case conversationSpeech = 0xF009
    /// - Since: 3.0.0
    case exclamationMark24 = 0xF00A
    /// - Since: 3.0.0
    case exclamationMark32 = 0xF00B
    /// - Since: 3.0.0
    case exclamationMark = 0xF00C
    /// - Since: 3.0.0
    case information = 0xF00D
    /// - Since: 3.0.0
    case linkExternal32 = 0xF00E
    /// - Since: 3.0.0
    case linkExternal = 0xF00F
    /// - Since: 3.0.0
    case location = 0xF010
    /// - Since: 3.0.0
    case message32 = 0xF011
    /// - Since: 3.0.0
    case message = 0xF012
    /// - Since: 3.0.0
    case questionMark24 = 0xF013
    /// - Since: 3.0.0
    case questionMark32 = 0xF014
    /// - Since: 3.0.0
    case questionMark = 0xF015
    /// - Since: 3.0.0
    case revise = 0xF016
    /// - Since: 3.0.0
    case socialMediaFacebook = 0xF017
    /// - Since: 3.0.0
    case socialMediaGooglePlus = 0xF018
    /// - Since: 3.0.0
    case socialMediaTwitter = 0xF019
    /// - Since: 3.0.0
    case startAction = 0xF01A
    /// - Since: 3.0.0
    case userStart = 0xF01B
    /// - Since: 3.0.0
    case checkCircle = 0xF01C
    /// - Since: 3.0.0
    case shield = 0xF01D
    /// - Since: 3.0.0
    case cross24 = 0xF01E
    /// - Since: 3.0.0
    case cross32 = 0xF01F
    /// - Since: 3.0.0
    case crossBold24 = 0xF020
    /// - Since: 3.0.0
    case crossBold32 = 0xF021
    /// - Since: 3.0.0
    case crossBold = 0xF022
    /// - Since: 3.0.0
    case cross = 0xF023
    /// - Since: 3.0.0
    case navigationLeft24 = 0xF024
    /// - Since: 3.0.0
    case navigationLeftLight24 = 0xF025
    /// - Since: 3.0.0
    case navigationLeftLight32 = 0xF026
    /// - Since: 3.0.0
    case navigationLeftLight = 0xF027
    /// - Since: 3.0.0
    case navigationLeft = 0xF028
    /// - Since: 3.0.0
    case navigationRight24 = 0xF029
    /// - Since: 3.0.0
    case navigationRight32 = 0xF02A
    /// - Since: 3.0.0
    case navigationRightLight24 = 0xF02B
    /// - Since: 3.0.0
    case navigationRightLight32 = 0xF02C
    /// - Since: 3.0.0
    case navigationRightLight = 0xF02D
    /// - Since: 3.0.0
    case navigationRight = 0xF02E
    /// - Since: 3.0.0
    case exclamationCircle = 0xF02F
    /// - Since: 3.0.0
    case infoCircle = 0xF030
    /// - Since: 2017.5.0
    case calendar = 0xF031
    /// - Since: 2017.5.0
    case checkMark24 = 0xF032
    /// - Since: 2017.5.0
    case edit = 0xF033
    /// - Since: 2017.5.0
    case listView = 0xF034
    /// - Since: 2017.5.0
    case navigationRightBold24 = 0xF035
    /// - Since: 2017.5.0
    case personPortrait = 0xF036
    /// - Since: 2017.5.0
    case search = 0xF037
    /// - Since: 2017.5.0
    case threeDotsHorizontal = 0xF038
    /// - Since: 2017.5.0
    case threeDotsVertical = 0xF039
    /// - Since: 2017.5.0
    case passwordShow = 0xF03A
    /// - Since: 2017.5.0
    case passwordHide = 0xF03B
    /// - Since: 1805.0.0
    case navigationDown = 0xF03C
    /// - Since: 1805.0.0
    case navigationUp = 0xF03D
    /// - Since: 1805.0.0
    case refresh = 0xF03E
    /// - Since: 1805.0.0
    case wifiConnection = 0xF03F
    /// - Since: 1805.0.0
    case signalStrength1 = 0xF040
    /// - Since: 1805.0.0
    case signalStrength2 = 0xF041
    /// - Since: 1805.0.0
    case signalStrength3 = 0xF042
}

public enum PUILegacyIconType :Int {
    /// - Since: 3.0.0
    case star = 0xF001
}

/**
 *  Get an icon unichar from the Philips Icon Font by PhilipsDLSIcon.unicode(iconType: .close) for example.
 *  Make sure that the label you want the icon to appear has the icon font: UIFont.iconFont(size: x)
 *
 * - Since: 3.0.0
 */
public final class PhilipsDLSIcon: NSObject {
    /// - Since: 3.0.0
   @objc public class func unicode(iconType: PhilipsDLSIconType) -> String {
        return String(format: "%C", unichar(iconType.rawValue))
    }
}
