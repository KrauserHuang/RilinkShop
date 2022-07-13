//
//  QRCode.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/11.
//

import Foundation

struct UNQRCode: Codable {
    var orderNo: String = ""
    var orderDate: String = ""
    // for product only
    var productName: String? = ""
    var storeID: String? = ""
    var productPicture: String? = ""
    var qrconfirm: String? = ""
    var storeName: String? = ""
    // for package only
    var packageName: String? = ""
    var packagePicture: String? = ""
    var product: [PackageProduct]? = []
    
    enum CodingKeys: String, CodingKey {
        case orderNo = "order_no"
        case orderDate = "order_date"
        case productName = "product_name"
        case storeID = "store_id"
        case productPicture = "product_picture"
        case qrconfirm
        case storeName = "store_name"
        case packageName = "package_name"
        case packagePicture = "package_picture"
        case product
    }
}

struct PackageProduct: Codable {
    var productName: String? = ""
    var storeID: String? = ""
    var productPicture: String? = ""
    var storeName: String? = ""
    var qrconfirm: String? = ""
    var orderQty: String? = ""
    
    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case storeID = "store_id"
        case productPicture = "product_picture"
        case storeName = "store_name"
        case qrconfirm
        case orderQty = "order_qty"
    }
}

struct QRCode: Codable {
    var orderNo: String = ""
    var orderDate: String = ""
    // for product only
    var productName: String? = ""
    var productPicture: String? = ""
    var storeID: String? = ""
    var qrconfirm: String? = ""
    var storeName: String? = ""
    // for package only
    var packageName: String? = ""
    var packagePicture: String? = ""
    var orderQty: String? = ""
    var product: [PackageProduct]? = []
    
    enum CodingKeys: String, CodingKey {
        case orderNo = "order_no"
        case orderDate = "order_date"
        case productName = "product_name"
        case storeID = "store_id"
        case productPicture = "product_picture"
        case qrconfirm
        case storeName = "store_name"
        case packageName = "package_name"
        case packagePicture = "package_picture"
        case orderQty = "order_qty"
        case product
    }
}

extension QRCode: Comparable {
    static func < (lhs: QRCode, rhs: QRCode) -> Bool {
        return rhs.orderDate < lhs.orderDate
    }
    
    static func == (lhs: QRCode, rhs: QRCode) -> Bool {
        return lhs.orderDate == rhs.orderDate
    }
}
