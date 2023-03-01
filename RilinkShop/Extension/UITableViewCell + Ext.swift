//
//  UITableViewCell + Ext.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/6/17.
//

import UIKit

extension UITableViewCell {
    static var nib: UINib {
        return UINib(nibName: String(describing: Self.self), bundle: nil)
    }
    static var reuseIdentifier: String {
        return String(describing: Self.self)
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

protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewHeaderFooterView: ReuseIdentifiable {}
