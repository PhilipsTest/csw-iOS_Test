//
//  CATKUtility.swift
//  ConsentAccessToolKit
//
//  Copyright © 2018 Philips. All rights reserved.
//

import Foundation

class CATKUtility {
    public static func convertDatetoString(date:Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter.string(from: date)
    }
    
    public static func convertStringtoDate(strDate:String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let date = dateFormatter.date(from: strDate){
            return date
        }
        return Date(timeIntervalSince1970: 0)
   }
}
