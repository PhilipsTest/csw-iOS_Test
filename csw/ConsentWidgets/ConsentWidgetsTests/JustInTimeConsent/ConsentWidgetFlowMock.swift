//
//  ConsentWidgetFlowMock.swift
//  ConsentWidgetsTests
//
//  Copyright © 2018 Philips. All rights reserved.
//

import UIKit
@testable import ConsentWidgets

class ConsentWidgetFlowMock: ConsentWidgetFlow {
    static var moveToWhatDoesThisMeanCalled = false
    
    struct Captured {
        static var helpText = ""
        static var title = ""
    }
    
    static func moveToWhatDoesThisMeanControllerWith(helpText: String, title:String?, navigationController: UINavigationController?) {
        moveToWhatDoesThisMeanCalled = true
        self.Captured.helpText = helpText
        self.Captured.title = title ?? ""
    }
    
}
