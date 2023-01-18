//
//  History.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/11/22.
//

import Foundation

struct History: Hashable {
    let type: String
    let title: String
    let message: String
    let log: String
    let push_datetime: String
}

struct AdminHistory {
    let type: String
    let title: String
    let message: String
    let updatetime: String
}
