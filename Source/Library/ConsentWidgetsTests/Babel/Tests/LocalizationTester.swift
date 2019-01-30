//
//  LocalizationTester.swift
//  Babel
//
//  Created by marco.pace@philips.com on 14/03/2018.
//

import Quick
import Nimble
import Foundation
import QuartzCore
import XCTest
@testable import ConsentWidgets

public protocol Tester {
    func test(language: String, against base: String, in controller: UIViewController)
}

public class LocalizationTester {
    let testers: [Tester]
    let bundle: Bundle

    public convenience init(bundle: Bundle = Bundle.main) {
        let labelTester = LabelTester()
        let stringTester = StringTester(with: bundle)

        self.init(bundle: bundle, testers: [labelTester, stringTester])
    }

    public init(bundle: Bundle = Bundle.main, testers: [Tester]) {
        self.testers = testers
        self.bundle = bundle
    }

    // Test a single controller
    public func test(against base: String = "en", handler: () -> (UIViewController)) {
        LanguageLoader.mainBundle = bundle
        
        for language in LanguageLoader.languages(in: bundle) {
            LanguageLoader.load(language: language)

            let controller = handler()

            for tester in testers {
                tester.test(language: language, against: base, in: controller)
            }
        }
    }

    // Test a list of controllers
    public func test(against base: String = "en", handler: () -> [UIViewController]) {
        LanguageLoader.mainBundle = bundle
        
        for language in LanguageLoader.languages() {
            LanguageLoader.load(language: language)

            for controller in handler() {
                for tester in testers {
                    tester.test(language: language, against: base, in: controller)
                }
            }
        }
    }
}
