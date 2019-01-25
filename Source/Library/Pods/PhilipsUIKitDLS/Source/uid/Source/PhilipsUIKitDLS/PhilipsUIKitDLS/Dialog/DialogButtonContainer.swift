/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

let offsetContainerToButton: CGFloat = 12
let interButtonSpacing: CGFloat = 8

class DialogButtonContainer: UIView {
    var theme: UIDTheme? = UIDThemeManager.sharedInstance.whiteTheme {
        didSet {
            configureTheme()
        }
    }

    var actionButtons: [UIDButton]! {
        didSet {
            configureActionButtons()
        }
    }
    
    let contentStackView = UIStackView.makePreparedForAutoLayout()
    
   @objc required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        instanceInit()
    }
    
  @objc override public init(frame: CGRect) {
        super.init(frame: frame)
        instanceInit()
    }
    
    private func instanceInit() {
        backgroundColor = UIColor.clear
        configureContentStackView()
    }
    
    private func configureTheme() {
        actionButtons?.forEach { $0.theme = theme }
    }
    
    func configureContentStackView() {
        let edgeInsets = UIEdgeInsets(top: offsetContainerToButton, left: offsetContainerToButton,
                                      bottom: offsetContainerToButton, right: offsetContainerToButton)
        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.layoutMargins = edgeInsets
        contentStackView.spacing = interButtonSpacing
    }
    
    func configureActionButtons() {
        removeAllSubviews()
        contentStackView.addArrangedSubviews(actionButtons)
        
        if actionButtons.count > 0 {
            if actionButtons.count == 2 {
                configureLayout(isHorizontal: true)
            } else {
                configureLayout(isHorizontal: false)
            }
        }
    }
    
    func configureLayout(isHorizontal: Bool) {
        contentStackView.removeFromSuperview()
        addSubview(contentStackView)
        
        let bindingViewsInfo: [String: UIView] = ["contentStackView": contentStackView]
        var visualConstraints = [String]()
        visualConstraints.append(isHorizontal ? "H:|-(>=0)-[contentStackView]|" : "H:|[contentStackView]|")
        visualConstraints.append("V:|[contentStackView]|")
        addConstraints(visualConstraints,
                       metrics: nil, views: bindingViewsInfo)
        contentStackView.axis = isHorizontal ? .horizontal : .vertical
        actionButtons.forEach { configure(button: $0, isHorizontal: isHorizontal) }
    }
    
    func configure(button: UIButton, isHorizontal: Bool) {
        if isHorizontal == true {
            let axis: [UILayoutConstraintAxis] = [.vertical, .horizontal]
            axis.forEach { button.setContentHuggingPriority(.required, for: $0) }
            axis.forEach { button.setContentCompressionResistancePriority(.required, for: $0)
            }
        } else {
            button.setContentHuggingPriority(.defaultLow, for: .horizontal)
            button.setContentHuggingPriority(.required, for: .vertical)
            
            button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            button.setContentCompressionResistancePriority(.required, for: .vertical)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let actionButtons = actionButtons else { return }

        if actionButtons.count == 2 {
            var frames = [CGRect]()
            let button = UIDButton()
            for uidbutton in actionButtons {
                button.setTitle(uidbutton.title(for: .normal), for: .normal)
                button.sizeToFit()
                frames.append(button.frame)
            }
            var val: CGFloat = offsetContainerToButton * 2 + interButtonSpacing
            frames.forEach { val = $0.width + val }
            
            let refreshContainerClosure = {
                self.removeAllSubviews()
                self.contentStackView.addArrangedSubviews(actionButtons)
            }
            
            if contentStackView.axis == .vertical, val <= frame.width {
                refreshContainerClosure()
                configureLayout(isHorizontal: true)
            } else if contentStackView.axis == .horizontal, val >= frame.width {
                refreshContainerClosure()
                configureLayout(isHorizontal: false)
            }
        }
    }
}
