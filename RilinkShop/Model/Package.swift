//
//  Package.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/7.
//

import Foundation

struct Package: Codable {
    var packageNo: String = ""
    var productName: String = ""
    var productPrice: String = ""
    var productPicture: String = ""
    var productDescription: String = ""
//    let productStatus: String
    // for packageInfo
    var productStock: String = ""

    enum CodingKeys: String, CodingKey {
        case packageNo = "package_no"
        case productName = "product_name"
        case productPrice = "product_price"
        case productPicture = "product_picture"
        case productDescription = "product_description"
//        case productStatus = "product_status"
        case productStock = "product_stock"
    }
}

extension Package: Hashable {}

typealias PackageInfoList = PackageInfo

struct PackageInfo: Codable {
    var rid: String = ""
    var productNo: String = ""
    var productName: String = ""
    var pid: String = ""
    var productDescription: String = ""
    var productPrice: String = ""
    var productStock: String = ""
    var productPicture: String = ""
    var productStatus: String = ""
    var storeID: String = ""
    var qrcode: String = ""

    enum CodingKeys: String, CodingKey {
            case rid
            case productNo = "product_no"
            case productName = "product_name"
            case pid
            case productDescription = "product_description"
            case productPrice = "product_price"
            case productStock = "product_stock"
            case productPicture = "product_picture"
            case productStatus = "product_status"
            case storeID = "store_id"
            case qrcode
        }
}
