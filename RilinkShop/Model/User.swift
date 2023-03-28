//
//  User.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/4.
//

import Foundation
// MARK: - 使用者相關
struct UserResponse: Codable {
    let status: String
    let returnCode: String
    let returnData: User
}

struct User: Codable {
    var account: String = ""
    var accountType: String = ""
    var tel: String = ""
    var name: String = ""
    var email: String = ""
    var sex: String = ""
    var city: String = ""
    var region: String = ""
    var address: String = ""
    var birthday: String = ""
    var imageName: String? = ""
    var mobileType: String? = ""
    
    var point: String = ""
    var cmdImageFile: String? = ""
    
    var referrerPhone: String? = ""
    var referrerCount: String? = ""
    var referrerStoreName: String = ""
    var referrerStoreType: String = ""
}
// MARK: - 店長相關
struct StoreID: Codable {
    var status: String = ""
    var code: String = ""
    var info: [StoreIDInfo] = []
}

struct StoreIDInfo: Codable {
    var storeName: String = ""
    var storeID: String = ""

    enum CodingKeys: String, CodingKey {
        case storeName = "store_name"
        case storeID = "store_id"
    }
}

struct StoreAdminLogin: Codable {
    let status: String
    let code: String
    let info: StoreInfo
    let responseMessage: String
}

struct StoreInfo: Codable {
    var storeName: String = ""
    var storeAddress: String = ""
    var storePhone: String = ""
    var storeEmail: String = ""
    var storeDescript: String = ""
    var storeOpentime: String = ""
    var storePicture: String = ""

    enum CodingKeys: String, CodingKey {
        case storeName = "store_name"
        case storeAddress = "store_address"
        case storePhone = "store_phone"
        case storeEmail = "store_email"
        case storeDescript = "store_descript"
        case storeOpentime = "store_opentime"
        case storePicture = "store_picture"
    }
}
