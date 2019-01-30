/** © Koninklijke Philips N.V., 2016. All rights reserved. */

/**
 * This struct contains the useful property which is using for drawing "Determinate" &
 * "InDeterminate" circular progress-indicator.
 */
struct CircularProgressIndicatorConfiguration {
    let lineWidth: CGFloat
    let progressSize: CGFloat
    let startColor: UIColor
    let endColor: UIColor = UIColor.clear
    let animationDuration: TimeInterval
    var strokeColor: CGColor = UIColor.clear.cgColor
    var radius: CGFloat {
        return (progressSize - lineWidth) / 2.0
    }
    var center: CGPoint {
        return CGPoint(x: progressSize / 2.0, y: progressSize / 2.0)
    }
    
    /**
     * Helper Init for "InDeterminate" circular progress-indicator.
     */
    init(lineWidth: CGFloat, animationDuration: TimeInterval, startColor: UIColor, size: CGFloat) {
        self.lineWidth = lineWidth
        self.animationDuration = animationDuration
        self.startColor = startColor
        self.progressSize = size
    }
    
    /**
     * Helper Init for "Determinate" circular progress-indicator.
     */
    init(lineWidth: CGFloat, strokeColor: UIColor, size: CGFloat) {
        self.lineWidth = lineWidth
        self.strokeColor = strokeColor.cgColor
        self.progressSize = size
        self.startColor = UIColor.clear
        self.animationDuration = 0.0
    }
}
