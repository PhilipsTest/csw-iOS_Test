//
//  String+Localized.swift
//  ConsentWidgets
//
//  Created by jim.pouwels@philips.com on 03/11/2017.
//  Copyright © 2017 Philips. All rights reserved.
//

import Foundation

extension String {
    
    var localized: String {
        LanguageLoader.mainBundle = Bundle(for: ConsentWidgetsViewController.self)
        return LanguageLoader.Localized(self)
    }
    
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
    
    func nsRange(of string: String, options: CompareOptions = .literal, range: Range<Index>? = nil, locale: Locale? = nil) -> NSRange? {
        guard let range = self.range(of: string, options: options, range: range ?? startIndex..<endIndex, locale: locale ?? .current) else { return nil }
        return NSRange(range, in: self)
    }
}


