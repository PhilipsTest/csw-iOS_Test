//
//  ConsentWidgetsInterfaceInput.swift
//  ConsentWidgets
//
//  Created by Abhishek Chatterjee on 10/10/17.
//  Copyright © 2017 Abhishek Chatterjee. All rights reserved.
//

import UIKit
import UAPPFramework

private var _interfaceSharedInstance: ConsentWidgetsInterfaceInput?
private var setupOnceToken: Int = 0

@objcMembers open class ConsentWidgetsInterfaceInput: NSObject {
    var appDependency: UAPPDependencies
    var appSettings: UAPPSettings!

    class func setup(_ dependency: UAPPDependencies) -> ConsentWidgetsInterfaceInput {
        _interfaceSharedInstance = ConsentWidgetsInterfaceInput(dependency: dependency)
        return _interfaceSharedInstance!
    }

    public static let sharedInstance : ConsentWidgetsInterfaceInput = {
        assert((_interfaceSharedInstance != nil), "error: shared called before setup");
        return _interfaceSharedInstance!
    }()

    init(dependency: UAPPDependencies) {
        self.appDependency = dependency
    }
}
