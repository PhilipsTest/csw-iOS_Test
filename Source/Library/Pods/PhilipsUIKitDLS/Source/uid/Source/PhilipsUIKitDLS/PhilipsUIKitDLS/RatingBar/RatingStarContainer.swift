/* Copyright (c) Koninklijke Philips N.V., 2018
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import PhilipsIconFontDLS

class RatingStarContainer: UIView {
    var theme: UIDTheme? = UIDThemeManager.sharedInstance.defaultTheme {
        didSet {
            ratingStar.theme = theme
        }
    }
    
    var designatedSize: CGSize = .zero
    
    var fontSize: CGFloat = 0 { didSet { ratingStar.ratingStarIconWidth = fontSize } }
    
    var ratingStar = RatingStar.makePreparedForAutoLayout()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        designatedSize = frame.size
        instanceInit()
    }
    
    convenience init(designatedSize: CGSize) {
        self.init(frame: CGRect(origin: .zero, size: designatedSize))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var intrinsicContentSize: CGSize {
        return designatedSize
    }
    
    func instanceInit() {
        addSubview(ratingStar)
        ratingStar.constrainCenterToParent()
        backgroundColor = UIColor.clear
        fontSize = { fontSize }()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        ratingStar.progress = { ratingStar.progress }()
    }
}

class RatingStar: UIView {
    var theme: UIDTheme? { didSet { configureTheme() } }
    
    let emptyLabel = UILabel.makePreparedForAutoLayout()
    let fillLabelContentView = UIView.makePreparedForAutoLayout()
    let fillLabel = UILabel.makePreparedForAutoLayout()
    
    var progressLayoutConstraint: NSLayoutConstraint!
    
    var ratingStarIconWidth: CGFloat = 0 {
        didSet {
            configureLabel()
            progress = { progress }()
            layoutIfNeeded()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return emptyLabel.intrinsicContentSize
    }
    
    var progress: CGFloat = 0 {
        didSet {
            if !(progress >= 0 && progress <= 1) {
                progress = min(max(progress, 0), 1)
            }
            progressLayoutConstraint.constant = frame.size.width * progress
            setNeedsLayout()
        }
    }
    
   @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        instanceInit()
    }
    
   @objc required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureLabel() {
        if let font = UIFont.iconFont(size: ratingStarIconWidth) {
            emptyLabel.font = font
            fillLabel.font = font
            
            emptyLabel.text = PhilipsDLSIcon.unicode(iconType: .star)
            fillLabel.text = PhilipsDLSIcon.unicode(iconType: .star)
        }
    }
    
    func configureTheme() {
        emptyLabel.textColor = theme?.ratingBarDefaultOffIcon
        fillLabel.textColor = theme?.ratingBarDefaultOnIcon
    }
    
    func configureLayout() {
        ["H:|[emptyLabel]|",
         "V:|[emptyLabel]|",
         "H:|[fillLabelContentView]",
         "V:|[fillLabelContentView]",
         "H:|[fillLabel]",
         "V:|[fillLabel]|"].activateVisualConstraintsWith(views: ["emptyLabel": emptyLabel,
                                                                  "fillLabel": fillLabel,
                                                                  "fillLabelContentView": fillLabelContentView])
        progressLayoutConstraint = fillLabelContentView.constrain(toWidth: 0)
    }
    
    func instanceInit() {
        addSubviews([emptyLabel, fillLabelContentView])
        fillLabelContentView.addSubview(fillLabel)
        fillLabelContentView.clipsToBounds = true
        configureLabel()
        configureTheme()
        configureLayout()
        progress = {progress}()
    }
}
