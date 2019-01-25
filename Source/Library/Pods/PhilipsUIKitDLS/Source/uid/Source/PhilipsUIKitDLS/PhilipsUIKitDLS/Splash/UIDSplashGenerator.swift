/* Copyright (c) Koninklijke Philips Electronics N.V. 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

/// - Since: 2017.5.0
public typealias UIDSplashProgressBlock = (_ totalImages: Int, _ processedImages: Int) -> Void

/// When image is provided as background, for various type of screen size combinations
/// the imagePath along with other relevant parameters should be set.
/// - Since: 2017.5.0
@objcMembers
open class UIDSplashImageInfo: NSObject {
    /// screen size of the image
    /// - Since: 2017.5.0
    let screenSize: UIDSplashScreenSize
    /// orientation of the splash image
    /// - Since: 2017.5.0
    let orientation: UIDSplashScreenOrientation
    /// image path of the splash image background.
    /// - Since: 2017.5.0
    let imagePath: String
    
    public init?(screenSize: UIDSplashScreenSize, orientation: UIDSplashScreenOrientation, imagePath: String) {
        self.screenSize = screenSize
        self.orientation = orientation
        self.imagePath = imagePath
    }
      
    open override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? UIDSplashImageInfo else {
            return false
        }
        
        return screenSize == object.screenSize &&
            orientation == object.orientation
    }
}

/// UIDSplashGenerator generates all the relevant images in document directory. The various
/// parameters should be preset.
/// - Since: 2017.5.0
@objcMembers
open class UIDSplashGenerator: NSObject {
    
    var totalImages = 0
    
    var processedImages = 0
    
    /// progressBlock gives the progress of the image generation. In terms of totalImages and 
    /// processedImages.
    /// - Since: 2017.5.0
    open var progressBlock: UIDSplashProgressBlock?
    
    /// Theme of the splash screen that has to be generated.
    /// - Since: 2017.5.0
    open var theme = UIDThemeManager.sharedInstance.defaultTheme
    
    /// The splashimageInfos should be added to this array before generating the images.
    /// - Since: 2017.5.0
    open var splashImageInfos: [UIDSplashImageInfo] = []
    
    
    /// Generates a single image depending on the parameters.
    ///
    /// - Parameters:
    ///   - splashScreenSize: Size of the splash screen.
    ///   - orientation: Preferred orientation.
    ///   - appTitle: Title of the application.
    /// - Returns: Image satisfying the parameters, if not nil.
    /// - Since: 2017.5.0
    open func imageFor(splashScreenSize: UIDSplashScreenSize,
                       orientation: UIDSplashScreenOrientation, appTitle: String) -> UIImage? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let size = orientation.orientationTransformed(size: splashScreenSize.sizeOfScreen)
        let scale = splashScreenSize.scaleOfScreen


        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        guard let context = CGContext(data: nil,
                                      width: Int(size.width * scale), height: Int(size.height * scale),
                                           bitsPerComponent: 8,
                                           bytesPerRow: Int(0), space: colorSpace,
                                           bitmapInfo: UInt32(bitmapInfo.rawValue))
            else { return nil }
        
        let splashView = UIDSplashView()
        splashView.scale = scale
        splashView.title = appTitle
        splashView.deviceType = splashScreenSize.platformType == .phone ? .phone : .pad
        
        let info = UIDSplashImageInfo(screenSize: splashScreenSize,
                                      orientation: orientation, imagePath: "")
        if let imageInfo = (splashImageInfos.filter { $0 == info }).first {
            splashView.image = UIImage(contentsOfFile: imageInfo.imagePath)
        }
        
        splashView.theme = theme
        splashView.frame = CGRect(origin: .zero, size: CGSize(width: size.width * scale, height: size.height * scale))
        splashView.layoutIfNeeded()
        
        context.translateBy(x: 0, y: splashView.frame.size.height)
        context.scaleBy(x: 1, y: -1)
        splashView.layer.render(in: context)
        let image = UIImage(cgImage: context.makeImage()!)
        return image
    }
    
    
    /// Generates the set of images satisfying the parameters. Note that custome splash image 
    /// can also be passed through `UIDSplashImageInfo`
    ///
    /// - Parameters:
    ///   - platForm: iPhone/iPad, if you want both pass .all
    ///   - orientation: Porait/Landscape, if you want both pass .all
    ///   - appTitle: Title of the application.
    /// - Since: 2017.5.0
    open func generateSplashScreenOf(platForm: UIDSplashScreenPlatform,
                                     orientation: UIDSplashScreenOrientation, appTitle: String) {
        let screenSizes = platForm.screenSizes
        var orientations: [UIDSplashScreenOrientation]!
        
        switch orientation {
        case .portrait:
            orientations = [.portrait]
        case .landscape:
            orientations = [.landscape]
        case .all:
            orientations = [.portrait, .landscape]
        }
        
        totalImages = orientations.count * screenSizes.count
        
        screenSizes.forEach { individualScreenSize in
            orientations.forEach { individualOrientation in
                if let image = self.imageFor(splashScreenSize: individualScreenSize,
                                             orientation: individualOrientation, appTitle: appTitle) {
                    let imageName = individualScreenSize.launchImageNameFor(orientation: individualOrientation)
                    self.write(image: image, fileName: "\(imageName).png")
                    self.processedImages += 1
                }
            }
        }
    }
    
    @discardableResult
    func write(image: UIImage, fileName: String) -> Bool {
        let pngData = UIImagePNGRepresentation(image) as NSData?
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if let path = paths.first?.appendingPathComponent(fileName), let pngData = pngData {
            return pngData.write(to: path, atomically: true)
        }
        return false
    }
}
