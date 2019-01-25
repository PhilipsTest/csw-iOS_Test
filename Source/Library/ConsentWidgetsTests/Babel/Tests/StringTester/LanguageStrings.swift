// © Koninklijke Philips N.V., 2018. All rights reserved.

struct LanguageStrings {
    struct Entry {
        let value: String
        let placeHolderCount: Int

        init(with value: String) {
            self.value = value
            self.placeHolderCount = value.placeholderCount
        }
    }

    let language: String
    let entries: [String : Entry]

    init?(for language: String, in bundle: Bundle) {
        guard
            let languagePath = bundle.path(forResource: language, ofType: "lproj"),
            let languageBundle = Bundle(path: languagePath),
            let stringsFilePath = languageBundle.path(forResource: "Localizable", ofType: "strings"),
            let baseStrings = NSDictionary(contentsOfFile: stringsFilePath) as? [String: String]
        else {
            return nil
        }

        self.language = language
        self.entries = baseStrings.dictMap { (key, value) in
            return (key, Entry(with: value))
        }
    }

    func hasValidEntry(for key: String) -> Bool {
        guard let entry = entries[key] else {
            return false
        }

        let entryWithoutSpaces = entry.value.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return entryWithoutSpaces.count > 0
    }
}

fileprivate extension String {
    var placeholderCount: Int {
        return self.components(separatedBy: "%@").count - 1
    }
}

fileprivate extension Dictionary {
    func dictMap<OutKey: Hashable, OutValue>(_ transform: (Key, Value) -> (OutKey, OutValue)) -> [OutKey: OutValue] {
        var result = [OutKey: OutValue]()
        for (key, value) in self {
            let transformed = transform(key, value)
            result[transformed.0] = transformed.1
        }
        return result
    }
}
