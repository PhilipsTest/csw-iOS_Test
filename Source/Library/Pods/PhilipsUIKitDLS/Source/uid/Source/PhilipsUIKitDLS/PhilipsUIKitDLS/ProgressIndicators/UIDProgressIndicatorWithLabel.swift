/* Copyright (c) Koninklijke Philips Electronics N.V. 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

/**
 * The types of circular progressIndicator's label type that are available.
 * In code, you should use these types. Unfortunately, Interface Builder doesn't support enums yet,
 * so if you configure the progressIndicator's label in Interface Builder, you have to use the numeric values.
 *
 * - Since: 3.0.0
 */
@objc
public enum UIDCircularProgressIndicatorLabelAlignment: Int {
    /// Circular ProgressIndicator's label will be center align: (numerical value: 0)
    /// - Since: 3.0.0
    case center
    /// Circular ProgressIndicator's label will be bottom align: (numerical value: 1)
    /// - Since: 3.0.0
    case bottom
}

/**
 * The types of linear progressIndicator's label type that are available.
 * In code, you should use these types. Unfortunately, Interface Builder doesn't support enums yet,
 * so if you configure the progressIndicator's label in Interface Builder, you have to use the numeric values.
 *
 * - Since: 3.0.0
 */
@objc
public enum UIDLinearProgressIndicatorLabelAlignment: Int {
    /// Linear ProgressIndicator's label will be top-left align: (numerical value: 0)
    /// - Since: 3.0.0
    case topLeft
    /// Linear ProgressIndicator's label will be top-right align: (numerical value: 1)
    /// - Since: 3.0.0
    case topRight
    /// Linear ProgressIndicator's label will be bottom-left align: (numerical value: 2)
    /// - Since: 3.0.0
    case bottomLeft
    /// Linear ProgressIndicator's label will be bottom-right align: (numerical value: 3)
    /// - Since: 3.0.0
    case bottomRight
}

/**
 *  A UIDProgressIndicatorWithLabel is the standard progress-indicator with label to use.
 *  In InterfaceBuilder it is possible to create a UIView and give it the class UIDProgressIndicatorWithLabel,
 *  the styling will be done immediately.
 *
 *  - Since: 3.0.0
 */
@IBDesignable
@objcMembers open class UIDProgressIndicatorWithLabel: UIView {
    
    // swiftlint:disable valid_ibinspectable
    /**
     * The Style of the progressIndicator.
     * Updates the progressIndicator styling when set.
     *
     * Defaults to UIDProgressIndicatorType.circular
     *
     * - Since: 3.0.0
     */
    @IBInspectable
    open var progressIndicatorType: UIDProgressIndicatorType = .circular {
        didSet {
            progressIndicator.progressIndicatorType = progressIndicatorType
        }
    }
    
    /**
     * The Style of the progressIndicator.
     * Updates the progressIndicator styling when set.
     *
     * Defaults to UIDProgressIndicatorStyle.determinate
     *
     * - Since: 3.0.0
     */
    @IBInspectable
    open var progressIndicatorStyle: UIDProgressIndicatorStyle = .determinate {
        didSet {
            progressIndicator.progressIndicatorStyle = progressIndicatorStyle
        }
    }
    
    /**
     * The Style of the cirular progressIndicator.
     * Updates the progressIndicator styling when set.
     *
     * Defaults to UIDCircularProgressIndicatorSize.small
     *
     * - Since: 3.0.0
     */
    @IBInspectable
   @objc open var circularProgressIndicatorSize: UIDCircularProgressIndicatorSize = .small {
        didSet {
            progressIndicator.circularProgressIndicatorSize = circularProgressIndicatorSize
        }
    }
    
    /**
     * The alignment of the circular progressIndicator's label.
     * Updates the progressIndicator's label alignment when set.
     *
     * Defaults to UIDCircularProgressIndicatorLabelAlignment.center
     *
     * - Since: 3.0.0
     */
    @IBInspectable
    open var circularProgressIndicatorLabelAlignment: UIDCircularProgressIndicatorLabelAlignment = .center {
        didSet {
            configureCircularProgressIndicator()
        }
    }
    
    /**
     * The alignment of the linear progressIndicator's label.
     * Updates the progressIndicator's label alignment when set.
     *
     * Defaults to UIDCircularProgressIndicatorLabelAlignment.center
     *
     * - Since: 3.0.0
     */
    @IBInspectable
    open var linearProgressIndicatorLabelAlignment: UIDLinearProgressIndicatorLabelAlignment = .topLeft {
        didSet {
            configureLinearProgressIndicator()
        }
    }
    // swiftlint:enable valid_ibinspectable
    
    /**
     * Updates the progressIndicator loading label text when set.
     *
     * Defaults is empty text. i.e ""
     *
     * - Since: 3.0.0
     */
    @IBInspectable
    open var labelText: String = "" {
        didSet {
            label.text = labelText
        }
    }
    
    /// - Since: 3.0.0
    open var progressIndicator = UIDBufferProgressIndicator(isUsedAsBufferProgressIndicatorOnly: false)
    /// - Since: 3.0.0
    open var label = UIDLabel.makePreparedForAutoLayout()
    let contentStackView = UIStackView.makePreparedForAutoLayout()
    let labelStackView = UIStackView.makePreparedForAutoLayout()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        instanceInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        instanceInit()
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        instanceInit()
    }
    
    var circularProgressIndicatorHeight: CGFloat {
        return progressIndicator.circularProgressIndicatorSize.intrinsicContentSize.height
    }
    
    func instanceInit() {
        (clipsToBounds, backgroundColor) = (true, UIColor.clear)
        configureView()
    }
    
    func configureView() {
        configureProgressIndicator()
        configureLabel()
        configureStackView()
    }
    
    func configureProgressIndicator() {
        progressIndicator.removeConstraints(progressIndicator.constraints)
        progressIndicator.constrain(toSize: progressIndicator.circularProgressIndicatorSize.intrinsicContentSize)
    }
    
    func configureLabel() {
        label.textColor = progressIndicator.theme?.contentItemTertiaryText
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    func configureStackView() {
        if progressIndicatorType == .circular {
            configureCircularProgressIndicator()
        } else {
            configureLinearProgressIndicator()
        }
    }
    
    func configureCircularProgressIndicator() {
        clearStackViewsContent()
        
        (contentStackView.axis, contentStackView.distribution, contentStackView.alignment) = (.vertical, .fill, .center)
        contentStackView.spacing = progressIndicator.circularProgressIndicatorSize.spacing
        contentStackView.addArrangedSubview(progressIndicator)
        
        if circularProgressIndicatorLabelAlignment == .bottom {
            (labelStackView.axis, labelStackView.alignment) = (.horizontal, .top)
            labelStackView.addArrangedSubview(label)
            contentStackView.addArrangedSubview(labelStackView)
        } else {
            progressIndicator.addSubview(label)
            label.constrainCenterToParent()
        }
        addSubview(contentStackView)
        contentStackView.constrainToSuperview()
    }
    
    func configureLinearProgressIndicator() {
        clearStackViewsContent()
        
        (contentStackView.axis, contentStackView.distribution) = (.vertical, .fill)
        
        labelStackView.axis = .horizontal
        labelStackView.addArrangedSubview(label)
        
        if linearProgressIndicatorLabelAlignment == .topLeft || linearProgressIndicatorLabelAlignment == .topRight {
            label.textAlignment = linearProgressIndicatorLabelAlignment == .topLeft ? .left : .right
            contentStackView.addArrangedSubviews([labelStackView, progressIndicator])
        } else {
            label.textAlignment = linearProgressIndicatorLabelAlignment == .bottomLeft ? .left : .right
            contentStackView.addArrangedSubviews([progressIndicator, labelStackView])
        }
        addSubview(contentStackView)
        contentStackView.constrainToSuperview()
    }
    
    func clearStackViewsContent() {
        contentStackView.removeFromSuperview()
        contentStackView.removeAllArrangedSubviews()
        labelStackView.removeAllArrangedSubviews()
    }
}
