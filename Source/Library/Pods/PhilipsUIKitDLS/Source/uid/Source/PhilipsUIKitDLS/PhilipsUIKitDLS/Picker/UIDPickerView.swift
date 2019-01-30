/* Copyright (c) Koninklijke Philips Electronics N.V. 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

/// A UIDPicker object useda as a drop down/picker for the user. This class replaces the
/// UIDPickerView class for displaying dropdowns
/// - Since: 3.0.0
@objcMembers open class UIDPickerView: UIPickerView {
    fileprivate let proxy = UIDPickerDelegateProxy()
    
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
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        instanceInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
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
    
    func instanceInit() {
        backgroundColor = UIColor.clear
        tintColor = UIColor.clear
        configureTheme()
    }
    
    override weak open var delegate: UIPickerViewDelegate? {
        didSet {
            if delegate !== proxy {
                proxy.delegate = delegate
                delegate = proxy
            }
        }
    }
    
    func configureTheme() {
        guard let theme = theme else { return }
        proxy.theme = theme
        reloadAllComponents()
    }
}
