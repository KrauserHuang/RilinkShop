//
//  Product.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/25.
//

import Foundation

//struct Product: Codable, Hashable {
//    let pid: String
//    let productNo: String
//    let productType: String
//    let productTypeName: String
//    let productName: String
//    let productPrice: String
////    let productPicture: String
//
//    enum CodingKeys: String, CodingKey {
//        case pid
//        case productNo = "product_no"
//        case productType = "product_type"
//        case productTypeName = "producttype_name"
//        case productName = "product_name"
//        case productPrice = "product_price"
////        case productPicture = "product_picture"
//    }
//}

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
    
////    var did: String? = ""
//    var orderNo: String? = ""
//    var memberID: String? = ""
//    // 商品為package
//    var pkglistID: String? = ""
//    // 商品為product
//    var productNo: String? = ""
//    var productSpec: String? = ""
//    
//    var productPrice: String? = ""
//    var orderQty: String? = ""
//    var totalAmount: String? = ""
//    var orderStatus: String? = ""
//    var cartCreatedAt: String? = ""
//    var productName: String? = ""
//    var producttypeName: String? = ""
//    var productPicture: String? = ""
}

extension Product: Hashable {}
