//
//  FixMotor.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/6/22.
//

import Foundation

struct FixMotor {
    var bookingDate: String = ""
    var duration: String = ""
    var quota: String = ""
    var used: String = ""
    var bid: String = ""
    var name: String = ""
    var motorNo: String = ""
    var motorType: String = ""
    var fixType: String = ""
    var description: String = ""
    var cancel: String = ""
    var storeName: String = ""
    var phone: String = ""

    enum CodingKeys: String, CodingKey {
        case bookingDate = "bookingdate"
        case duration
        case quota
        case used
        case bid
        case name
        case motorNo = "motor_no"
        case motorType = "motor_type"
        case fixType = "fixtype"
        case description
        case cancel
        case storeName = "store_name"
        case phone
    }
}
