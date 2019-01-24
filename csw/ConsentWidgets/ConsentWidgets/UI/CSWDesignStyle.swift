
import Foundation
import PhilipsUIKitDLS

fileprivate enum CSWtextType {
    case revokeMessage
    
    var font: UIFont {
        switch self {
            case .revokeMessage:
                return UIFont(uidFont:.book, size: UIDFontSizeMedium) ?? UIFont.systemFont(ofSize: UIDFontSizeMedium)
        }
    }
}

extension String {
    var asRevokeMessage: NSAttributedString {
        return attributedString(type: .revokeMessage)
    }

    private func attributedString(type: CSWtextType) -> NSAttributedString {
        return htmlCSSAttributed(using: type.font) ?? NSAttributedString(string: "")
    }
    
    
    private func htmlCSSAttributed(using font: UIFont?) -> NSAttributedString? {
        do {
            let someFont = font ?? UIFont.systemFont(ofSize: UIDFontSizeMedium)
            let htmlCSSString = "<style>" +
                "html *" +
                "{" +
                "font-size: \(someFont.pointSize) !important;" +
                "font-family: \(someFont.familyName) !important;" +
            "}</style> \(self)"
            
            guard let data = htmlCSSString.data(using: .utf8) else { return nil }
            
            return try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
}
