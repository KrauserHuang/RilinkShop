//
//  MerchantMainViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2023/1/9.
//

import UIKit

protocol MerchantMainViewControllerDelegate: AnyObject {
    func didTapScanButton(_ viewController: MerchantMainViewController)
    func didTapNotifyButton(_ viewController: MerchantMainViewController)
    func didTapPreferencesButton(_ viewController: MerchantMainViewController)
}

class MerchantMainViewController: UIViewController {
    
    @IBOutlet weak var storeNameLabel: UILabel!
    
    weak var delegate: MerchantMainViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storeNameLabel.text = Global.OWNER_STORE_NAME
    }
    
    @IBAction func scanButtonTapped(_ sender: UIButton) {
        delegate?.didTapScanButton(self)
    }
    
    @IBAction func preferencesButtonTapped(_ sender: UIButton) {
        delegate?.didTapPreferencesButton(self)
    }
    
    @IBAction func notifyButtonTapped(_ sender: UIButton) {
        delegate?.didTapNotifyButton(self)
    }
}
