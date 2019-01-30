//  Copyright © 2018 Philips. All rights reserved.

import UIKit
import PhilipsUIKitDLS

class HelpTextViewController: BaseViewController {
    @IBOutlet weak var helpTextView: UITextView!
    @IBOutlet weak var helpTextTitle: UILabel!
    var textToDisplay : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* Title can also be set while pushing/presenting this view controller,
           we are setting it from string files if its not set */
        if self.title == nil {
            self.title = "csw_privacy_settings".localized
        }
        setText()
        setLayoutForText()
    }
    
    private func setLayoutForText() {
        helpTextView.textContainerInset = UIEdgeInsets.zero
        helpTextView.textContainer.lineFragmentPadding = 0
    }
    
    private func setText() {
        let titleAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.font : UIFont.init(uidFont: UIDFont.bold, size: 20)!,
            NSAttributedStringKey.foregroundColor : UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText as Any]
        
        let title = NSAttributedString(string: "csw_consent_help_label".localized, attributes: titleAttributes)
        helpTextTitle.attributedText = title
        
        guard let descriptionText = textToDisplay else { return }
        let descriptionAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.font : UIFont.init(uidFont: UIDFont.book, size: 16)!,
            NSAttributedStringKey.foregroundColor : UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText as Any]
        let description = NSAttributedString(string: descriptionText, attributes: descriptionAttributes)
        helpTextView.attributedText = description
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        helpTextView.setContentOffset(.zero, animated: false)
    }
}
