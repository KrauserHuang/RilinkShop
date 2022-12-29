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
}
