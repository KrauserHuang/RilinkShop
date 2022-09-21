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

extension UITableViewCell {

    var tableView: UITableView? {
        return (next as? UITableView) ?? (parentViewController as? UITableViewController)?.tableView
    }

    var indexPath: IndexPath? {
        return tableView?.indexPath(for: self)
    }
}
