//
//  String + Ext.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2023/3/24.
//

import UIKit

extension String {
    
    var isValidEmail: Bool { //建立 email 篩選動作
        let emailFormat         = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate      = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    var isValidPassword: Bool { //建立 password 篩選動作
        //Regex restricts to 8 character minimum, 1 capital letter, 1 lowercase letter, 1 number
        let passwordFormat      = "(?=.*[A-Z]) (?=.*[0-9]) (?=.*[a-z]).(8,}"
        let passwordPredicate   = NSPredicate(format: "SELF MATCHES %@", passwordFormat)
        return passwordPredicate.evaluate(with: self)
    }
    
    func convertStringToDate() -> Date? { //如果會傳日期型別為 String，將其轉成Date
        print(self)
        print("============================")
        let dateFormatter           = DateFormatter()
//        dateFormatter.dateFormat    = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.dateFormat    = "yyyy-MM-dd HH:mm:ss"
//        dateFormatter.locale        = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale        = .current
        dateFormatter.timeZone      = .current
        print(dateFormatter.date(from: self))
        print("============================")
        return dateFormatter.date(from: self)
    }
    
    func convertDateToDisplayString() -> String { //再將 Date 轉回 String
        guard let date = self.convertStringToDate() else { return "N/A" }
        return date.convertDateToMonthYearFormat()
    }
}
