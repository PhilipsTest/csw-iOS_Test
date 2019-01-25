/* Copyright (c) Koninklijke Philips Electronics N.V. 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

/// Orientation type specifies phone or pad for which image should be
/// generated
/// - Since: 2017.5.0
@objc
public enum UIDSplashScreenOrientation: Int {
    /// - Since: 2017.5.0
    case portrait
    /// - Since: 2017.5.0
    case landscape
    /// - Since: 2017.5.0
    case all
}

public extension UIDSplashScreenOrientation {
    func orientationTransformed(size: CGSize) -> CGSize {
        var returnSize = size
        if self == .landscape {
            returnSize = CGSize(width: returnSize.height, height: returnSize.width)
        }
        return returnSize
    }
}

/// Platform type specifies phone or pad for which image should be 
/// generated
/// - Since: 2017.5.0
@objc
public enum UIDSplashScreenPlatform: Int {
    /// - Since: 2017.5.0
    case phone
    /// - Since: 2017.5.0
    case pad
    /// - Since: 2017.5.0
    case all
}

extension UIDSplashScreenPlatform {
    var screenSizes: [UIDSplashScreenSize] {
        switch self {
        case .phone:
            return [.phone480h, .phone568h, .phone667h, .phone736h, .phone812h]
        case .pad:
            return [.pad, .padRetina]
        case .all:
            return [.phone480h, .phone568h, .phone667h, .phone736h, .phone812h, .pad, .padRetina]
        }
    }
}

/// SplashScreen sizes for various available sizes
/// - Since: 2017.5.0
@objc
public enum UIDSplashScreenSize: Int {
    /// 480h is iphone4. i.e (320x480).
    /// - Since: 2017.5.0
    case phone480h
    /// 568h is iphone5. i.e (320x568).
    /// - Since: 2017.5.0
    case phone568h
    /// 667h is iphone 6, 6s, 7, 7s, 8, 8s.
    /// - Since: 2017.5.0
    case phone667h
    /// 736h is iphone 6+, 7+, 8+.
    /// - Since: 2017.5.0
    case phone736h
    /// 812h is iphone X.
    /// - Since: 2017.5.0
    case phone812h
    /// pad is normal ipad.
    /// - Since: 2017.5.0
    case pad
    /// padRetina is retina ipad
    /// - Since: 2017.5.0
    case padRetina
    /// unknown providence devices.
    /// - Since: 2017.5.0
    case other
}

extension UIDSplashScreenSize {
    var platformType: UIDSplashScreenPlatform {
        switch self {
        case .phone480h, .phone568h, .phone667h, .phone736h, .phone812h:
            return .phone
        default:
            return .pad
        }
    }
    
    var scaleOfScreen: CGFloat {
        switch self {
        case .phone480h, .phone568h, .phone667h:
            return 2.0
        case .phone736h, .phone812h:
            return 3.0
        case .pad:
            return 1.0
        case .padRetina:
            return 2.0
        default:
            return 1.0
        }
    }
    
    var sizeOfScreen: CGSize {
        var returnSize = CGSize.zero
        
        switch self {
        case .phone480h:
            returnSize = CGSize(width: 320, height: 480)
        case .phone568h:
            returnSize = CGSize(width: 320, height: 568)
        case .phone667h:
            returnSize = CGSize(width: 375, height: 667)
        case .phone736h:
            returnSize = CGSize(width: 414, height: 736)
        case .phone812h:
            returnSize = CGSize(width: 375, height: 812)
        case .pad, .padRetina:
            returnSize = CGSize(width: 768, height: 1024)
        default: break
        }
        return returnSize
    }
    
    func launchImageNameFor(orientation: UIDSplashScreenOrientation) -> String {
        guard var imageName = launchImagePrefix else { return "Invalid" }

        switch orientation {
        case .portrait:
            imageName += "-Portrait"
        case .landscape:
            imageName += "-Landscape"
        default:
            imageName = ""
        }
        
        return imageName
    }
    
    private var launchImagePrefix: String? {
        switch self {
        case .phone480h:
            return "Default@2x"
        case .phone568h:
            return "Default-568h@2x"
        case .phone667h:
            return "Default-667h@2x"
        case .phone736h:
            return "Default-736h@3x"
        case .phone812h:
            return "Default-812h@3x"
        case .pad:
            return "Default-iPad"
        case .padRetina:
            return "Default-iPad@2x"
        default:
            return nil
        }
    }
}
