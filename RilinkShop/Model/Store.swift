//
//  Store.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/10.
//

import Foundation

struct StoreType: Codable, Hashable {
    var id: String
    var name: String
    var updateTime: String
}

struct Store: Codable, Hashable {
    var storeID: String = ""
    var storeType: String = ""
    var storeName: String = ""
    var memberAcc: String = ""
    var memberPwd: String = ""
    var storeAddress: String = ""
    var storePhone: String = ""
    var storeEmail: String = ""
    var storeDescript: String = ""
    var storeOpentime: String = ""
    var storePicture: String = ""
    var fixmotor: String = ""
    var storeTypeName: String = ""

    enum CodingKeys: String, CodingKey {
        case storeID = "store_id"
        case storeType = "store_type"
        case storeName = "store_name"
        case memberAcc = "member_acc"
        case memberPwd = "member_pwd"
        case storeAddress = "store_address"
        case storePhone = "store_phone"
        case storeEmail = "store_email"
        case storeDescript = "store_descript"
        case storeOpentime = "store_opentime"
        case storePicture = "store_picture"
        case fixmotor
        case storeTypeName = "storetype_name"
    }
}
