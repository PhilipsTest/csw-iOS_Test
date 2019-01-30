/* Copyright (c) Koninklijke Philips Electronics N.V. 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

/**
 *  UIDRadioGroupDataSource is a protocol for Radio Button Group.
 *  This protocal responsible to get data for Radio Button Group user-interface customization.
 *
 *  - Since: 3.0.0
 */
@objc
public protocol UIDRadioGroupDataSource: NSObjectProtocol {
    /// Configure Number of RadioButtons in Group. Default is 2 if not implemented.
    /// - Since: 3.0.0
    @objc
    optional func numberOfRadioButtons(for radioGroup: UIDRadioGroup) -> Int
    
    /// Configure RadioButton title at index in Group.
    /// - Since: 3.0.0
    @objc
    optional func radioGroup(_ radioGroup: UIDRadioGroup, titleAtIndex: Int) -> String
    
    // TODO: Change API name to optional func radioGroup(_ radioGroup: UIDRadioGroup, heightAt index: Int) -> CGFloat
    /// Configure RadioButton Height at index in Group.
    /// - Since: 3.0.0
    @objc
    optional func radioGroup(_ radioGroup: UIDRadioGroup, heightAtIndex: Int) -> CGFloat
}

/**
 *  UIDRadioGroupDelegate is a protocol for Radio Button Group.
 *  This protocal responsible responsible to send event of Radio Button Group.
 *
 *  - Since: 3.0.0
 */
@objc
public protocol UIDRadioGroupDelegate: NSObjectProtocol {
    /// Send event on Radion Button selection with selected index.
    /// - Since: 3.0.0
    @objc
    optional func radioGroup(_ radioGroup: UIDRadioGroup, selectedIndex: Int)
}

/**
 *  A UIDRadioGroup is the standard Radio button Group to use.
 *  In InterfaceBuilder it is possible to create a UIView and give it the class UIDRadioGroup,
 *  the styling will be done immediately
 *
 *  - Since: 3.0.0
 */
@IBDesignable
@objcMembers open class UIDRadioGroup: UIView {
    /**
     * The UIDTheme of the button.
     * Updates the Radio-button styling when set.
     *
     * Defaults to UIDThemeManager.sharedInstance.defaultTheme
     *
     * - Since: 3.0.0
     */
    public var theme: UIDTheme? = UIDThemeManager.sharedInstance.defaultTheme {
        didSet {
            configureTheme()
        }
    }
    
    /**
     * RadioButtons (UIDRadioButton) in RadioGroup.
     *
     * - Since: 3.0.0
     */
    public internal(set) var radioButtons: [UIDRadioButton] = []
    
    /**
     * RadioGroup's DataSource.
     *
     * - Since: 3.0.0
     */
     weak public var dataSource: UIDRadioGroupDataSource?
    
    /**
     * RadioGroup's Delegate.
     *
     * - Since: 3.0.0
     */
    weak public var delegate: UIDRadioGroupDelegate?
    
    /**
     * Selected UIDRadioButton Index of RadioGroup.
     *
     * Default is -1. means None RadioButton is selected.
     *
     * - Since: 3.0.0
     */
    @IBInspectable
    public var selectedIndex: Int = -1 {
        didSet {
            if oldValue != selectedIndex {
                radioGroupTableView.reloadData()
            }
        }
    }
    
    /// A table-View which will contain set of Radio-Buttons (UIDRadioButton).
    let radioGroupTableView = UITableView.makePreparedForAutoLayout()
    let cellIdentifier = "RadioGroupCell"
    
    /**
     * Refresh the RadioGroup.
     *
     * @note: This function will reload all the RadioButtons inside RadioGroup.
     *
     * - Since: 3.0.0
     */
    public func refreshRadioGroup() {
        clearSelection()
        configureRadioButtons()
        radioGroupTableView.reloadData()
    }
    
    /**
     * Clear the selection of RadioGroup.
     *
     *
     * - Since: 3.0.0
     */
    public func clearSelection() {
        selectedIndex = -1
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        instanceInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        instanceInit()
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        instanceInit()
    }
}

extension UIDRadioGroup {
    func instanceInit() {
        (backgroundColor, clipsToBounds) = (UIColor.clear, false)
        configureTableView()
        configureRadioButtons()
        configureTheme()
    }
    
    func configureTableView() {
        radioGroupTableView.configureDefaultProperties()
        radioGroupTableView.register(RadioGroupCell.self, forCellReuseIdentifier: cellIdentifier)
        (radioGroupTableView.delegate, radioGroupTableView.dataSource) = (self, self)
        addSubview(radioGroupTableView)
        let views = ["radioGroupTableView": radioGroupTableView]
        let constraints = ["H:|[radioGroupTableView]|", "V:|[radioGroupTableView]|"]
        addConstraints(constraints, metrics: nil, views: views)
    }
    
    func configureRadioButtons() {
        let numberOfRadioButtons = dataSource?.numberOfRadioButtons?(for: self) ?? 2
        radioButtons = []
        for index in 0..<numberOfRadioButtons {
            let title = dataSource?.radioGroup?(self, titleAtIndex: index) ?? ""
            let radioButton = UIDRadioButton(delegate: self)
            radioButton.setTitle(title, lineSpacing: UIDLineSpacing)
            radioButton.theme = theme
            radioButtons.append(radioButton)
        }
    }
    
    func configureTheme() {
        theme.ifNotNil {
            for radioButton in radioButtons {
                radioButton.theme = $0
            }
        }
    }
}

extension UIDRadioGroup: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return radioButtons.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = radioGroupTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.setupCell(self, indexPath: indexPath)
        return cell
    }
}

extension UIDRadioGroup: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let radioButton = radioButtons[indexPath.row]
        let attributedText = radioButton.attributedTitle(for: .normal)
        var height: CGFloat = 0
        if let attributedText = attributedText {
            let preferredWidth = frame.size.width - outerCircleSize - textToCirclePadding
            let boundingRect =  attributedText.sizeToFit(CGSize(width: preferredWidth, height: 0),
                                                         font: attributedText.font)
            height = boundingRect.height + outerCircleY * 2
        }
        height = dataSource?.radioGroup?(self, heightAtIndex: indexPath.row) ?? height
        return height
    }
}

extension UIDRadioGroup: UIDRadioButtonDelegate {
    public func radioButtonPressed(_ radioButton: UIDRadioButton) {
        if radioButton.isSelected {
            selectedIndex = radioButtons.index(of: radioButton) ?? -1
            delegate?.radioGroup?(self, selectedIndex: selectedIndex)
        }
    }
}

class RadioGroupCell: UITableViewCell {
    override func setupCell(_ radioGroup: UIDRadioGroup, indexPath: IndexPath) {
        super.setupCell(radioGroup, indexPath: indexPath)
        contentView.removeAllSubviews()
        let radioButton = radioGroup.radioButtons[indexPath.row]
        radioButton.isSelected = radioGroup.selectedIndex == indexPath.row
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(radioButton)
        backgroundColor = UIColor.clear
        let views = ["radioButton": radioButton]
        let constraints = ["H:|[radioButton]|", "V:|[radioButton]|"]
        addConstraints(constraints, metrics: nil, views: views)
    }
}

extension UITableViewCell {
   @objc func setupCell(_ radioGroup: UIDRadioGroup, indexPath: IndexPath) {}
}

extension UITableView {
    func configureDefaultProperties() {
        (backgroundColor, clipsToBounds) = (UIColor.clear, false)
        (showsVerticalScrollIndicator, showsVerticalScrollIndicator) = (false, false)
        (bounces, bouncesZoom) = (false, false)
        (delaysContentTouches, canCancelContentTouches) = (false, false)
        (separatorStyle, allowsSelection) = (.none, false)
    }
}
