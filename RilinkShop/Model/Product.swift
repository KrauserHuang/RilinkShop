//
//  Product.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/25.
//

import Foundation

struct Product: Codable {
    var pid                 = ""
    var product_type        = ""
    var producttype_name    = ""
    var product_name        = ""
    var product_price       = ""
    var product_status      = ""
    var product_no          = ""
    var product_description = ""
    var product_bonus       = ""
    var product_stock       = ""
    var product_picture     = ""
    var producttype_picture = ""
    var order_qty           = ""
    var total_amount        = ""
    var did                 = ""
    var product_spec        = ""
}

extension Product: Hashable {}
