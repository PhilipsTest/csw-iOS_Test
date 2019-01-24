//
//  CATKString+Extensions.swift
//  ConsentAccessToolKit
//
/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

extension String {
    var localized: String {
        let bundle = Bundle(for: ConsentAccessToolKit.self)
        return NSLocalizedString(self, tableName: "Localizable", bundle: bundle, value: "key not found", comment: "")
    }
}
