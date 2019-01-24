//
//  UIDAlertControllerMock.swift
//  ConsentWidgetsTests
//
//  Copyright © 2018 Philips. All rights reserved.
//

import Foundation
import PhilipsUIKitDLS

class UIDAlertControllerMock: UIDAlertController {
    var addActionTimesCalled = 0
    
    override func addAction(_ action: UIDAction) {
        self.addActionTimesCalled += 1
    }
}
