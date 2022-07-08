//
//  LoginViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/6.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet var containerViews: [UIView]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    // 先將所有containerViews給隱藏再將點選後sender回傳的selectedSegmentIndex，將其顯示
    @IBAction func switchLogin(_ sender: UISegmentedControl) {
        containerViews.forEach { $0.isHidden = true }
        containerViews[sender.selectedSegmentIndex].isHidden = false
    }
    
}
