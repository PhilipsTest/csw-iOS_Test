/** © Koninklijke Philips N.V., 2017. All rights reserved. */

import UIKit

/// - Since: 3.0.0
@objcMembers open
class UIDTableViewController: UITableViewController {
    /**
     * PhilipsUIKitDLS Theme Reference.
     *
     * Default value is UIDThemeManager's defaultTheme.
     *
     * - Since: 3.0.0
     */
    open var theme = UIDThemeManager.sharedInstance.defaultTheme {
        didSet {
            configureView()
        }
    }
    
    /**
     * The type of the backgroundColor.
     * Updates the background color when set.
     *
     * Default value is UIDViewBackgroundColorType.primary
     *
     * - Since: 3.0.0
     */
    public var backgroundColorType: UIDViewBackgroundColorType = .primary {
        didSet {
            configureView()
        }
    }
    
    private func configureView() {
        guard let theme = theme else {
            return
        }
        
        var backgroundColor = view.backgroundColor
        switch backgroundColorType {
        case .secondary:
            backgroundColor = theme.contentSecondary
        case .primary:
            backgroundColor = theme.contentPrimary
        }
        view.backgroundColor = backgroundColor
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        let headerFooterReuseIdentifier = String(describing: UIDTableViewHeaderView.self)
        tableView.register(UIDTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: headerFooterReuseIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = true
        configureView()
    }

    // MARK: - Table view data source
    override open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIDTableViewHeaderHeight
    }
    
    override open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerFooterReuseIdentifier = String(describing: UIDTableViewHeaderView.self)
        let reusableHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerFooterReuseIdentifier)
        guard let header =  reusableHeader as? UIDTableViewHeaderView
            else {
                return nil
        }
        
        header.titleLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        return header
    }
}
