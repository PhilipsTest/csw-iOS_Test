/** © Koninklijke Philips N.V., 2016. All rights reserved. */

import Foundation

/**
 * The types of progressIndicator (UIDProgressIndicator) that are available.
 * In code, you should use these types. Unfortunately, Interface Builder doesn't support enums yet,
 * so if you configure the progressIndicator in Interface Builder, you have to use the numeric values.
 *
 * - Since: 3.0.0
 */
@objc
public enum UIDProgressIndicatorType: Int {
    /// Circular ProgressIndicator: (numerical value: 0)
    /// - Since: 3.0.0
    case circular
    /// Linear ProgressIndicator: (numerical value: 1)
    /// - Since: 3.0.0
    case linear
}

/**
 * The styles of progressIndicator (UIDProgressIndicator) that are available.
 * In code, you should use these styles. Unfortunately, Interface Builder doesn't support enums yet,
 * so if you configure the progressIndicator in Interface Builder, you have to use the numeric values.
 *
 * - Since: 3.0.0
 */
@objc
public enum UIDProgressIndicatorStyle: Int {
    /// Determinate ProgressIndicator: (numerical value: 0)
    /// - Since: 3.0.0
    case determinate
    /// Indeterminate ProgressIndicator: (numerical value: 1)
    /// - Since: 3.0.0
    case indeterminate
}

/**
 * The sizes of circular progressIndicator (UIDProgressIndicator) that are available.
 * In code, you should use these sizes. Unfortunately, Interface Builder doesn't support enums yet,
 * so if you configure the progressIndicator in Interface Builder, you have to use the numeric values.
 *
 * @note As per DLS design guideline    small circular progressIndicator size should be 24px * 24px.
 *                                      medium circular progressIndicator size size should be 48px * 48px.
 *                                      large circular progressIndicator size size should be 88px * 88px.
 *
 * - Since: 3.0.0
 */
@objc
public enum UIDCircularProgressIndicatorSize: Int {
    /// Circular Small ProgressIndicator: (numerical value: 0)
    /// - Since: 3.0.0
    case small
    /// Circular Medium ProgressIndicator: (numerical value: 1)
    /// - Since: 3.0.0
    case medium
    /// Circular Large ProgressIndicator: (numerical value: 2)
    /// - Since: 3.0.0
    case large
}

/**
 *  A UIDProgressIndicator is the standard progress-indicator to use.
 *  In InterfaceBuilder it is possible to create a UIView and give it the class UIDProgressIndicator,
 *  the styling will be done immediately.
 *
 *  @note Runtime change in UIDProgressIndicatorType, UIDProgressIndicatorStyle & UIDCircularProgressIndicatorSize
    won't effect the progress-indicator drawing.
 *
 *  - Since: 3.0.0
 */
@IBDesignable
@objcMembers open class UIDProgressIndicator: UIView {
    
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
            configureProgressIndicator()
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
            configureProgressIndicator()
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
    open var circularProgressIndicatorSize: UIDCircularProgressIndicatorSize = .small {
        didSet {
            configureProgressIndicator()
        }
    }
    // swiftlint:enable valid_ibinspectable
    
    /**
     * The UIDTheme of the progressIndicator.
     * Updates the progressIndicator styling when set.
     *
     * Defaults to UIDThemeManager.sharedInstance.defaultTheme
     *
     * - Since: 3.0.0
     */
    open var theme: UIDTheme? = UIDThemeManager.sharedInstance.defaultTheme {
        didSet {
            configureProgressIndicator()
        }
    }
    
    /**
     * Set the progress of the progressIndicator.
     * Updates the 'determinate' progressIndicator progress.
     *
     * Defaults to 0.0
     *
     * @note Pass a float number between 0.0 and 1.0 which will equivalent to 0% - 100%.
     * - Since: 3.0.0
     */
    open var progress: CGFloat = 0.0 {
        didSet {
            progress = CGFloat(min(1.0, max(0.0, Double(progress))))
            configureProgressIndicator()
        }
    }
    
    /**
     * Start animating 'indeterminate' progressIndicator.
     *
     * - Since: 3.0.0
     */
    open func startAnimating() {
        self.isAnimating = true
        self.isHidden = false
    }
    
    /**
     * Stop animating 'indeterminate' progressIndicator.
     *
     * - Since: 3.0.0
     */
    open func stopAnimating() {
        self.isAnimating = false
        self.isHidden = self.hidesWhenStopped
    }
    
    /**
     * Check 'indeterminate' progressIndicator animating status.
     *
     * Default is 'false'
     *
     * - Since: 3.0.0
     */
    open private(set) var isAnimating: Bool = false {
        didSet {
            configureProgressIndicator()
        }
    }
    
    /**
     * Useful If user want to hide 'indeterminate' progressIndicator when stopped animating.
     *
     * Default is 'true'
     *
     * - Since: 3.0.0
     */
    @IBInspectable
    open var hidesWhenStopped: Bool = true
    
    /**
     * Useful Internal Property for 'determinate' & 'indeterminate' progressIndicator.
     */
    var backgroundShapeLayer: CAShapeLayer?
    var progressShapeLayer: CAShapeLayer?
    var indeterminateGradientLayer: CALayer?
    var circularAnimation: CircularProgressIndicatorAnimation?
    
    override open var intrinsicContentSize: CGSize {
        switch self.progressIndicatorType {
        case .circular:
            return circularProgressIndicatorSize.intrinsicContentSize
        case .linear:
            return CGSize(width: super.intrinsicContentSize.width, height: UIDProgressIndicatorHeight)
        }
    }
    
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
    
    func instanceInit() {
        self.clipsToBounds = true
        self.backgroundColor = UIColor.clear
        addObservers()
        configureProgressIndicator()
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidEnterForeground),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidEnterBackground),
                                               name: NSNotification.Name.UIApplicationDidEnterBackground,
                                               object: nil)
    }
    
    func configureProgressIndicator() {
        self.setNeedsDisplay()
    }
    
    override open func draw(_ rect: CGRect) {
        switch self.progressIndicatorType {
        case .circular:
            drawCircularProgressIndicator(rect)
        case .linear:
            drawLinearProgressIndicator(rect)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension UIDProgressIndicator {
    func applicationDidEnterForeground() {
        configureProgressIndicator()
    }
    
    func applicationDidEnterBackground() {
        if let indeterminateGradientLayer = indeterminateGradientLayer {
            circularAnimation?.stopAnimating(indeterminateGradientLayer)
        }
    }
}
