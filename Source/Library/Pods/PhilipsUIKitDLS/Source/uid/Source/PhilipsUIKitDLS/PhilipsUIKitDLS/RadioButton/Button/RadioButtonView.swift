/* Copyright (c) Koninklijke Philips Electronics N.V. 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

let innerCircleSize: CGFloat = 8
let outerCircleSize: CGFloat = 20
let shadowCircleSize: CGFloat = 40
let textToCirclePadding: CGFloat = 12
let outerCircleY: CGFloat = 14

/// RadionButtonView is just Group of Views which will looks like Radio-Button.
/// Helper class of "UIDRadioButton" control.
@objcMembers class RadioButtonView: UIView {
    let innerCircle = UIView.makePreparedForAutoLayout()
    let outerCircle = UIView.makePreparedForAutoLayout()
    let shadowCircle = UIView.makePreparedForAutoLayout()
    let tapGestureRecognizer = UITapGestureRecognizer()
    weak var parent: UIDRadioButton?
    
    var isEnabled: Bool = true {
        didSet {
            isUserInteractionEnabled = isEnabled
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            innerCircle.isHidden = !isSelected
            if oldValue != isSelected {
                parent.ifNotNil {
                    $0.delegate?.radioButtonPressed?($0)
                }
            }
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        instanceInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let titleLabel = UILabel.makePreparedForAutoLayout()
}

extension RadioButtonView {
    func instanceInit() {
        backgroundColor = UIColor.clear
        configureTheme()
        configureCornerRadius()
        configureTapGesture()
        
        addSubview(titleLabel)
        configureSubViews()
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        let views = ["label": titleLabel]
        let textPadding = outerCircleSize + textToCirclePadding
        let metrics: [String : Any] = ["outerCircleY": outerCircleY,
                                       "paddingX": textPadding]

        let constraints = ["H:|-(paddingX)-[label]|", "V:|-(outerCircleY)-[label]-(outerCircleY)-|"]
        addConstraints(constraints, metrics: metrics, views: views)
    }
}

extension RadioButtonView {
    var outerCircleBackgroundColor: UIColor? {
        var backgroundColor: UIColor?
        parent?.theme.ifNotNil {
            backgroundColor = isSelected ? $0.radioButtonDefaultOnBackground : $0.radioButtonDefaultOffBackground
        }
        return backgroundColor
    }
    
    func configureTheme() {
        parent?.theme.ifNotNil {
            outerCircle.backgroundColor = isEnabled ? outerCircleBackgroundColor : $0.radioButtonDefaultDisabledBackground
            innerCircle.backgroundColor = isEnabled ? $0.radioButtonDefaultOnIcon : $0.radioButtonDefaultDisabledIcon
            shadowCircle.backgroundColor = $0.radioButtonDefaultPressedBorder
        }
    }
    
    func configureSubViews() {
        let radioIconView = UIView.makePreparedForAutoLayout()
        addSubview(radioIconView)
        NSLayoutConstraint(item: radioIconView,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: titleLabel,
                           attribute: .top,
                           multiplier: 1,
                           constant: 0).isActive = true
        innerCircle.constrain(toSize: CGSize(width: innerCircleSize, height: innerCircleSize))
        outerCircle.constrain(toSize: CGSize(width: outerCircleSize, height: outerCircleSize))
        shadowCircle.constrain(toSize: CGSize(width: shadowCircleSize, height: shadowCircleSize))
        radioIconView.addSubview(outerCircle)
        radioIconView.addSubview(shadowCircle)
        outerCircle.addSubview(innerCircle)
       
        let views = ["outerCircle": outerCircle,
                     "iconView": radioIconView]
        let constraints = ["H:|[outerCircle]|",
                           "V:|[outerCircle]|",
                           "H:|[iconView]"]
        constraints.activateVisualConstraintsWith(views: views)
        innerCircle.constrainCenterToParent()
        shadowCircle.constrainCenterToParent()
        shadowCircle.isHidden = true
    }
    
    func configureCornerRadius() {
        outerCircle.cornerRadius = outerCircleSize / 2
        innerCircle.cornerRadius = innerCircleSize / 2
        shadowCircle.cornerRadius = shadowCircleSize / 2
    }
}

extension RadioButtonView {
    func configureTapGesture() {
        tapGestureRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.addTarget(self, action: #selector(handleTapGesture))
    }
    
    @objc func handleTapGesture() {
        isSelected = true
        configureTheme()
    }
}

extension RadioButtonView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        shadowCircle.isHidden = false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        shadowCircle.isHidden = true
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        shadowCircle.isHidden = true
    }
}
