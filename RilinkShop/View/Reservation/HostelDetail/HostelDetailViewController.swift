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
    @IBOutlet weak var reservationButton: UIButton!
    
    var store = Store()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        showStoreInfo()
    }
    
    func showStoreInfo() {
        hostelImageView.setImage(imageURL: SHOP_ROOT_URL + store.storePicture)
        openTimeLabel.text = "營業時間：\(store.storeOpentime)"
        phoneNoLabel.text = "電話：\(store.storePhone)"
        descriptionLabel.text = store.storeDescript
    }
    
    func configureView() {
        reservationButton.setTitle("預約維修", for: .normal)
        reservationButton.backgroundColor = UIColor(hex: "#4F846C")
        reservationButton.tintColor = .white
        reservationButton.layer.cornerRadius = 10
    }
    
    @IBAction func reservationButtonTapped(_ sender: UIButton) {
        let vc = ReservationInputViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
