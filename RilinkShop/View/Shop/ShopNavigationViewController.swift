//
//  ShopNavigationViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/6.
//

import UIKit

class ShopNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let controller = ShopViewController()
        controller.delegate = self
    }
}

extension ShopNavigationViewController: ShopViewControllerDelegate {
    func showInfo(_ viewController: ShopViewController, for item: Product) {
//        viewController.delegate = self
        let productDetailVC = ProductDetailViewController()
//        productDetailVC.itemInfo = item
        viewController.navigationController?.pushViewController(productDetailVC, animated: true)
    }
}
