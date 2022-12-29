//
//  HostelDetailViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/26.
//

import UIKit

class HostelDetailViewController: UIViewController {

    @IBOutlet weak var hostelImageView: UIImageView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var openTimeView: UIView!
    @IBOutlet weak var openTimeBGView: UIView!
    @IBOutlet weak var openTimeLabel: UILabel!
    @IBOutlet weak var phoneNoLabel: UILabel!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionBGView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var reservationButton: UIButton!

    var store = Store()
    var fixmotor: String?
//    var account: String!
//    var password: String!
//
//    init(account: String, password: String) {
//        super.init(nibName: nil, bundle: nil)
//        self.account = account
//        self.password = password
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        showStoreInfo()
    }

    private func showStoreInfo() {
        hostelImageView.setImage(with: SHOP_ROOT_URL + store.storePicture)
        nameLabel.text          = store.storeName
        locationLabel.text      = store.storeAddress
        openTimeLabel.text      = "\(store.storeOpentime)"
        phoneNoLabel.text       = "電話：\(store.storePhone)"
        descriptionLabel.text   = store.storeDescript
    }

    private func configureView() {

        nameView.layer.cornerRadius             = 10
        nameView.layer.shadowColor              = UIColor.black.cgColor
        nameView.layer.shadowOpacity            = 0.2
        nameView.layer.shadowOffset             = CGSize(width: 2, height: -2)
    
        openTimeView.layer.cornerRadius         = 10
        openTimeView.layer.shadowColor          = UIColor.black.cgColor
        openTimeView.layer.shadowOpacity        = 0.2
        openTimeView.layer.shadowOffset         = CGSize(width: 2, height: -2)
    
        descriptionView.layer.cornerRadius      = 10
        descriptionView.layer.shadowColor       = UIColor.black.cgColor
        descriptionView.layer.shadowOpacity     = 0.2
        descriptionView.layer.shadowOffset      = CGSize(width: 2, height: -2)

        reservationButton.setTitle("預約維修", for: .normal)
        reservationButton.backgroundColor       = .primaryOrange
        reservationButton.tintColor             = .white
        reservationButton.layer.cornerRadius    = 10

        openTimeBGView.clipsToBounds            = true
        openTimeBGView.layer.cornerRadius       = 10
        openTimeBGView.layer.maskedCorners      = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        descriptionBGView.clipsToBounds         = true
        descriptionBGView.layer.cornerRadius    = 10
        descriptionBGView.layer.maskedCorners   = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        if fixmotor == "0" {
            reservationButton.isHidden = true
        } else if fixmotor == "1" {
            reservationButton.isHidden = false
        }
    }

    @IBAction func reservationButtonTapped(_ sender: UIButton) {
//        let vc = ReservationInputViewController(account: account, password: password)
        let vc = ReservationInputViewController()
        vc.store = store
        navigationController?.pushViewController(vc, animated: true)
    }
}
