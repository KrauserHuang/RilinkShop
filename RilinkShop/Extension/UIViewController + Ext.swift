//
//  UIViewController + Ext.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2023/1/16.
//

import UIKit
import SafariServices

extension UIViewController {
    func showEmptyStateView(with message: String, in view: UIView) { //顯示空白狀態
        let emptyStateView = RSEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
    
    func showSafariViewController(with urlString: String) {
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
    }
}
