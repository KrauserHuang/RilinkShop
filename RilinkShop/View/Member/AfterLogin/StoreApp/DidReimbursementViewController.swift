//
//  DidReimbursementViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/12.
//

import UIKit

class DidReimbursementViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backToMemberCenter(_ sender: UIButton) {
        dismiss(animated: true) {
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }

}
