/* Copyright (c) Koninklijke Philips Electronics N.V. 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

/*
 *************************************************************
            How to Use "ifNotNil" & "ifNil" APIs
 *************************************************************
 
 struct OptionalTheme {
 var theme: UIDTheme
 }
 
 var optionalTheme: OptionalTheme? = OptionalTheme(theme: UIDTheme())
 optionalTheme.ifNotNil { print($0) }   //prints UIDTheme Object
 
 optionalTheme = nil
 optionalTheme.ifNil { print("Theme Object is Nil") }   //prints Theme Object is Nil
 */

public extension Optional {
    
    @discardableResult
    public func ifNotNil(_ handler: (Wrapped) -> Void) -> Optional {
        switch self {
        case .some(let wrapped): handler(wrapped); return self
        case .none: return self
        }
    }
    
    @discardableResult
    public func ifNil(_ handler: () -> Void) -> Optional {
        switch self {
        case .some: return self
        case .none: handler(); return self
        }
    }
}
