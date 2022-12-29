//
//  Dictionary + Ext.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/9/28.
//

import Foundation

extension Dictionary {
//    轉成[String: String]的格式
    func castToStrStr() -> [String: String] {
        var result: [String: String] = [:]
        for k in self.keys {
            if let key = k as? String, let value = self[k] as? String {
                result.updateValue(value, forKey: key)
            }
        }
        return result
    }
}
