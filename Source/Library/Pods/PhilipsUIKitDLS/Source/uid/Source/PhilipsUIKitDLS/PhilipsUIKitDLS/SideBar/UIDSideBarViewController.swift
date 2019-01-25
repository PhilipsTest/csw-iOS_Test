/* Copyright (c) Koninklijke Philips Electronics N.V. 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

/**
 *  UIDSideBarDelegate is a protocol for SideBar events.
 *  This protocal responsible to send events of SideBar.
 *
 *  - Since: 3.0.0
 */
@objc
public protocol UIDSideBarDelegate: NSObjectProtocol {
    /// Send event when a new viewController will add to SideBar.
    /// - Since: 3.0.0
    @objc
    optional func sideBar(_ sideBar: UIDSideBarViewController,
                          willAddViewController viewController: UIViewController,
                          ofType type: UIDSideBarViewControllerType)
    
    /// Send event when a new viewController added to SideBar.
    /// - Since: 3.0.0
    @objc
    optional func sideBar(_ sideBar: UIDSideBarViewController,
                          didAddViewController viewController: UIViewController,
                          ofType type: UIDSideBarViewControllerType)
    
    /// Send event when SideBar will show.
    /// - Since: 3.0.0
    @objc
    optional func sideBar(_ sideBar: UIDSideBarViewController,
                          willShowSideBarOfType type: UIDSideBarType)
    
    /// Send event when SideBar did show.
    /// - Since: 3.0.0
    @objc
    optional func sideBar(_ sideBar: UIDSideBarViewController,
                          didShowSideBarOfType type: UIDSideBarType)
    
    /// Send event when SideBar will hide.
    /// - Since: 3.0.0
    @objc
    optional func sideBar(_ sideBar: UIDSideBarViewController,
                          willHideSideBarOfType type: UIDSideBarType)
    
    /// Send event when SideBar did hide.
    /// - Since: 3.0.0
    @objc
    optional func sideBar(_ sideBar: UIDSideBarViewController,
                          didHideSideBarOfType type: UIDSideBarType)
}

/// - Since: 3.0.0
@objc
public enum UIDSideBarType: Int {
    /// Left Side: (numerical value: 0)
    /// - Since: 3.0.0
    case left
    /// Right Side: (numerical value: 1)
    /// - Since: 3.0.0
    case right
}

/// - Since: 3.0.0
@objc
public enum UIDSideBarDimLayerType: Int {
    /// Subtle DimLayer: (numerical value: 0)
    /// - Since: 3.0.0
    case subtle
    /// Strong DimLayer: (numerical value: 1)
    /// - Since: 3.0.0
    case strong
}

/// - Since: 3.0.0
@objc
public enum UIDSideBarViewControllerType: Int {
    /// Left ViewController: (numerical value: 0)
    /// - Since: 3.0.0
    case left
    /// Middle ViewController: (numerical value: 1)
    /// - Since: 3.0.0
    case middle
    /// Right ViewController: (numerical value: 2)
    /// - Since: 3.0.0
    case right
}

/// - Since: 3.0.0
@objc
public enum UIDSideBarBackgroundType: Int {
    /// Content Primary: (numerical value: 0)
    /// - Since: 3.0.0
    case contentPrimary
    /// Content Secondary: (numerical value: 1)
    /// - Since: 3.0.0
    case contentSecondary
    /// Navigation Primary: (numerical value: 2)
    /// - Since: 3.0.0
    case navigationPrimary
    /// Navigation Secondary: (numerical value: 3)
    /// - Since: 3.0.0
    case navigationSecondary
}

/**
 *  A UIDSideBarViewController is the standard SideBar to use.
 *  In InterfaceBuilder it is possible to create a UIViewController and give it the class UIDSideBarViewController,
 *  the styling will be done immediately
 *
 *  - Since: 3.0.0
 */
@IBDesignable
@objcMembers open class UIDSideBarViewController: UIViewController {
    public internal(set) var leftViewController: UIViewController?
    public internal(set) var middleViewController: UIViewController?
    public internal(set) var rightViewController: UIViewController?
    
    public internal(set) var leftView: UIView?
    public internal(set) var middleView: UIView?
    public internal(set) var rightView: UIView?
    public internal(set) var opacityView: UIView?
    
    public internal(set) var leftSideBarMenuOriginXConstraint: NSLayoutConstraint?
    public internal(set) var leftSideBarMenuWidthConstraint: NSLayoutConstraint?
    public internal(set) var rightSideBarMenuOriginXConstraint: NSLayoutConstraint?
    public internal(set) var rightSideBarMenuWidthConstraint: NSLayoutConstraint?
    
    weak public var delegate: UIDSideBarDelegate?
    
    var isInitializationDone = false
    var isLeftSideBarVisible = false
    var isRightSideBarVisible = false
    let tapGestureRecognizer = UITapGestureRecognizer()
    
    /**
     * PhilipsUIKitDLS Theme Reference.
     *
     * Default value is UIDThemeManager's defaultTheme.
     *
     * - Since: 3.0.0
     */
    open var theme = UIDThemeManager.sharedInstance.defaultTheme {
        didSet {
            configureTheme()
        }
    }
    
    // swiftlint:disable valid_ibinspectable
    /**
     * The type of the dim-layer.
     * Updates the sidebar dim-layer when set.
     *
     * Defaults to UIDSideBarDimLayerType.none
     *
     * - Since: 3.0.0
     */
    @IBInspectable
    open var dimLayerType: UIDSideBarDimLayerType = .subtle {
        didSet {
            configureTheme()
        }
    }
    
    /**
     * The type of the sideBar Menu background.
     * Updates the sidebar menu background when set.
     *
     * Defaults to UIDSideBarBackgroundType.contentPrimary
     *
     * - Since: 3.0.0
     */
    @IBInspectable
    open var backgroundType: UIDSideBarBackgroundType = .contentPrimary {
        didSet {
            configureTheme()
        }
    }
    // swiftlint:enable valid_ibinspectable
    
    /**
     * Width of the left side-bar menu.
     * Updates the left side-bar width when set.
     *
     * Defaults to "DeviceWidth - NavigationHeight".
     * Max width for iPad & iPhone is 400, 320 respectively.
     *
     * - Since: 3.0.0
     */
    @IBInspectable
    open var leftSideBarWidth: CGFloat = 0 {
        didSet {
            if leftSideBarWidth != oldValue {
                leftSideBarWidth = min(leftSideBarWidth, maximumSideBarWidth)
                refreshSideBarWidth(type: .left)
            }
        }
    }
    
    /**
     * Width of the right side-bar menu.
     * Updates the right side-bar width when set.
     *
     * Defaults to "DeviceWidth - NavigationHeight".
     * Max width for iPad & iPhone is 400, 320 respectively.
     *
     * - Since: 3.0.0
     */
    @IBInspectable
    open var rightSideBarWidth: CGFloat = 0 {
        didSet {
            if rightSideBarWidth != oldValue {
                rightSideBarWidth = min(rightSideBarWidth, maximumSideBarWidth)
                refreshSideBarWidth(type: .right)
            }
        }
    }
    
    /**
     * Max width for iPad & iPhone is 400, 320 respectively.
     *
     * - Since: 3.0.0
     */
    open var maximumSideBarWidth: CGFloat {
        return UIDevice.isIpad ? UIDSideBarIpadWidth : UIDSideBarIphoneWidth
    }
    
    /**
     * Set for shadow visible.
     *
     * Default is "true".
     *
     * - Since: 3.0.0
     */
    @IBInspectable
    open var shouldShadowVisible: Bool = true
    
    /**
     * Custom convenience init of SideBar.
     *
     * - Since: 3.0.0
     */
    public convenience init(leftViewController: UIViewController?,
                            middleViewController: UIViewController,
                            rightViewController: UIViewController?) {
        self.init()
        instanceInit()
        setViewControllers(left: leftViewController, middle: middleViewController, right: rightViewController)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        instanceInit()
    }
    
    open override func showSideBar(_ type: UIDSideBarType) {
        delegate?.sideBar?(self, willShowSideBarOfType: type)
        opacityView?.isHidden = false
        type == .left ? showLeftSideBar() : showRightSideBar()
    }
    
    open override func hideSideBar(_ type: UIDSideBarType) {
        delegate?.sideBar?(self, willHideSideBarOfType: type)
        type == .left ? hideLeftSideBar() : hideRightSideBar()
        opacityView?.isHidden = true
    }
    
    public override func isVisibleSideBar(_ type: UIDSideBarType) -> Bool {
       return type == .left ? isLeftSideBarVisible : isRightSideBarVisible
    }
    
    open override var shouldAutorotate: Bool {
        return middleViewController?.shouldAutorotate ?? true
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return middleViewController?.supportedInterfaceOrientations ?? .all
    }
    
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        rightSideBarMenuOriginXConstraint?.constant = isRightSideBarVisible ? size.width - rightSideBarWidth : size.width
    }
    
    open func refreshSideBarWidth(type: UIDSideBarType) {
        if type == .left {
            leftSideBarMenuWidthConstraint?.constant = leftSideBarWidth
            leftSideBarMenuOriginXConstraint?.constant = -leftSideBarWidth
        } else {
            rightSideBarMenuWidthConstraint?.constant = rightSideBarWidth
        }
    }
}

extension UIDSideBarViewController: UIGestureRecognizerDelegate {
    func instanceInit() {
        if !isInitializationDone {
            var width = UIDevice.width - UIDevice.navigationHeight
            width = min(width, maximumSideBarWidth)
            (leftSideBarWidth, rightSideBarWidth) = (width, width)
            
            leftView = UIView.makePreparedForAutoLayout()
            middleView = UIView.makePreparedForAutoLayout()
            rightView = UIView.makePreparedForAutoLayout()
            opacityView = UIView.makePreparedForAutoLayout()
            opacityView?.isHidden = true
            if let leftView = leftView, let rightView = rightView,
                let middleView = middleView, let opacityView = opacityView {
                view.insertSubview(middleView, at: 0)
                view.insertSubview(opacityView, at: 1)
                view.insertSubview(leftView, at: 2)
                view.insertSubview(rightView, at: 3)

                (leftSideBarMenuOriginXConstraint,
                 leftSideBarMenuWidthConstraint) = view.addSideBarMenuViewConstraints(leftView,
                                                                                      originX: -leftSideBarWidth,
                                                                                      width: leftSideBarWidth)
                (rightSideBarMenuOriginXConstraint,
                 rightSideBarMenuWidthConstraint) = view.addSideBarMenuViewConstraints(rightView,
                                                                                       originX: UIDevice.width,
                                                                                       width: rightSideBarWidth)
                view.addSideBarMainViewConstraints(middleView)
                view.addSideBarMainViewConstraints(opacityView)
            }
            configureTapGesture()
        }
        configureTheme()
    }
    
    func configureTheme() {
        switch dimLayerType {
        case .subtle:
            opacityView?.backgroundColor = theme?.dimLayerSubtleBackground
        case .strong:
            opacityView?.backgroundColor = theme?.dimLayerStrongBackground
        }
        
        switch backgroundType {
        case .contentPrimary:
            leftViewController?.view.backgroundColor = theme?.contentPrimaryBackground
            rightViewController?.view.backgroundColor = theme?.contentPrimaryBackground
        case .contentSecondary:
            leftViewController?.view.backgroundColor = theme?.contentSecondaryBackground
            rightViewController?.view.backgroundColor = theme?.contentSecondaryBackground
        case .navigationPrimary:
            leftViewController?.view.backgroundColor = theme?.navigationPrimaryBackground
            rightViewController?.view.backgroundColor = theme?.navigationPrimaryBackground
        case .navigationSecondary:
            leftViewController?.view.backgroundColor = theme?.navigationSecondaryBackground
            rightViewController?.view.backgroundColor = theme?.navigationSecondaryBackground
        }
    }
    
    func configureTapGesture() {
        tapGestureRecognizer.cancelsTouchesInView = false
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @discardableResult
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchView = touch.view, let opacityView = opacityView {
            if touchView.isDescendant(of: opacityView) {
                hideSideBar()
            }
        }
        return true
    }
    
    func hideSideBar() {
        if isVisibleSideBar(.left) { self.hideSideBar(.left) }
        if isVisibleSideBar(.right) { self.hideSideBar(.right) }
    }
}
