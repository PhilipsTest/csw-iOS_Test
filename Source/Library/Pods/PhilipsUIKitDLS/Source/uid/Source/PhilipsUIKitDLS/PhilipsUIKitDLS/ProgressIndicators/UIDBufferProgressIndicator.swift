/** © Koninklijke Philips N.V., 2016. All rights reserved. */

import Foundation

/**
 A **UIDBufferProgressIndicator** is the standard buffer progress-indicator to use.
 
 - Important:
 In InterfaceBuilder it is possible to create a UIView and give it the class UIDBufferProgressIndicator,
 the styling will be done immediately.
 
- Since: 3.0.0
 */
@objcMembers open class UIDBufferProgressIndicator: UIDProgressIndicator {
    
    /**
     Set the buffer-progress of the UIDBufferProgressIndicator.
     
     - Important:
     Defaults value is 0.0.
     Pass a float number between 0.0 and 1.0 which will equivalent to 0% - 100%.
     
     - Since: 3.0.0
     */
    open var bufferedProgress: CGFloat = 0.0 {
        didSet {
            bufferedProgress = CGFloat(min(1.0, max(0.0, Double(bufferedProgress))))
            configureProgressIndicator()
        }
    }
    
    /// Internal variable to support ProgressIndicator with Label
    var isUsedAsBufferProgressIndicatorOnly: Bool = true
    
    init(isUsedAsBufferProgressIndicatorOnly: Bool) {
        self.isUsedAsBufferProgressIndicatorOnly = isUsedAsBufferProgressIndicatorOnly
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func instanceInit() {
        if (isUsedAsBufferProgressIndicatorOnly) {
            progressIndicatorType = .linear
            progressIndicatorStyle = .determinate
        }
        super.instanceInit()
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let height = frame.size.height
        let width = frame.size.width
        let currentBufferedProgress = (bufferedProgress * width)
        let startX = LayoutDirection.isRightToLeft ? width : 0
        let endX = LayoutDirection.isRightToLeft ? width - currentBufferedProgress : currentBufferedProgress
        //Buffer Progress Bar
        context.saveGState()
        context.setLineWidth(self.intrinsicContentSize.height)
        if let strokeColor = (theme?.trackDetailBufferBackground?.cgColor) {
            context.setStrokeColor(strokeColor)
        }
        context.beginPath()
        context.move(to: CGPoint(x: startX, y: height/2))
        context.addLine(to: CGPoint(x: endX, y: height/2))
        context.strokePath()
        context.restoreGState()
    }
}
