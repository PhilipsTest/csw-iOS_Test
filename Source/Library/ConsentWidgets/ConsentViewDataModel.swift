//
//  ConsentViewDataModel.swift
//  ConsentWidgets

//  Copyright © 2017 Philips. All rights reserved.
//

import PlatformInterfaces

public class ConsentViewDataModel {
    var consentText: String
    var status: Bool
    var consentDefinition: ConsentDefinition
    var isEnabled: Bool

    public init(consentDefinition: ConsentDefinition, consentText: String, status: Bool, isEnabled: Bool) {
        self.consentText = consentText
        self.status = status
        self.consentDefinition = consentDefinition
        self.isEnabled = isEnabled
    }
}
