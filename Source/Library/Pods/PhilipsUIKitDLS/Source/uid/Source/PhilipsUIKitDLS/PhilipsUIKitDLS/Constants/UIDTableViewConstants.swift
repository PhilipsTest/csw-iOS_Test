//  Copyright © 2017 Philips. All rights reserved.

///DLS specified default height of TableView header title
/// - Since: 3.0.0
public let UIDTableViewHeaderHeight: CGFloat = 40

/// - Since: 3.0.0
public let UIDTableViewHeaderFontSize: CGFloat = 14

enum UIDTableViewCellConstants {
    static let contentLayoutMargins = UIEdgeInsets(top:8, left: 16, bottom: 8, right: 16)

    enum TitleOnly {
        static let fontSize: CGFloat = 16

        static let fontType = UIDFont.book
        
        static let titleIconSpacing: CGFloat = 32
        
        static let iconSize: CGFloat  = 24
        
        static let height: CGFloat = 48
    }

    enum TitleWithDescription {
        static let titleFontSize: CGFloat = 16

        static let titleFontType = UIDFont.medium

        static let descriptionFontSize: CGFloat = 14

        static let descriptionFontType = UIDFont.book
        
        static let height: CGFloat = 72
    }
}
