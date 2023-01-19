//
//  BaseViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2023/1/18.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItems()
    }
    
    private func navigationItems() {
        let shoppingcartButton = UIBarButtonItem(image: UIImage(systemName: "cart"),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(toCartViewController))
        let notificationButton = UIBarButtonItem(image: UIImage(systemName: "bell"),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(toMessageViewController))
        navigationItem.rightBarButtonItems = [shoppingcartButton, notificationButton]
    }
    @objc private func toCartViewController() {
        let vc = CartViewController()
//        let vc = CartViewController(account: LocalStorageManager.shared.getData(String.self, forKey: .userIdKey)!,
//                                    password: LocalStorageManager.shared.getData(String.self, forKey: .userPasswordKey)!)
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func toMessageViewController() {
        let vc = MessageViewController()
        vc.title = "訊息中心"
        navigationController?.pushViewController(vc, animated: true)
    }
}
