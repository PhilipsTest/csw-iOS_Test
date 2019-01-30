//
//  ErrorMessageHelper.swift
//  ConsentWidgets
//
//  Copyright © 2018 Philips. All rights reserved.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder.
//

import Foundation

class ErrorMessageHelper: NSObject {
    
    public static func getLocalizedErrorMessageBasedOnError(_ error: NSError) -> String {
        switch error.code {
            
        case 1008:
            return "csw_invalid_access_token_error_message".localized
        case NSURLErrorNotConnectedToInternet:
            return "csw_offline_message".localized
        case 3002, 3003:
            return error.localizedDescription
        case 1009:
            return "csw_user_session_expired".localized
        default:
            return "csw_generic_network_error".localized
        }
    }
    
    public static func getLocalizedErrorTitleBasedOnErrorCode(_ code: Int) -> String {
        switch code {
            
        case NSURLErrorNotConnectedToInternet:
            return "csw_offline_title".localized
            
        default:
            return "csw_problem_occurred_error_title".localized
        }
    }
}
