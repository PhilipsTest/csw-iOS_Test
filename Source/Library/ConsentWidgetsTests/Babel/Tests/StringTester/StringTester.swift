// © Koninklijke Philips N.V., 2018. All rights reserved.

import Foundation
import Quick
import Nimble
import XCTest

public class StringTester: Tester {
    let bundle: Bundle
    
    public init(with bundle: Bundle = Bundle.main) {
        self.bundle = bundle
    }

    public func test(language: String, against base: String, in controller: UIViewController) {
        guard language != base else {
            return
        }

        guard
            let testedLanguage = LanguageStrings(for: language, in: bundle),
            let baseLanguage = LanguageStrings(for: base, in: bundle) else {
                return
        }

        describe("language \(testedLanguage.language) vs base \(baseLanguage.language)") {
            it("should have entries for all the keys in base") {
                let keysWithoutEntry = baseLanguage.entries.keys.filter { (key) in
                    return !testedLanguage.hasValidEntry(for: key)
                }

                if keysWithoutEntry.count > 0 {
                    fail("🔴 Language \"\(testedLanguage.language)\" does not contain a valid entry for keys: \(keysWithoutEntry.flatMap { $0 })")
                }
            }

            it("should not have additional entries that are not in the base") {
                let additionalKeys = testedLanguage.entries.keys.filter { (key) in
                    return !baseLanguage.entries.keys.contains(key)
                }

                if additionalKeys.count > 0 {
                    fail("🔴 Language \"\(testedLanguage.language)\" contains additional keys: \(additionalKeys.flatMap { $0 })")
                }
            }

            it("should have the same amount of placeholders") {
                let mismatchedKeys = baseLanguage.entries.keys.filter { (key) -> Bool in
                    guard
                        let placeHoldersUsingLanguage = testedLanguage.entries[key]?.placeHolderCount,
                        let placeHoldersUsingBase = baseLanguage.entries[key]?.placeHolderCount else {
                            return false
                    }

                    return placeHoldersUsingBase != placeHoldersUsingLanguage
                }

                if mismatchedKeys.count > 0 {
                    fail("🔴 Following keys contain mismatched placeholder counts: \(mismatchedKeys.flatMap { $0 })")
                }
            }
        }
    }
}
