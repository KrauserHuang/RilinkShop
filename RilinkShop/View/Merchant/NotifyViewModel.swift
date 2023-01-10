//
//  NotifyViewModel.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2023/1/9.
//

import Foundation
import SwiftyJSON

class NotifyViewModel {
    let type: Int
    let msg: String
    let createDateTime: String
    
    init(with input: JSON) {
        type = input["type"].intValue
        msg = input["msg"].stringValue
        createDateTime = input["createDateTime"].stringValue
    }
}
