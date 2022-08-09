//
//  StoreAppViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/12.
//

import UIKit

protocol StoreAppViewControllerDelegate: AnyObject {
    func backToLogin(_ viewController: StoreAppViewController)
    func toQRScan(_ viewController: StoreAppViewController)
}

class StoreAppViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton! {
        didSet {
            logoutButton.backgroundColor = UIColor(hex: "4F846C")
            logoutButton.layer.cornerRadius = logoutButton.frame.size.height / 2
            logoutButton.setTitle("登出", for: .normal)
            logoutButton.setTitleColor(.white, for: .normal)
        }
    }

    weak var delegate: StoreAppViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func scan(_ sender: UIButton) {
        let controller = QRCodeViewController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
//        delegate?.toQRScan(self)
    }

    @IBAction func logoutAction(_ sender: Any) {
//        delegate?.backToLogin(self)
        MyKeyChain.logout()
        dismiss(animated: true, completion: nil)
    }
}
