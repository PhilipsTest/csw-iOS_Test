/** © Koninklijke Philips N.V., 2016. All rights reserved. */

import Foundation

/// UIDActionStyle denotes the style of a DLS alert action
///
/// - primary: used for the primary action, gives a primary style button
/// - secondary: used for secondary behavior, gives a secondary style button
/// - quiet: used for cancel-like behavior, gives a quiet style button
/// - Since: 3.0.0
@objc
public enum UIDActionStyle: Int {
    /// - Since: 3.0.0
    case primary
    /// - Since: 3.0.0
    case secondary
    /// - Since: 3.0.0
    case quiet
}

/// A UIDAction object represents an action that can be taken when tapping a button in an
/// alert. You use this class to configure information about a single action, including the title 
/// to display in the button, any styling information, and a handler to execute when the user taps 
/// the button. After creating an alert action object, add it to a UIDAlertController object before
/// displaying the corresponding alert to the user.
/// - Important:
/// Working is similar to UIKit's UIAlertAction
/// - Since: 3.0.0
@objcMembers open class UIDAction: NSObject {
    
    /// The title of the action’s button.
    /// This property is set to the value you specified in the `init(title:style:handler:)` method.
    /// - Since: 3.0.0
    open private(set) var title: String?
    
    /// The style that is applied to the action’s button.
    /// This property is set to the value you specified in the `init(title:style:handler:)` method.
    /// - Since: 3.0.0
    open private(set) var style: UIDActionStyle = .primary
    
    /// The handler that is called whenever the button associated with the action is tapped.
    /// This property is set to the value you specified in the `init(title:style:handler:)` method.
    /// - Since: 3.0.0
    open private(set) var handler: ((UIDAction) -> Void)?
    
    /// Constructor that sets title, style and handler. When these parameters are supplied, 
    /// the UIDAction is properly set up to be added to UIDAlertController.
    ///
    /// - Parameters:
    ///   - title: title label of the action button
    ///   - style: style of the action button
    ///   - handler: code to be executed when the action button is tapped
    /// - Since: 3.0.0
   @objc public convenience init(title: String?, style: UIDActionStyle, handler: ((UIDAction) -> Void)? = nil) {
        self.init()
        self.title = title
        self.style = style
        self.handler = handler
    }
}
