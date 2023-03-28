//
//  Date + Ext.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/12/22.
//

import Foundation

extension Date {
    static func dateFromGMT(_ date: Date) -> Date {
        let secondFromGMT: TimeInterval = TimeInterval(TimeZone.current.secondsFromGMT(for: date))
        return date.addingTimeInterval(secondFromGMT)
    }
    
    func convertDateToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        
        // chose one of the following. example output displayed to the right.

//        dateFormatter.dateStyle    = .full         // Tuesday, March 17, 2015
//        dateFormatter.dateStyle    = .long         // March 17, 2015
//        dateFormatter.dateStyle    = .medium       // Mar 17, 2015
//        dateFormatter.dateStyle    = .short        // Locale="en_US_POSIX" => 4/17/15 --- Local="en_UK" => 17/4/15
                
//        dateFormatter.dateFormat    = "MMM yyyy"
        dateFormatter.dateFormat    = "yyyy-MM-dd"
        dateFormatter.locale        = .current
        dateFormatter.timeZone      = .current
        print(dateFormatter.string(from: self))
        print("============================")
        return dateFormatter.string(from: self)
    }
}
