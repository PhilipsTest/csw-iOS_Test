// © Koninklijke Philips N.V., 2018. All rights reserved.

import Foundation

public class LanguageLoader {
    static var mainBundle: Bundle = Bundle.main
    static var languageBundle: Bundle? = nil

    static func Localized(_ key: String, _ args: CVarArg...) -> String {
        let bundle = LanguageLoader.languageBundle ?? LanguageLoader.mainBundle
        let format = Foundation.NSLocalizedString(key, bundle: bundle, comment: "")

        return args.count == 0
            ? format
            : String(format: format, arguments: args)
    }

    static func load(language: String) {
        guard
            let path = LanguageLoader.mainBundle.path(forResource: language, ofType: "lproj"),
            let bundle = Bundle(path: path) else {
                return
        }

        self.languageBundle = bundle
    }

    static func languages(in bundle: Bundle = LanguageLoader.mainBundle) -> [String] {
        var languages: [String] = []

        for path in bundle.paths(forResourcesOfType: "lproj", inDirectory: nil) {
            languages.append(path.fileName)
        }

        return languages
    }
}

private extension String {
    var fileName: String {
        var url = URL(fileURLWithPath: self)
        url.deletePathExtension()

        return url.lastPathComponent
    }
}
