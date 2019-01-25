//  Copyright © 2016 Philips. All rights reserved.

import Foundation

enum ButtonConfiguration {
    case primary
    case secondary
    case quiet
    case accent
    case quietDefault
}

typealias StringAttributes = [NSAttributedStringKey : Any]

extension ButtonConfiguration {
    
    func configureTitle(of button: UIDButton) {
        let (normalColor, disabledColor, highlightedColor) = titleColors(of: button)
        
        if let normalColor = normalColor,
            let disabledColor = disabledColor,
            let highlightedColor = highlightedColor,
            let font = button.titleFont {
            configureTitle(of: button, with: normalColor, and: font, for: .normal)
            configureTitle(of: button, with: disabledColor, and: font, for: .disabled)
            configureTitle(of: button, with: highlightedColor, and: font, for: .highlighted)
        }
    }
    
    func titleColors(of button: UIDButton) -> (normalColor: UIColor?, disabledColor: UIColor?, highlightedColor: UIColor?) {
        let theme = button.theme
        let normalColor: UIColor?
        let disabledColor: UIColor?
        var highlightedColor: UIColor?
        switch self {
        case .primary:
            normalColor = theme?.buttonPrimaryText
            disabledColor = theme?.buttonPrimaryDisabledText
        case .secondary:
            normalColor = theme?.buttonSecondaryText
            disabledColor = theme?.buttonSecondaryDisabledText
        case .quiet:
            normalColor = theme?.buttonQuietEmphasisText
            highlightedColor = theme?.buttonQuietEmphasisPressedText
            disabledColor = theme?.buttonQuietEmphasisDisabledText
        case .accent:
            normalColor = theme?.buttonAccentText
            disabledColor = theme?.buttonAccentDisabledText
        case .quietDefault:
            normalColor = theme?.buttonQuietDefaultText
            highlightedColor = theme?.buttonQuietDefaultPressedText
            disabledColor = theme?.buttonQuietDefaultDisabledText
        }
        return (normalColor, disabledColor, highlightedColor ?? normalColor)
    }
    
    private func configureTitle(of button: UIDButton,
                                with color: UIColor,
                                and font: UIFont,
                                for state: UIControlState) {
        let titleColor = button.customTitleColor ? button.titleColor(for: state) ?? .black : color
        let attributes = font.attributes(with: titleColor)
        
        if var title = button.title(for:state) {
            title = button.buttonStyle == .iconOnly ? "" : title
            let attributedString = NSMutableAttributedString(string: title,
                                                             attributes: attributes)
            button.setAttributedTitle(attributedString, for: state)
        }
    }
    
    func configureBackground(of button: UIDButton) {
        let theme = button.theme
        
        let normalColor: UIColor?
        let highlightedColor: UIColor?
        let disabledColor: UIColor?
        
        switch self {
        case .primary:
            normalColor = theme?.buttonPrimaryBackground
            highlightedColor = theme?.buttonPrimaryPressedBackground
            disabledColor = theme?.buttonPrimaryDisabledBackground
        case .secondary:
            normalColor = theme?.buttonSecondaryBackground
            highlightedColor = theme?.buttonSecondaryPressedBackground
            disabledColor = theme?.buttonSecondaryDisabledBackground
        case .quiet:
            normalColor = theme?.buttonQuietEmphasisBackground
            highlightedColor = UIColor.clear
            disabledColor = theme?.buttonQuietEmphasisBackground
        case .accent:
            normalColor = theme?.buttonAccentBackground
            highlightedColor = theme?.buttonAccentPressedBackground
            disabledColor = theme?.buttonAccentDisabledBackground
        case .quietDefault:
            normalColor = UIColor.clear
            highlightedColor = UIColor.clear
            disabledColor = UIColor.clear
        }
        
        button.setBackgroundImage(normalColor?.createImage(), for: .normal)
        button.setBackgroundImage(disabledColor?.createImage(), for: .disabled)
        button.setBackgroundImage(highlightedColor?.createImage(), for: .highlighted)
    }
    
    func configureProgressTitle(of button: UIDProgressButton) {
        let theme = button.theme
        button.overlayProgressView?.titleLabel.textColor =  theme?.trackDetailOnBackground
    }
}
