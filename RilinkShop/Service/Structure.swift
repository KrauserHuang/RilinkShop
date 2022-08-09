//
//  Structure.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/17.
//

import Foundation

typealias Completion = (_ success: Bool, _ response: AnyObject?) -> Void
typealias Handler = () -> Void

// 個人資訊
struct PersonalData {
    var account: String
    var accountType: String
    var tel: String
    var name: String
    var email: String
    var sex: String
    var city: String
    var region: String
    var address: String
    var birthday: String
    var imageName: String
    var mobileType: String

    var point: String
    var cmdImageFile: String

    var referrerPhone: String
    var referrerCount: String
}

enum ReturnCode {
    static let RETURN_SUCCESS = (101, "取得成功")
    static let MALL_RETURN_SUCCESS = ("0x0200", "SUCCESS")
}
