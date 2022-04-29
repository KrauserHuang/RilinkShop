//
//  MainPageViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/26.
//

import UIKit

class MainPageViewController: UIViewController {

    @IBOutlet weak var hostelView: HostelView!
    @IBOutlet weak var hostelImageView: UIImageView!
    @IBOutlet weak var lowCarbTicket: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(cartButtonAction(_:)))
    }
    
    @objc func cartButtonAction(_ sender: UIBarButtonItem) {
        print("要直接跳購物車")
    }
    
    @IBAction func hostelViewTapped(_ sender: HostelView) {
        print("跳到商家據點頁面")
    }
    @IBAction func lowCarbTicketButtonTapped(_ sender: UIButton) {
        let controller = ProductDetailViewController()
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
