//
//  AppConfig.swift
//  ConsentAccessToolKit
//
//  Copyright © 2018 Philips. All rights reserved.
//
public class AppConfig : NSObject {

    var consentCacheTTL : Int
    var hsdpApplicationName : String
    var hsdpPropositionName : String

    public init(consentCacheTTL: Int, hsdpAppName: String, hsdpPropName: String) {
        self.consentCacheTTL = consentCacheTTL
        self.hsdpApplicationName = hsdpAppName
        self.hsdpPropositionName = hsdpPropName
    }
    
}
