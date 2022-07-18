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
    var fixmotor: String?
    
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
        reservationButton.backgroundColor = Theme.customOrange
        reservationButton.tintColor = .white
        reservationButton.layer.cornerRadius = 10
        hostelImageView.layer.cornerRadius = 10
        
        if fixmotor == "0" {
            reservationButton.isHidden = true
        } else if fixmotor == "1" {
            reservationButton.isHidden = false
        }
    }
    
    @IBAction func reservationButtonTapped(_ sender: UIButton) {
        let vc = ReservationInputViewController()
        vc.store = store
        navigationController?.pushViewController(vc, animated: true)
    }
}
