//
//  HostelDetailViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/26.
//

import UIKit

class HostelDetailViewController: UIViewController {
    
    @IBOutlet weak var hostelImageView: UIImageView!
    @IBOutlet weak var openTimeLabel: UILabel!
    @IBOutlet weak var phoneNoLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var store = Store()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showStoreInfo()
    }
    
    func showStoreInfo() {
        hostelImageView.setImage(imageURL: TEST_ROOT_URL + store.storePicture)
        openTimeLabel.text = "營業時間：\(store.storeOpentime)"
        phoneNoLabel.text = "電話：\(store.storePhone)"
        descriptionLabel.text = store.storeDescript
    }
}
