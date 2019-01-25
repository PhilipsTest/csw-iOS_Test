/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsIconFontDLS
/**
 *  A UIDSearchBar is the standard Search Bar to use as per DLS guideline.
 *  In InterfaceBuilder it is possible to create a UISearchBar and give it the class UIDSearchBar,
 *  the styling and layout setup will be done immediately.
 *
 *  @note Use "searchBarStyle" API to update the Search Bar type anytime. 
 *   **Please note:** It is recommended to set "searchBarStyle" to see the correct layout. @see searchBarStyle
 *
 *  - Important:
 *  If the hidesNavigationBarDuringPresentation property of UIDSearchController is set to YES,
 *  the status bar style has to be altered according to the tonal range of the navigational area
 *  in order to make the status bar visible when the search bar transitions to the top of the screen
 *
 *
 *  - Since: 3.0.0
 */

@IBDesignable
@objcMembers open class UIDSearchBar: UISearchBar {
    
    //MARK Variable Declarations
    let searchFieldTextFontSize: CGFloat = 14
    let searchCrossIconWidth: CGFloat = 13
    let searchCrossIconHeight: CGFloat = 13
    let searchIconWidth: CGFloat = 14
    let searchIconHeight: CGFloat = 14
    let searchBarBorderWidth: CGFloat = 1
    var searchBarTextFieldCornerRadius: CGFloat {
        if #available(iOS 11.0, *) {
            return 10
        } else {
            return 4
        }
    }
    
    var searchFieldBackgroundColor: UIColor? {
        return searchBarStyle == .minimal ? UIColor.clear : theme?.searchBoxIosProminentSearchbarBackground
    }
    
    var searchTextFieldBorderColor: UIColor? {
        return searchBarStyle == .minimal ? UIColor.clear : theme?.searchBoxIosDefaultInputBorder
    }
    
    var searchTextFieldBorderWidth: CGFloat {
        return searchBarStyle == .minimal ? 0 : searchBarBorderWidth
    }
    
    /**
     * The UIDTheme of the searchbar.
     * Updates the searchbar styling when set.
     *
     * Defaults to UIDThemeManager.sharedInstance.defaultTheme
     *
     * - Since: 3.0.0
     */
    open var theme: UIDTheme? {
        return UIDThemeManager.sharedInstance.defaultTheme
    }
    
    open override var searchBarStyle: UISearchBarStyle {
        didSet {
            changeCancelButtonStyling()
            changeSearchBarAppearance()
        }
    }
    
    open override var placeholder: String? {
        didSet {
            configureSearchPlaceholder()
        }
    }
    
    //MARK Default Methods
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        instanceInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        instanceInit()
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        instanceInit()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        instanceInit()
    }
}

//MARK Helper Methods

extension UIDSearchBar {
    
    fileprivate func instanceInit() {
        applySearchBarStyling()
    }
    
    fileprivate func applySearchBarStyling() {
        tintColor = theme?.searchBoxIosDefaultClearIcon
        UITextField.appearance(whenContainedInInstancesOf:
            [UIDSearchBar.self]).font = UIFont(uidFont: .book, size: searchFieldTextFontSize)
        UITextField.appearance(whenContainedInInstancesOf:
            [UIDSearchBar.self]).textColor = theme?.searchBoxIosDefaultInputText
        changeSearchBarAppearance()
        changeCancelButtonStyling()
    }
    
    fileprivate func configureSearchPlaceholder() {
        let font = UIFont(uidFont: .book, size: searchFieldTextFontSize)
        let placeholderColor = theme?.searchBoxIosDefaultHintText
        if let placeHolder = placeholder, let font = font, let placeholderColor = placeholderColor {
            let attributes = [NSAttributedStringKey.foregroundColor: placeholderColor,
                              .font: font]
            UITextField.appearance(whenContainedInInstancesOf:
                [UIDSearchBar.self]).attributedPlaceholder = NSAttributedString(string: placeHolder,
                                                                                attributes:attributes)
        }
    }
  
   // Commented as this is useful in future
    
    func changeSearchBarIcons() {
        let normalCrossImage = createIconImage(for: .clear)
        setImage(normalCrossImage, for: .clear, state: .normal)
        setImage(normalCrossImage, for: .clear, state: .highlighted)
        
        let searchImage = createIconImage(for: .search)
        setImage(searchImage, for: .search, state: .normal)
        setImage(searchImage, for: .search, state: .highlighted)
    }
    
    func createIconImage(for type: UISearchBarIcon) -> UIImage? {
        let iconWidth = type == .search ? searchIconWidth : searchCrossIconWidth
        let iconHeight = type == .search ? searchIconHeight : searchCrossIconHeight
        let iconFontSize = type == .search ? searchIconWidth : searchCrossIconWidth
        
        //TODO: Change both search and close icon when we get search icon
        let iconText = type == .search ? PhilipsDLSIcon.unicode(iconType: .cross) : PhilipsDLSIcon.unicode(iconType: .cross)
        let iconTextColor = type == .search ? theme?.searchBoxIosDefaultSearchIcon : theme?.searchBoxIosDefaultClearIcon
        
        let iconLabel = UILabel.makePreparedForAutoLayout()
        iconLabel.frame = CGRect(x: 0, y: 0, width: iconWidth, height: iconHeight)
        iconLabel.font = UIFont.iconFont(size: iconFontSize)
        iconLabel.text = iconText
        iconLabel.textColor = iconTextColor
        return iconLabel.drawImage()
    }
    
    func createSearchBarBackgroundImage() -> UIImage? {
        let searchBackgroundImage = searchFieldBackgroundColor?.createImage()
        return searchBackgroundImage
    }
    
    fileprivate func changeSearchBarAppearance() {
        setBackgroundImage(createSearchBarBackgroundImage(), for: .any, barMetrics: .default)
        
        if let searchTextField = value(forKey: "_searchField") as? UITextField {
            searchTextField.layer.cornerRadius = searchBarTextFieldCornerRadius
            searchTextField.layer.borderWidth = searchTextFieldBorderWidth
            searchTextField.borderColor = searchTextFieldBorderColor
            
            if searchBarStyle == .minimal {
                searchTextField.layer.backgroundColor = theme?.searchBoxIosDefaultInputBackground?.cgColor
            } else {
                searchTextField.backgroundColor = theme?.searchBoxIosDefaultInputBackground
            }
        }
    }
    
    fileprivate func changeCancelButtonStyling() {
        guard let cancelTextFont = UIFont(uidFont: .book, size: UIDFontSizeMedium) else {
            return
        }
        
        if let cancelButtonNormalTextColor = theme?.searchBoxIosDefaultCancelText {
            UIBarButtonItem.appearance(whenContainedInInstancesOf:
                [UIDSearchBar.self]).setTitleTextAttributes([.foregroundColor: cancelButtonNormalTextColor,
                                                             .font: cancelTextFont], for: .normal)
        }
        
        if let cancelButtonPressedTextColor = theme?.searchBoxIosDefaultPressedCancelText {
            UIBarButtonItem.appearance(whenContainedInInstancesOf:
                [UIDSearchBar.self]).setTitleTextAttributes([.foregroundColor: cancelButtonPressedTextColor,
                                                             NSAttributedStringKey.font: cancelTextFont], for: .highlighted)
        }
    }
}
