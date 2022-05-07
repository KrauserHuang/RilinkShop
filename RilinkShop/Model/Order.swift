//
//  Order.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/6.
//

import Foundation

struct Order: Codable {
    var order_amount = ""
    var discount_amount = ""
    var order_pay = ""
}

struct Response: Codable {
    var code = ""
    var status = ""
    var responseMessage = ""
}
