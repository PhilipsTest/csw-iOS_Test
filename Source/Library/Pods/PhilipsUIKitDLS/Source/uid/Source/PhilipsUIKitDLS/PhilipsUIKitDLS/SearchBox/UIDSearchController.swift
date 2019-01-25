/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

/**
 *  A UIDSearchController is the standard Search Controller to use as per DLS guideline.
 *  Creating a Search Controller in Storyboard is still not supported,so this control should be created through code.
 *  This control should be used in order to show search results using UIDSearchBar.
 *
 *  - Since: 3.0.0
 */

@objcMembers open class UIDSearchController: UISearchController {
    
    private var dlsSearchBar: UIDSearchBar!
    private let searchBarIntrinsicHeight: CGFloat = 44
    
    override open var searchBar: UIDSearchBar {
        return instanceInit()
     }
    
    override public init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    func instanceInit() -> UIDSearchBar {
        guard dlsSearchBar != nil else {
            dlsSearchBar = UIDSearchBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: searchBarIntrinsicHeight))
            dlsSearchBar.searchBarStyle = .default
            return dlsSearchBar
        }
        return dlsSearchBar
    }
}
