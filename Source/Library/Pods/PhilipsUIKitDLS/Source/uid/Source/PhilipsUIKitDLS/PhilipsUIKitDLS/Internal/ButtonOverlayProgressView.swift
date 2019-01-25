//  Copyright © 2016 Philips. All rights reserved.

import Foundation

class ButtonOverlayProgressView: UIView {
    var titleLabel = UILabel.makePreparedForAutoLayout()
    var activityIndicator = UIDProgressIndicator.makePreparedForAutoLayout()
    private var stackView: UIStackView!
    
    private func instanceInit() {
        backgroundColor = UIColor.clear
        
        activityIndicator.progressIndicatorStyle = .indeterminate
        activityIndicator.circularProgressIndicatorSize = .small
        activityIndicator.setContentCompressionResistancePriority(.required, for: .horizontal)
        activityIndicator.setContentCompressionResistancePriority(.required, for: .vertical)
        activityIndicator.setContentHuggingPriority(.required, for: .horizontal)
        activityIndicator.setContentHuggingPriority(.required, for: .vertical)
        
        titleLabel.isHidden = true
        titleLabel.font = UIFont(uidFont: .book, size: UIDFontSizeMedium)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        stackView = UIStackView(arrangedSubviews: [activityIndicator, titleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = UIDButton.textWithIconButtonEdgeInset * 2
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: UIDButton.edgeInset, bottom: 0, right: UIDButton.edgeInset)
        addSubview(stackView)
        
        stackView.constrainCenterToParent()
        let constraint = NSLayoutConstraint(item: stackView,
                                            attribute: .leading,
                                            relatedBy: .greaterThanOrEqual,
                                            toItem: self,
                                            attribute: .leading,
                                            multiplier: 1,
                                            constant: 0)
        addConstraint(constraint)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        instanceInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        instanceInit()
    }
    
   @objc open var title: String? = nil {
        didSet {
            titleLabel.text = title
            if title != nil {
                titleLabel.isHidden = false
                stackView.layoutMargins = UIEdgeInsets(top: 0, left: UIDButton.edgeInset,
                                                       bottom: 0, right: UIDButton.edgeInset)
            } else {
                titleLabel.isHidden = true
                stackView.layoutMargins = UIEdgeInsets(top: 0, left: UIDButton.iconOnlyButtonEdgeInset,
                                                       bottom: 0, right: UIDButton.iconOnlyButtonEdgeInset)
            }
        }
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
}
