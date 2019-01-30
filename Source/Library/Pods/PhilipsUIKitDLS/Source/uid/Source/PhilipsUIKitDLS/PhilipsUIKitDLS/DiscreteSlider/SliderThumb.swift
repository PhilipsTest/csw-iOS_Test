/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class SliderThumb: UIView {
    let thumbView: UIView = UIView.makePreparedForAutoLayout()
    let highlightedView: UIView = UIView.makePreparedForAutoLayout()
    var theme: UIDTheme? {
        didSet {
            configureTheme()
        }
    }
    var isHighlighted = false {
        didSet {
            let scale: CGFloat = isHighlighted ? 1.5 : 1
            thumbView.transform = CGAffineTransform(scaleX: scale, y: scale)
            highlightedView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
            highlightedView.alpha = isHighlighted ? 1 : 0
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = false
        constrain(toSize: CGSize(width: UIDSize24*2, height: UIDSize24*2))
        
        addSubviews([highlightedView, thumbView])
        thumbView.constrain(toSize: CGSize(width: UIDSize16, height: UIDSize16))
        thumbView.constrainCenterToParent()
        highlightedView.constrain(toSize: CGSize(width: UIDSize16*2, height: UIDSize16*2))
        highlightedView.constrainCenterToParent()
        
        thumbView.layer.cornerRadius = UIDSize8
        highlightedView.layer.cornerRadius = UIDSize16
        configureTheme()
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension SliderThumb {
    func highLightThumb(highlight: Bool, animated: Bool) {
        let transitionClosure: () -> Void = {[weak self] in self?.isHighlighted = highlight}
        animated ?  UIView.animate(withDuration: 0.2, animations: transitionClosure) : transitionClosure()
    }
    
    func configureTheme() {
        thumbView.backgroundColor = theme?.thumbDefaultBackground
        highlightedView.backgroundColor = theme?.thumbDefaultPressedBorder
        if let theme = theme {
            let dropShadow = UIDDropShadow(level: .level1, theme: theme)
            thumbView.apply(dropShadow: dropShadow)
        }
        isHighlighted = { return isHighlighted }()
    }
}
