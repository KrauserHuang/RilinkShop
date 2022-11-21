//
//  Banner.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/9/23.
//

import UIKit

struct Banner: Codable, Hashable {
    let bid: String
    let bannerSubject: String
    let bannerDate: String
    let bannerEndDate: String
    let bannerDescript: String
    let bannerPicture: String
    let bannerLink: String

    enum CodingKeys: String, CodingKey {
        case bid
        case bannerSubject = "product_type"
        case bannerDate = "banner_enddate"
        case bannerEndDate = "producttype_name"
        case bannerDescript = "banner_descript"
        case bannerPicture = "banner_picture"
        case bannerLink = "banner_link"
    }
}
