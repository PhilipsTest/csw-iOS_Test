/* Copyright (c) Koninklijke Philips Electronics N.V. 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class UIDPickerDelegateProxy: NSObject {
    var theme: UIDTheme? = UIDThemeManager.sharedInstance.defaultTheme
    
    weak var delegate: AnyObject?
    
    //mark: Forward invocation
    override func responds(to aSelector: Selector!) -> Bool {
        return super.responds(to: aSelector) ? true : (self.delegate?.responds(to:aSelector) ?? false)
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if let delegate = self.delegate, delegate.responds(to:aSelector) == true {
            return self.delegate
        }
        return super.forwardingTarget(for: aSelector)
    }
}

extension UIDPickerDelegateProxy: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int,
                    forComponent component: Int, reusing view: UIView?) -> UIView {
        if let view = self.delegate?.pickerView?(pickerView, viewForRow: row,
                                                 forComponent: component, reusing: view) {
            return view
        }
        let label = view as? UIDLabel ?? UIDLabel()
        label.textColor = theme?.pickerIosDefaultPickerText
        label.textAlignment = .center
        label.text = delegate?.pickerView?(pickerView, titleForRow: row, forComponent: component) ?? ""
        return label
    }
}
