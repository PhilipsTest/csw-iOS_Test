/** © Koninklijke Philips N.V., 2017. All rights reserved. */

import UIKit

let leftSpacingForQuietButtonTitle: CGFloat = -32
let notificationPadding = 16

extension UIDNotificationBarView {
    
    func verticalStackView() -> UIStackView {
        let verticalStackView = UIStackView.makePreparedForAutoLayout()
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fill
        verticalStackView.alignment = .leading
        return verticalStackView
    }
    
    func horizontalStackView() -> UIStackView {
        let horizontalStackView = UIStackView.makePreparedForAutoLayout()
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fill
        horizontalStackView.alignment = .top
        return horizontalStackView
    }
    
    func quietButton() -> UIDButton? {
        let button = UIDButton.makePreparedForAutoLayout()
        button.philipsType = .quiet
        if LayoutDirection.isRightToLeft {
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: leftSpacingForQuietButtonTitle)
        } else {
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: leftSpacingForQuietButtonTitle, bottom: 0, right: 0)
        }
        return button
    }
    
    func configureTheme() {
        backgroundColor = isAccent ? theme?.notificationBarAccentBackground : theme?.notificationBarWhiteBackground
        if theme?.tonalRange == .bright || theme?.tonalRange == .ultraLight {
            notificationTitleLabel?.textColor = isAccent ?
                theme?.notificationBarAccentSecondaryText :
                theme?.notificationBarWhiteSecondaryText
            notificationDescriptionLabel?.textColor = isAccent ?
                theme?.notificationBarAccentSecondaryText :
                theme?.notificationBarWhiteSecondaryText
        } else if theme?.tonalRange == .veryDark {
            notificationTitleLabel?.textColor = isAccent ?
                theme?.notificationBarAccentPrimaryText :
                theme?.notificationBarWhitePrimaryText
            notificationDescriptionLabel?.textColor = isAccent ?
                theme?.notificationBarAccentSecondaryText :
                theme?.notificationBarWhiteSecondaryText
        } else {
            notificationTitleLabel?.textColor = isAccent ?
                theme?.notificationBarAccentSecondaryText :
                theme?.notificationBarWhiteSecondaryText
            notificationDescriptionLabel?.textColor = isAccent ?
                theme?.notificationBarAccentSecondaryText :
                theme?.notificationBarWhiteSecondaryText
        }
    }
    
    func setUpMetrics() {
        guard let notificationVerticalStackView = notificationVerticalStackView,
            let verticalTitleStackView = verticalTitleStackView,
            let bottomVerticalStackView = bottomVerticalStackView,
            let verticalDescriptionStackView = verticalDescriptionStackView,
            let closeButton = closeButton,
            let notificationTitleLabel = notificationTitleLabel,
            let notificationDescriptionLabel = notificationDescriptionLabel,
            let iconVerticalStackView = iconVerticalStackView,
            let contentView = contentView,
            let leadingButton = leadingButton,
            let trailingButton = trailingButton else {
                return
        }
        
        views = ["notificationVerticalStackView": notificationVerticalStackView,
                 "verticalTitleStackView": verticalTitleStackView,
                 "verticalDescriptionStackView": verticalDescriptionStackView,
                 "closeButton": closeButton,
                 "bottomVerticalStackView": bottomVerticalStackView,
                 "notificationTitleLabel": notificationTitleLabel,
                 "notificationDescriptionLabel": notificationDescriptionLabel,
                 "iconVerticalStackView": iconVerticalStackView,
                 "contentView": contentView,
                 "leadingButton": leadingButton,
                 "trailingButton": trailingButton]
        
        metrics = ["notificationPadding": notificationPadding,
                   "verticalActionButtonPadding": 8,
                   "minimumTitleHeight": 22,
                   "minimumDescriptionHeight": 20,
                   "closeButtonWidth": 48,
                   "closeButtonHeight": 48,
                   "rightMarginalSpacing": 48,
                   "actionBarHeight": 56]
        setUpConstraint()
    }
    
    func setUpConstraint() {
        if #available(iOS 11.0, *) {
            guard let contentView = contentView else {
                return
            }
            
            NSLayoutConstraint.activate([
                contentView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
                ])
        } else {
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[contentView]-0-|",
                                                          options: .directionLeadingToTrailing,
                                                          metrics: metrics, views: views))
            
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[contentView]-0-|",
                                                      options: .directionLeadingToTrailing,
                                                      metrics: metrics, views: views))
        setUpTopViewConstraints()
        setUpIconConstraints()
        setUpBottomViewConstraints()
    }
    
    func setUpTopViewConstraints() {
        contentView?.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-notificationPadding-[notificationVerticalStackView]-rightMarginalSpacing-|",
            options: .directionLeadingToTrailing,
            metrics: metrics, views: views))
        contentView?.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-notificationPadding-[notificationVerticalStackView]-[bottomVerticalStackView]-|",
            options: .directionLeadingToTrailing,
            metrics: metrics, views: views))
        
        notificationVerticalStackView?.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[verticalTitleStackView(>=minimumTitleHeight)]",
            options: .directionLeadingToTrailing,
            metrics: metrics, views: views))
        notificationVerticalStackView?.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[verticalDescriptionStackView(>=minimumDescriptionHeight)]",
            options: .directionLeadingToTrailing,
            metrics: metrics, views: views))
    }
    
    func setUpIconConstraints() {
        iconVerticalStackView?.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[closeButton(closeButtonHeight)]",
            options: .directionLeadingToTrailing,
            metrics: metrics, views: views))
        iconVerticalStackView?.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[closeButton(closeButtonWidth)]",
            options: .directionLeadingToTrailing,
            metrics: metrics, views: views))
        
        contentView?.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[notificationVerticalStackView]-[iconVerticalStackView(closeButtonHeight)]-0-|",
            options: .directionLeadingToTrailing,
            metrics: metrics, views: views))
        contentView?.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[iconVerticalStackView]",
            options: .directionLeadingToTrailing,
            metrics: metrics, views: views))
    }
    
    func setUpBottomViewConstraints() {
        contentView?.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-notificationPadding-[bottomVerticalStackView]-notificationPadding-|",
            options: .directionLeadingToTrailing,
            metrics: metrics, views: views))
        contentView?.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[notificationVerticalStackView]-[bottomVerticalStackView]",
            options: .directionLeadingToTrailing,
            metrics: metrics, views: views))
    }
    
    func configureConstraint() {
        switch notificationBarType {
        case .textOnly:
            contentView?.addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-notificationPadding-[notificationVerticalStackView]-notificationPadding-|",
                options: .directionLeadingToTrailing,
                metrics: metrics,
                views: views))
            bottomHorizontalStackView?.isHidden = true
        case .textWithAction:
            bottomHorizontalStackView?.isHidden = false
        }
        layoutIfNeeded()
    }
    
    @objc
    func hideNotificationBar(_ sender: UIButton) {
        delegate?.notificationBar?(self, forTapped: .close)
    }
    
    @objc
    func leadingButtonTapped(_ sender: UIDButton) {
        delegate?.notificationBar?(self, forTapped: .leading)
    }
    
    @objc
    func trailingButtonTapped(_ sender: UIDButton) {
        delegate?.notificationBar?(self, forTapped: .trailing)
    }
}

extension UIDTheme {
    
    public var notificationBarAccentBackground: UIColor? {
        return brushes.controlAccent(tonalRange: tonalRange).color(in: accentColorRange)
    }
    
    public var notificationBarWhiteBackground: UIColor? {
        return brushes.tooltipLight(tonalRange: tonalRange).color(in: colorRange)
    }
    
    public var notificationBarAccentSecondaryText: UIColor? {
        return brushes.lightSecondaryText(tonalRange: tonalRange).color(in: accentColorRange)
    }
    
    public var notificationBarWhiteSecondaryText: UIColor? {
        return brushes.graySecondaryText(tonalRange: tonalRange).color(in: colorRange)
    }
    
    public var notificationBarAccentPrimaryText: UIColor? {
        return brushes.lightTextPrimary(tonalRange: tonalRange).color(in: accentColorRange)
    }
    
    public var notificationBarWhitePrimaryText: UIColor? {
        return brushes.grayPrimaryText(tonalRange: tonalRange).color(in: colorRange)
    }
}
