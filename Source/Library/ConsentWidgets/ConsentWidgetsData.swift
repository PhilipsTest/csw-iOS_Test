//
//  ConsentWidgetsData.swift
//  ConsentWidgets
//
//  Created by philips on 1/4/18.
//  Copyright © 2018 Philips. All rights reserved.
//

import Foundation
import AppInfra

class ConsentWidgetsData {
    static let sharedInstance = ConsentWidgetsData()
    var appInfra: AIAppInfra!
    
    private init(){}
}
