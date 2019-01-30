/** © Koninklijke Philips N.V., 2016. All rights reserved. */

extension UIDProgressIndicator {

    func drawCircularProgressIndicator(_ rect: CGRect) {
        if self.progressIndicatorStyle == .determinate {
            drawDeterminateCircularProgressIndicator(rect)
        } else {
            drawInDeterminateCircularProgressIndicator(rect)
        }
    }
}

extension UIDCircularProgressIndicatorSize {
    
    var strokeWidth: CGFloat {
        switch self {
        case .small:
            return 2.0
        case .medium:
            return 3.0
        case .large:
            return 4.0
        }
    }
    
    var animationDuration: TimeInterval {
        switch self {
        case .small:
            return 1.0
        case .medium:
            return 1.25
        case .large:
            return 1.5
        }
    }
    
    var intrinsicContentSize: CGSize {
        switch self {
        case .small:
            return CGSize(width: 24.0, height: 24.0)
        case .medium:
            return CGSize(width: 48.0, height: 48.0)
        case .large:
            return CGSize(width: 88.0, height: 88.0)
        }
    }
    
    var spacing: CGFloat {
        switch self {
        case .small:
            return 12.0
        case .medium:
            return 14.0
        case .large:
            return 16.0
        }
    }
}
