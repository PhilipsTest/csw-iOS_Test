//
//  ConsentApiError.swift
//  ConsentWidgets
//
//  Created by paul.caetano@philips.com on 03/11/2017.
//  Copyright © 2017 Philips. All rights reserved.
//

import Foundation

public enum ConsentApiError: Int {
    case InvalidRequest = 104
    case ErrorGettingOrCreatingConsents = 1223
    case Forbidden = 1254
    case CouldNotGetConsent = 2515
    case NoConsentGiven = 2514
}

