/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

enum SegmentAlignment: Int {
    case leading
    case middle
    case trailing
}

class ComponentView: UIView {
    let fragmentView: UIView = UIView.makePreparedForAutoLayout()
    let leadingView: UIView = UIView.makePreparedForAutoLayout()
    let trailingView: UIView = UIView.makePreparedForAutoLayout()
    
    var leadingWidthConstraint: NSLayoutConstraint!
    var trailingWidthConstraint: NSLayoutConstraint!
    
    var theme: UIDTheme? {
        didSet {
            configureTheme()
        }
    }
    
    var interSegmentColor: UIColor? {
        didSet {
            configureInterSegmentColor()
        }
    }
    
    var isHighlighted = false {
        didSet {
            fragmentView.backgroundColor = isHighlighted ? theme?.trackDefaultOnBackground : theme?.trackDefaultOffBackground
        }
    }
    
    var alignment: SegmentAlignment = .middle {
        didSet {
            let widthConstantClosure: () -> (CGFloat, CGFloat) = {
                switch self.alignment {
                case .leading:
                    return (0, UIDSize2/2)
                case .middle:
                    return (UIDSize2/2, UIDSize2/2)
                case .trailing:
                    return (UIDSize2/2, 0)
                }
            }
            (leadingWidthConstraint.constant, trailingWidthConstraint.constant) = widthConstantClosure()
        }
    }
    
   @objc override public init(frame: CGRect) {
        super.init(frame: frame)
        instanceInit()
    }
    
   @objc required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
   @objc open override func awakeFromNib() {
        super.awakeFromNib()
        instanceInit()
    }
}

extension ComponentView {
    func instanceInit() {
        addSubviews([fragmentView,leadingView,trailingView])
        let bindingViewsInfo: [String:UIView] = ["fragmentView": fragmentView,
                                                 "leadingView": leadingView,
                                                 "trailingView": trailingView]
        var visualConstraints = [String]()
        visualConstraints.append("V:|[fragmentView]|")
        visualConstraints.append("V:|[leadingView]|")
        visualConstraints.append("V:|[trailingView]|")
        visualConstraints.append("H:|[leadingView][fragmentView][trailingView]|")
        visualConstraints.activateVisualConstraintsWith(views: bindingViewsInfo)
        
        leadingWidthConstraint = leadingView.constrain(toWidth: 0)
        trailingWidthConstraint = trailingView.constrain(toWidth: 0)
    }
    
    func configureTheme() {
        configureInterSegmentColor()
        isHighlighted = { return isHighlighted }()
    }
    
    func configureInterSegmentColor() {
        leadingView.backgroundColor = interSegmentColor
        trailingView.backgroundColor = interSegmentColor
    }
}
