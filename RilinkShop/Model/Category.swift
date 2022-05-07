//
//  Category.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/25.
//

import Foundation

struct Category: Codable {
    let pid: String
    let productType: String
    let productTypeName: String
    
    enum CodingKeys: String, CodingKey {
        case pid
        case productType = "product_type"
        case productTypeName = "producttype_name"
    }
}

extension Category: Hashable {}
