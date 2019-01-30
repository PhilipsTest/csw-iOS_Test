/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

/// UIDDialogCallBackDelegate: call backs for events.
///
/// - Since: 2018.1.0
@objc
public protocol UIDDialogCallBackDelegate {
    
    /// call when the close button is tapped.
    func closeIconTapped()
}

/// UIDDialogBackgroundStyle denotes the style of a DLS alert action
///
/// - subtle: dim layer will be less prominent
/// - strong: dim layer will be more prominent
///
/// - Since: 3.0.0
@objc
public enum UIDDialogBackgroundStyle: Int {
    /// - Since: 3.0.0
    case subtle
    /// - Since: 3.0.0
    case strong
}

/// A UIDDialogController object displays an dialog to the user.
/// configuring the dialog controller with the actions and style you want, present it using the
/// `present(_:animated:completion:)` method.
///
/// In addition to displaying a message to a user, you can associate actions with your dialog
/// controller to give the user a way to respond. For each action you add using the `addAction(_:)`
/// method, the dialog controller configures a button with the action details. When the user taps
/// that action, the dialog controller executes the block you provided when creating the action
/// object. Listing 1 shows how to configure an dialog with a single action.
///
/// **Listing 1** Configuring and presenting an dialog
/// ````
/// let dialog = UIDDialogController(title: "My dialog", icon: UIImage())
///
/// defaultAction = UIDdialogAction(title: "OK", style: .default) { action in
///     print("Action button \(action.title) tapped")
/// }
/// dialog.addAction(defaultAction)
///
/// self.present(dialog, animated: true, completion: nil)
/// ````
///
/// - Since: 3.0.0
@objcMembers open class UIDDialogController: UIViewController {
    
    fileprivate var presentationBackgroundColor: UIColor?
    /// - Since: 3.0.0
    open var backgroundStyle: UIDDialogBackgroundStyle = .strong {
        didSet {
            presentationBackgroundColor = (backgroundStyle == .strong) ? theme?.dimLayerStrongBackground
                : theme?.dimLayerSubtleBackground
        }
    }
    
    /// UIDTheme used for styling the dialog controller.
    /// By default it takes the theme set in UIDThemeManager.sharedInstance.
    /// - Since: 3.0.0
    open var theme: UIDTheme? = UIDThemeManager.sharedInstance.whiteTheme {
        didSet {
            dialogView?.theme = theme
            if let presentationController = presentationController as? AlertPresentationController {
                presentationController.theme = theme
                presentationBackgroundColor = theme?.dimLayerStrongBackground
            }
        }
    }
    
    /// The actions that the user can take in response to the dialog.
    ///
    /// The actions are in the order in which you added them to the dialog controller. This order also corresponds to the
    /// order in which they are displayed in the dialog. The second action in the array is displayed below or to the
    /// right of the first, the third is displayed below or to the right of the second, and so on. Actions can be added
    /// using `addAction(_:)`.
    /// - Since: 3.0.0
     open private(set) var actions: [UIDAction] = []
    
    /// The title of the dialog.
    ///
    /// The title string is displayed prominently in the dialog. You should use this string to get the user’s attention
    /// and communicate the reason for displaying the dialog.
    /// - Since: 3.0.0
    open override var title: String? {
        didSet {
            self.dialogView?.title = title
        }
    }
    
    /// Descriptive icon that emphasises the purpose of the dialog.
    ///
    /// The icon is shown to the left of the title, and its color is themed along with the title text.
    /// - Since: 3.0.0
    open var icon: UIImage? {
        didSet {
            self.dialogView?.image = icon
        }
    }
    
    /// Content Container for encapsulating view in the dialog.
    ///
    /// The content container should have intrinsic size. If content is too big, its recommended
    /// to put inside scrollview with height constriant
    /// set and also priority to UILayoutPriorityDefaultHigh
    /// @note: if height priority is set to UILayoutPriorityRequired then it might be breaking layout.
    /// - Since: 3.0.0
    open var containerView: UIView? {
        didSet {
            self.dialogView?.contentView = containerView
        }
    }
    
    /// Handles the visibility of the close icon. When tapped it dismisses the dialog
    ///
    /// Default is false
    /// - Since: 3.0.0
    open var isCloseIconVisible: Bool = false {
        didSet {
            self.dialogView?.isCloseVisible = isCloseIconVisible
            guard let closeButton = self.dialogView?.titleContentView.closeButton else { return }
            if closeButton.allTargets.count == 0 {
                closeButton.addTarget(self, action: #selector(dismisDialog), for: .touchUpInside)
                closeButton.addTarget(self, action: #selector(closeIconTapped), for: .touchUpInside)
            }
        }
    }
    
    /// Handles the visibility of the close icon. When tapped it dismisses the dialog
    ///
    /// Default is false
    /// - Since: 3.0.0
    open var isSeparatorVisible: Bool = false {
        didSet {
            self.dialogView?.isSeparatorVisible = isSeparatorVisible
        }
    }
    
    /// Width of the dialog can be dictated here.
    ///
    /// By default fills the entire width of the screen.
    /// - Since: 3.0.0
    open var maxWidth = max(UIScreen.main.bounds.maxX, UIScreen.main.bounds.maxY) {
        didSet {
            self.dialogView?.maxWidth = maxWidth
        }
    }
    
    /// Delegate for the UIDDialogCallBackDelegate
    ///
    /// - Since: 2018.1.0
    open weak var delegate: UIDDialogCallBackDelegate?
    
    var dialogView: DialogView? {
        return self.view as? DialogView
    }
    
    var dialogButtonInfo: [UIDButton: UIDAction] = [:]
    
    private var isActionsTranslated = false
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    /// Creates and returns a view controller for displaying an dialog to the user.
    /// After creating the dialog controller, configure any actions that you want the user to be able to perform by
    /// calling the `addAction(_:)` method one or more times.
    ///
    /// - Parameters:
    ///   - title: The title of the dialog.
    ///  Use this string to get the user’s attention and communicate the reason for the dialog.
    ///   - icon: Icon that emphasises the reason for the dialog.
    ///   - backgroundStyle: background can be subtle or strong.
    /// - Since: 3.0.0
    public convenience init(title: String?, icon: UIImage? = nil, backgroundStyle: UIDDialogBackgroundStyle = .strong) {
        self.init(nibName: nil, bundle: nil)
        ({
            self.title = title
            self.icon = icon
        })()
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        instanceInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        instanceInit()
    }
    
    private func instanceInit() {
        transitioningDelegate = self
        modalPresentationStyle = .custom
        backgroundStyle = {return backgroundStyle}()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isActionsTranslated {
            translateActionsToButtons()
            self.dialogView?.arrangeContent()
            isActionsTranslated = true
        }
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        transitioningDelegate = nil
    }
    
    override open func loadView() {
        self.view = DialogView(frame: UIScreen.main.bounds)
    }
    
    /// Attaches an action object to the dialog.
    /// If your dialog has multiple actions, the order in which you add those actions determines their order in
    /// the resulting dialog.
    ///
    /// - Parameter action: The action object to display as part of the dialog.
    /// Actions are displayed as buttons in the dialog. The action object provides the button text and
    /// the action to be performed when that button is tapped.
    /// - Since: 3.0.0
   open func addAction(_ action: UIDAction) {
        if !actions.contains(action) {
            actions.append(action)
        }
    }
    
    private func translateActionsToButtons() {
        let buttonTypeHandler: (UIDActionStyle) -> UIDButtonType = { actionType in
            switch actionType {
            case .primary:
                return .primary
            case .secondary:
                return .secondary
            case .quiet:
                return .quiet
            }
        }
        
        var buttons: [UIDButton] = []
        for action in actions {
            let button = UIDButton.makePreparedForAutoLayout()
            button.theme = UIDThemeManager.sharedInstance.whiteTheme
            
            button.philipsType = buttonTypeHandler(action.style)
            dialogButtonInfo[button] = action
            button.addTarget(self, action: #selector(actionItemPressed(sender:)), for: .touchUpInside)
            button.setTitle(action.title, for: .normal)
            buttons.append(button)
        }
        self.dialogView?.actionButtons = buttons
    }
    
    func actionItemPressed(sender: UIDButton) {
        guard let action = dialogButtonInfo[sender] else {
            return
        }
        dismissDialogFrom(action: action)
    }
    
    func dismissDialogFrom(action: UIDAction) {
        dismiss(animated: true, completion: {
            action.handler?(action)
        })
    }
    
    func dismisDialog() {
        dismiss(animated: true, completion: nil)
    }
    
    func closeIconTapped() {
        delegate?.closeIconTapped()
    }
}

extension UIDDialogController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController,
                                    presenting: UIViewController,
                                    source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AlertAnimationHandler(layoutAppearing: true)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AlertAnimationHandler(layoutAppearing: false)
    }
    
    public func presentationController(forPresented presented: UIViewController,
                                       presenting: UIViewController?,
                                       source: UIViewController) -> UIPresentationController? {
        let presentationController = AlertPresentationController(presentedViewController: presented,
                                                                 presenting: presenting)
        presentationController.backgroundView.backgroundColor = presentationBackgroundColor
        return presentationController
    }
}

