/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

/// UIDDiscreteSlider is a class which provides the sliding of thumb in discrete
/// points.
/// - Since: 2017.5.0
@IBDesignable
@objcMembers open class UIDDiscreteSlider: UIControl {
    
    let contentView: UIView = UIView.makePreparedForAutoLayout()
    
    let thumb: SliderThumb = SliderThumb.makePreparedForAutoLayout()
    
    var anchorThumbConstraint: NSLayoutConstraint?
    
    var components = [ComponentView]()
    
    /// numberOfSegments is the number of segments.
    /// Note: Please note that if you have set the segmentValues this will be overridden.
    /// If the segments are of uniform length its recommended to set only the number of segements.
    /// In other case please use segment values to achieve the non-uniform segment lengths.
    /// - Since: 2017.5.0
    @IBInspectable
    public var numberOfSegments: Int {
        get {
            return _numberOfSegments - 1
        }
        set {
            _numberOfSegments = newValue < 0 ? 1 : newValue
            var equalSegmentValues = [CGFloat]()
            for segment in 0..._numberOfSegments {
                equalSegmentValues.append(CGFloat(segment)/CGFloat(_numberOfSegments))
            }
            segmentValues = equalSegmentValues
            rearrangeSegments()
        }
    }
    
    /// interSegmentColor is the color between the segment. Default value is `UIColor.clear`
    /// in other please specify the color.
    /// - Since: 2017.5.0
    public var interSegmentColor: UIColor = .clear {
        didSet {
            components.forEach { $0.interSegmentColor = interSegmentColor }
        }
    }
    
    /// PhilipsUIKitDLS Theme Reference.
    /// Default value is UIDThemeManager's defaultTheme.
    /// - Since: 2017.5.0
    open var theme: UIDTheme? = UIDThemeManager.sharedInstance.defaultTheme {
        didSet {
            configureTheme()
        }
    }
    
    /// segmentValues is an array ranging from value between 0 to 1.
    /// This can be used if you need the segment of non-uniform length.
    /// If you tend to set this, please do not set the number of segments.
    /// This will be automatically calculated.
    /// Usage: segmentValues = [0, 0.5, 1], will result in slider with
    /// 2 segments(0 to 0.5 and 0.5 to 1).
    /// - Since: 2017.5.0
    public var segmentValues: [CGFloat] = [] {
        didSet {
            guard segmentValues.count == 0 else {
                setupSegmentsArray()
                _numberOfSegments = _segmentValues.count
                return
            }
        }
    }
    
    // swiftlint:disable identifier_name
    var _segmentValues: [CGFloat] = [] {
        didSet {
            _numberOfSegments = _segmentValues.count
            rearrangeSegments()
        }
    }
    
    var _selectedSegment: Int = 0
    
    var _numberOfSegments: Int = 1
    // swiftlint:enable identifier_name
    
    var jumpValues: [CGFloat] = [0]
    
    /// selectedSegment is an float ranging from 0 to 1. If the selectedSegment value is
    /// different than that of the segmentValues, the closest one will be selected.
    /// Usage selectedSegement = 0.6, selectedValues = [0, 0.5, 1], the first segment will
    /// be highlighted.
    /// - Since: 2017.5.0
    @IBInspectable
    public var selectedSegment: CGFloat {
        get {
            return jumpValues[_selectedSegment]
        } set {
            _selectedSegment = closestIndex(for: newValue)
            selectFragment(value: _selectedSegment, animated: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) { [weak self] in
                self?.onFlyThumbAnchorConstraint()
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
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        instanceInit()
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        instanceInit()
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: UIDSize24*2)
    }
    
    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let currentPosition = touch.location(in: self)
        sendActions(for: .touchDown)
        thumb.highLightThumb(highlight: true, animated: false)
        finalizeSegmentTo(nearestPoint: currentPosition)
        return true
    }
    
    override open func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let currentPosition = touch.location(in: self)
        sendActions(for: .valueChanged)
        finalizeSegmentTo(nearestPoint: currentPosition)
        return true
    }
    
    override open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        sendActions(for: .valueChanged)
        endThumbMovement()
    }
    
    override open func cancelTracking(with event: UIEvent?) {
        endThumbMovement()
    }
}

extension UIDDiscreteSlider {
    func finalizeSegmentTo(nearestPoint: CGPoint) {
        let nearEdgeIndex = tracedSegment(forPoint: nearestPoint)
        moveToSegment(value: nearEdgeIndex, animated: false)
        onFlyThumbAnchorConstraint()
    }
    
    func endThumbMovement() {
        onFlyThumbAnchorConstraint()
        thumb.highLightThumb(highlight: false, animated: false)
    }
    
    func tracedSegment(forPoint point: CGPoint) -> Int {
        let endXPoints = components.map {
            LayoutDirection.isRightToLeft ? $0.frame.origin.x : $0.frame.size.width + $0.frame.origin.x
        }
        var deviationSpaces = endXPoints.map {abs($0 - point.x + contentView.frame.origin.x)}
        let nearEdgeIndex = deviationSpaces.indices.filter { deviationSpaces[$0] == deviationSpaces.min() }.first ?? 0
        return nearEdgeIndex
    }
    
    func updateHighlightedState(forSegementIndex segmentIndex: Int) {
        self.components[0...segmentIndex].forEach { $0.isHighlighted = true}
        self.components[segmentIndex+1..<self.components.count].forEach {$0.isHighlighted = false}
    }
    
    func selectFragment(value: Int, animated: Bool = false) {
        guard value < components.count else { return }
        let taskClosure = { [weak self] in self?.updateHighlightedState(forSegementIndex: value) }
        animated ? (UIView.animate(withDuration: 0.5) { taskClosure() }) : taskClosure()
    }
    
    func instanceInit() {
        addSubviews([contentView, thumb])
        configureContentView()
        configureThumb()
        interSegmentColor = { return interSegmentColor }()
        numberOfSegments = { return numberOfSegments == 0 ? 1 : numberOfSegments }()
        selectedSegment = { return selectedSegment }()
        configureTheme()
    }
    
    func configureTheme() {
        backgroundColor = .clear
        components.forEach { $0.theme = theme }
        thumb.theme = theme
    }
    
    func setupSegmentsArray() {
        guard !segmentValues.contains(where: { $0 > 1 || $0 < 0 }) else {
            _segmentValues = [1]
            _selectedSegment = 0
            return
        }
        let sortedSegments = segmentValues.sorted()
        var deltaArray: [CGFloat] = [sortedSegments.first ?? 0]
        for index in 0..<sortedSegments.count - 1 {
            let segmentDelta = sortedSegments[index + 1] - sortedSegments[index]
            deltaArray.append(segmentDelta)
        }
        if let lastSortedValue = sortedSegments.last, lastSortedValue != 1 {
            deltaArray.append(1 - lastSortedValue)
        }
        jumpValues = sortedSegments
        jumpValues.insert(0, at: 0)
        jumpValues.append(1)
        
        _segmentValues = deltaArray
    }
    
    func configureContentView() {
        [contentView, thumb].forEach { $0.isUserInteractionEnabled = false }
        let bindingViewsInfo: [String:UIView] = ["mainContentView": contentView]
        var visualConstraints = [String]()
        visualConstraints.append("H:|-\(UIDSize24)-[mainContentView]-\(UIDSize24)-|")
        contentView.constrain(toHeight: UIDSize8/2)
        contentView.constrainVerticallyCenteredToParent()
        visualConstraints.activateVisualConstraintsWith(views: bindingViewsInfo)
    }
    
    func configureThumb() {
        thumb.constrainVerticallyCenteredToParent()
    }
    
    func rearrangeSegments() {
        contentView.removeAllSubviews()
        components = []
        
        var previousComponent = contentView
        
        let headComponent = ComponentView.makePreparedForAutoLayout()
        components.append(headComponent)
        contentView.addSubview(headComponent)
        let bindingViewsInfo: [String:UIView] = ["headComponent": headComponent]
        let visualConstraints: [String] = ["V:|[headComponent]|", "H:|[headComponent(0)]"]
        visualConstraints.activateVisualConstraintsWith(views: bindingViewsInfo)
        
        for segment in 0..<_numberOfSegments {
            let fragmentWidth: CGFloat
            fragmentWidth = _segmentValues[segment]
            let component = ComponentView.makePreparedForAutoLayout()
            components.append(component)
            contentView.addSubview(component)
            let bindingViewsInfo: [String:UIView] = ["component": component,
                                                     "previousComponent": previousComponent]
            var visualConstraints = [String]()
            visualConstraints.append("V:|[component]|")
            if segment == 0 {
                visualConstraints.append("H:|[component]")
                component.alignment = .leading
            } else {
                component.alignment = segment == _numberOfSegments - 1 ? .trailing : .middle
                visualConstraints.append("H:[previousComponent][component]")
            }
            visualConstraints.activateVisualConstraintsWith(views: bindingViewsInfo)
            
            NSLayoutConstraint(item: component, attribute: .width,
                               relatedBy: .equal,
                               toItem: contentView, attribute: .width, multiplier: fragmentWidth,
                               constant: 0).isActive = true
            previousComponent = component
        }
        
        configureTheme()
    }
    
    func deactivateThumbPositioningConstraints() {
        anchorThumbConstraint.ifNotNil { NSLayoutConstraint.deactivate([$0]) }
        anchorThumbConstraint = nil
    }
    
    func onFlyThumbAnchorConstraint() {
        let anchorSegment = _selectedSegment < components.count ? _selectedSegment : 0
        deactivateThumbPositioningConstraints()
        let anchorConstraint = NSLayoutConstraint(item: thumb, attribute: .centerX,
                                                  relatedBy: .equal,
                                                  toItem: components[anchorSegment],
                                                  attribute: LayoutDirection.isRightToLeft ? .left : .right,
                                                  multiplier: 1, constant: 0)
        anchorConstraint.isActive = true
        anchorThumbConstraint = anchorConstraint
    }
    
    func moveToSegment(value: Int, animated: Bool) {
        selectFragment(value: value, animated: animated)
        if _selectedSegment != value {
            _selectedSegment = value
            sendActions(for: .valueChanged)
        }
    }
    
    func closestIndex(for value: CGFloat) -> Int {
        var smallestDiff = abs(value - jumpValues[0])
        var closest: Int = 0
        for jumpValue in 0..<jumpValues.count {
            let currentDiff = abs(value - jumpValues[jumpValue])
            if currentDiff < smallestDiff {
                smallestDiff = currentDiff
                closest = jumpValue
            }
        }
        return closest
    }
}
