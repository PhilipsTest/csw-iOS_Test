//
//  UserDetailConstants.swift
//  PlatformInterfaces
//
//  Created by Nikilesh on 2/14/18.
//  Copyright © 2018 Philips.All rights are reserved. Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder.
//

import Foundation

@objc public class Constants: NSObject {
    @objc public static let GIVEN_NAME                = "givenName"                           //updatable and gettable.
    @objc public static let FAMILY_NAME               = "familyName"                          //updatable and gettable
    @objc public static let GENDER                    = "gender"                              //updatable and gettable
    @objc public static let EMAIL                     = "email"                               //only gettable
    @objc public static let MOBILE_NUMBER             = "mobileNumber"                        //only gettable
    @objc public static let BIRTHDAY                  = "birthday"                            //updatable and gettable
    @objc public static let RECEIVE_MARKETING_EMAIL   = "receiveMarketingEmail"               //updatable and gettable
    
    @objc public static let USER_ERROR_DOMAIN         = "URError Domain"
}

@objc public enum UserDetailError: NSInteger {
    case InvalidFields = 1000
    case NotLoggedIn   = 1001
}

/**
 An enum that allows to return the state of the user while logging in.
 
 - URUserNotLoggedIn:       Informs the state of the user as not logged in.
 - URPendingVerification:   Informs that the verification is pending for the user.
 - URPendingTnC:            Informs that the terms and conditions acceptance is pending for the user.
 - URPendingHSDPLogin:      Informs that HSDP login is pending for the user.
 - URUserLoggedIn:          Informs that the user is successfully logged in.
 *
 *  @since 1804.0
 */
@objc public enum URLoggedInState: NSInteger {
    case userNotLoggedIn
    case pendingVerification
    case pendingTnC
    case pendingHSDPLogin
    case userLoggedIn
}
