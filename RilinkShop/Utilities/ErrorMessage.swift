//
//  ErrorMessage.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/11/22.
//

import Foundation

enum RSError: String, Error {
    case connectionFailure = "伺服器連線失敗，請確認你的網路連線是否穩定"
}
