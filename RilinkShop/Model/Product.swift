//
//  Product.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/25.
//

import Foundation

struct Product: Codable, Hashable {
    let pid: String
    let productNo: String
    let productType: String
    let productTypeName: String
    let productName: String
    let productPrice: String
//    let productPicture: String
    
    enum CodingKeys: String, CodingKey {
        case pid
        case productNo = "product_no"
        case productType = "product_type"
        case productTypeName = "producttype_name"
        case productName = "product_name"
        case productPrice = "product_price"
//        case productPicture = "product_picture"
    }
}
