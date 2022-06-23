//
//  UITableViewCell + Ext.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/6/17.
//

import Foundation
import UIKit

extension UITableViewCell {
    static func cellIdentifier() -> String {
        return String(describing: self)
    }
}
