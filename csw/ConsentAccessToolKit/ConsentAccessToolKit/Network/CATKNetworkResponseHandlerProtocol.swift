//
//  CATKNetworkResponseHandlerProtocol.swift
//  ConsentAccessToolKit
//
//  Created by Abhishek Chatterjee on 01/11/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import Foundation

public typealias GetConsentCompletionHandler = (_ result: AnyObject?, _ error: NSError?) -> Void
public typealias PostConsentCompletionHandler = (_ result: Bool, _ error: NSError?) -> Void

protocol CATKNetworkResponseHandlerProtocol: NSObjectProtocol {
    func handleResponseForFetchLatestConsent(_ inResponseObject: ConsentServiceResponseHolder, completion: GetConsentCompletionHandler)
    func handleResponseForPostConsent(_ inResponseObject: ConsentServiceResponseHolder, completion: PostConsentCompletionHandler)
}
