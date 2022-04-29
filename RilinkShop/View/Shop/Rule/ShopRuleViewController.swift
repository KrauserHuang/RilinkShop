//
//  ShopRuleViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/26.
//

import UIKit

class ShopRuleViewController: UIViewController {

    @IBOutlet weak var borderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "購物條款"
        configureView()
    }
    
    func configureView() {
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor(hex: "#54a0ff")?.cgColor
        borderView.layer.cornerRadius = 25
    }
}
