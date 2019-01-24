//
//  AppInfraConfigMock.swift
//  ConsentAccessToolKitTests
//
//  Created by hudson.brito@philips.com on 13/12/2018.
//  Copyright © 2018 Philips. All rights reserved.
//

import Foundation
import AppInfra

public class AppInfraConfigMock : NSObject, AIAppConfigurationProtocol {
    public func getPropertyForKey(_ key: String!, group: String!) throws -> Any {
        return ""
    }
    
    public func setPropertyForKey(_ key: String!, group: String!, value: Any!) throws {
        
    }
    
    public func getDefaultProperty(forKey key: String!, group: String!) throws -> Any {
        return ""
    }
    
    public func refreshCloudConfig(_ completionHandler: ((AIACRefreshResult, Error?) -> Void)!) {
        
    }
    
    public func resetConfig() throws {
        
    }
    
    
    
    
}
