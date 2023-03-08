//
//  Category.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/25.
//

import Foundation

struct Category: Codable {
    var pid: String = ""
    var productType: String = ""
    var productTypeName: String = ""
    var productTypePicture: String? = ""

    enum CodingKeys: String, CodingKey {
        case pid
        case productType = "product_type"
        case productTypeName = "producttype_name"
        case productTypePicture = "producttype_picture"
    }
}

extension Category: Hashable {}
