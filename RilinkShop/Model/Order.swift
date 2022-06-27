//
//  Order.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/6.
//

import Foundation

struct Response: Codable {
    var code = ""
    var status = ""
    var responseMessage = ""
}

struct Order: Codable {
    var oid: String = ""
    var orderNo: String = ""
    var orderDate: String = ""
    var storeID: String = ""
    var memberID: String = ""
    var orderAmount: String = ""
    var couponNo: String? = ""
    var discountAmount: String = ""
    var payType: String = ""
    var orderPay: String = ""
    var payStatus: String = ""
    var bonusPoint: String = ""
    var orderStatus: String = ""
    
//    var productList: [List]? = []
//    var packageList: [List]? = []
//    var productList: [ProductList]? = []
//    var packageList: [PackageList]? = []
    
    enum CodingKeys: String, CodingKey {
        case oid
        case orderNo = "order_no"
        case orderDate = "order_date"
        case storeID = "store_id"
        case memberID = "member_id"
        case orderAmount = "order_amount"
        case couponNo = "coupon_no"
        case discountAmount = "discount_amount"
        case payType = "pay_type"
        case orderPay = "order_pay"
        case payStatus = "pay_status"
        case bonusPoint = "bonus_point"
        case orderStatus = "order_status"
        
//        case productList = "product_list"
//        case packageList = "package_list"
    }
}

struct OrderInfo: Codable {
    var oid: String = ""
    var orderNo: String = ""
    var orderDate: String = ""
    var storeID: String = ""
    var memberID: String = ""
    var orderAmount: String = ""
    var couponNo: String? = ""
    var discountAmount: String = ""
    var payType: String = ""
    var orderPay: String = ""
    var payStatus: String = ""
    var bonusPoint: String = ""
    var orderStatus: String = ""
    var productList: [List] = []
    var packageList: [List] = []
    var assigntype: String = ""
    
    enum CodingKeys: String, CodingKey {
        case oid
        case orderNo = "order_no"
        case orderDate = "order_date"
        case storeID = "store_id"
        case memberID = "member_id"
        case orderAmount = "order_amount"
        case couponNo = "coupon_no"
        case discountAmount = "discount_amount"
        case payType = "pay_type"
        case orderPay = "order_pay"
        case payStatus = "pay_status"
        case bonusPoint = "bonus_point"
        case orderStatus = "order_status"
        case productList = "product_list"
        case packageList = "package_list"
        case assigntype
    }
}

struct List: Codable {
//    var did: String? = ""
//    var orderNo: String? = ""
//    var memberID: String? = ""
    // 商品為package
//    var pkglistID: String? = ""
    // 商品為product
//    var productNo: String? = ""
//    var productSpec: String? = ""
    
    var productPrice: String = ""
    var orderQty: String = ""
    var totalAmount: String = ""
//    var orderStatus: String? = ""
//    var cartCreatedAt: String? = ""
    var productName: String = ""
//    var producttypeName: String? = ""
    var productPicture: String = ""
    
    enum CodingKeys: String, CodingKey {
//        case did
//        case orderNo = "order_no"
//        case memberID = "member_id"
//        case pkglistID = "pkglist_id"
//        case productNo = "product_no"
//        case productSpec = "product_spec"
        case productPrice = "product_price"
        case orderQty = "order_qty"
        case totalAmount = "total_amount"
//        case orderStatus = "order_status"
//        case cartCreatedAt = "cart_created_at"
        case productName = "product_name"
//        case producttypeName = "producttype_name"
        case productPicture = "product_picture"
    }
}

struct ProductList: Codable {
//    var did: String? = ""
//    var orderNo: String = ""
//    var memberID: String = ""
//    var productNo: String? = ""
//    var productSpec: String = ""
    var productPrice: String? = ""
    var orderQty: String? = ""
    var totalAmount: String? = ""
//    var orderStatus: String? = ""
//    var cartCreatedAt: String? = ""
    var productName: String? = ""
//    var producttypeName: String? = ""
    var productPicture: String? = ""
    
    enum CodingKeys: String, CodingKey {
//        case did
//        case orderNo = "order_no"
//        case memberID = "member_id"
//        case productNo = "product_no"
//        case productSpec = "product_spec"
        case productPrice = "product_price"
        case orderQty = "order_qty"
        case totalAmount = "total_amount"
//        case orderStatus = "order_status"
//        case cartCreatedAt = "cart_created_at"
        case productName = "product_name"
//        case producttypeName = "producttype_name"
        case productPicture = "product_picture"
    }
}

struct PackageList: Codable {
    var did: String? = ""
    var orderNo: String = ""
    var memberID: String = ""
    var pkglistID: String? = ""
    var productPrice: String? = ""
    var orderQty: String? = ""
    var totalAmount: String? = ""
    var orderStatus: String? = ""
    var cartCreatedAt: String? = ""
    var productName: String? = ""
    var productPicture: String? = ""
    
    enum CodingKeys: String, CodingKey {
        case did
        case orderNo = "order_no"
        case memberID = "member_id"
        case pkglistID = "pkglist_id"
        case productPrice = "product_price"
        case orderQty = "order_qty"
        case totalAmount = "total_amount"
        case orderStatus = "order_status"
        case cartCreatedAt = "cart_created_at"
        case productName = "product_name"
        case productPicture = "product_picture"
    }
}
