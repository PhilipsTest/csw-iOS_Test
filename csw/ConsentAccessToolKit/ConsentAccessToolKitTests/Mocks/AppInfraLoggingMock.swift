//
//  AppInfraLoggingMock.swift
//  ConsentAccessToolKitTests
//
//  Copyright © 2018 Philips. All rights reserved.
//

import Foundation
import AppInfra

class AppInfraLoggingMock : NSObject, AILoggingProtocol {
    func createInstance(forComponent componentId: String!, componentVersion: String!) -> AILoggingProtocol! {
        return self
    }
    
    func log(_ level: AILogLevel, eventId: String!, message: String!) {
    }
    
    func log(_ level: AILogLevel, eventId: String!, message: String!, dictionary: [AnyHashable : Any]!) {
    }
}

