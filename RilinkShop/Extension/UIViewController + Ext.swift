//
//  UIViewController + Ext.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2023/1/16.
//

import UIKit

extension UIViewController {
    func showEmptyStateView(with message: String, in view: UIView) { //顯示空白狀態
        let emptyStateView = RSEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
}
