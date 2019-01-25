/** © Koninklijke Philips N.V., 2016. All rights reserved. */

import UIKit

let maxWidthOfAlert: CGFloat = 272
let paddingMinYScreenEdge: CGFloat = 24

/// A UIDAlertController object displays an alert message to the user. This class replaces the
/// PUIModalAlert class for displaying alerts, and resembled UIKit's UIAlertController. After
/// configuring the alert controller with the actions and style you want, present it using the
/// `present(_:animated:completion:)` method.
///
/// In addition to displaying a message to a user, you can associate actions with your alert
/// controller to give the user a way to respond. For each action you add using the `addAction(_:)`
/// method, the alert controller configures a button with the action details. When the user taps
/// that action, the alert controller executes the block you provided when creating the action
/// object. Listing 1 shows how to configure an alert with a single action.
///
/// **Listing 1** Configuring and presenting an alert
/// ````
/// let alert = UIDAlertController(title: "My Alert", message: "This is an alert.")
///
/// defaultAction = UIDAction(title: "OK", style: .default) { action in
///     print("Action button \(action.title) tapped")
/// }
/// alert.addAction(defaultAction)
///
/// self.present(alert, animated: true, completion: nil)
/// ````
///
/// - Since: 3.0.0
@objcMembers open class UIDAlertController: UIDDialogController {
    /// Descriptive text that provides more details about the reason for the alert.
    ///
    /// The message string is displayed below the title string and is less prominent. Use this string to provide
    /// additional context about the reason for the alert or about the actions that the user might take.
    /// - Since: 3.0.0
     open var message: String? {
        didSet {
            alertTextView.text = message
            self.setUpAlertTextView()
        }
    }
    
    /// Descriptive text that provides more details about the reason for the alert.
    ///
    /// The attributed message is displayed below the title string and is less prominent. Use this text to provide
    /// additional context about the reason for the alert or about the actions that the user might take.
    /// - Since: 2018.3.0
    open var attributedMessage: NSAttributedString? {
        didSet {
            alertTextView.attributedText = attributedMessage
            self.setUpAlertTextView()
        }
    }
    
    let alertTextView: AlertTextView = AlertTextView.makePreparedForAutoLayout()
    
    /// Creates and returns a view controller for displaying an alert to the user.
    /// After creating the alert controller, configure any actions that you want the user to be able to perform by
    /// calling the `addAction(_:)` method one or more times.
    ///
    /// - Parameters:
    ///   - title: The title of the alert.
    ///  Use this string to get the user’s attention and communicate the reason for the alert.
    ///   - icon: Icon that emphasises the reason for the alert.
    ///   - message: Descriptive text that provides additional details about the reason for the alert.
    /// - Since: 3.0.0
    public convenience init(title: String?, icon: UIImage? = nil, message: String?) {
        self.init(nibName: nil, bundle: nil)
        ({
            self.title = title
            self.message = message
            self.icon = icon
        })()
    }
    
    /// Creates and returns a view controller for displaying an alert to the user.
    /// After creating the alert controller, configure any actions that you want the user to be able to perform by
    /// calling the `addAction(_:)` method one or more times.
    ///
    /// - Parameters:
    ///   - title: The title of the alert.
    ///  Use this string to get the user’s attention and communicate the reason for the alert.
    ///   - icon: Icon that emphasises the reason for the alert.
    ///   - attributedMessage: Descriptive text that provides additional details about the reason for the alert.
    /// - Since: 2018.3.0
    public convenience init(title: String?, icon: UIImage? = nil, attributedMessage: NSAttributedString?) {
        self.init(nibName: nil, bundle: nil)
        ({
            self.title = title
            self.attributedMessage = attributedMessage
            self.icon = icon
        })()
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func loadView() {
        super.loadView()
        setupContentBehaviourConstraints()
    }
}

extension UIDAlertController {
    func setupContentBehaviourConstraints() {
        let maximumWidth = max(UIScreen.main.bounds.width * 0.2, maxWidthOfAlert)
        if let mainContentView = self.dialogView?.mainContentView,
            let view = self.dialogView {
            mainContentView.constrain(toWidth: maximumWidth)
            mainContentView.constrainCenterToParent()
            
            let maxAlertHeightConstraint = NSLayoutConstraint(item: mainContentView,
                                                              attribute: .height,
                                                              relatedBy: .lessThanOrEqual,
                                                              toItem: view, attribute: .height,
                                                              multiplier: 1.0, constant: -paddingMinYScreenEdge * 2)
            view.addConstraint(maxAlertHeightConstraint)
            
            let constraint = NSLayoutConstraint(item: view.explanatoryStackView,
                                                attribute: .height,
                                                relatedBy: .lessThanOrEqual,
                                                toItem: mainContentView, attribute: .width,
                                                multiplier: 0.9,
                                                constant:0)
            view.addConstraint(constraint)
            
            let edgeInsets = UIEdgeInsets(top: 0, left: paddingXEdgeToContainer,
                                          bottom: spacingTitleToContainer,
                                          right: paddingXEdgeToContainer)
            view.containerStackView.isLayoutMarginsRelativeArrangement = true
            view.containerStackView.layoutMargins = edgeInsets
            view.layoutIfNeeded()
        }
    }
    
    fileprivate func setUpAlertTextView() {
        self.dialogView?.contentView = alertTextView
        alertTextView.textColor = theme?.contentItemPrimaryText
        alertTextView.backgroundColor = .clear
        alertTextView.contentOffset = CGPoint(x: 0, y: 1)
        alertTextView.contentOffset = CGPoint(x: 0, y: 0)
    }
}
