//
//  HostelCheckoutViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/6/17.
//

import UIKit
import EzPopup

class HostelCheckoutViewController: UIViewController {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var licenseLabel: UILabel!
    @IBOutlet weak var carTypeLabel: UILabel!
    @IBOutlet weak var repairTypeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var appointmentLabel: UILabel!
    @IBOutlet weak var appointmentCheckoutButton: UIButton!

    var location: String?
    var name: String?
    var mobile: String?
    var license: String?
    var carType: String?
    var repairType: String?
    var carDescription: String? = ""
    var appointment: String?
    var duration: String?
    var store = Store()
    var account: String!
    var password: String!
    
    init(account: String, password: String) {
        super.init(nibName: nil, bundle: nil)
        self.account = account
        self.password = password
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "預約確認"
        configureButton()
        configureView()
    }
    
    private func configureButton() {
        appointmentCheckoutButton.setTitle("預約確認", for: .normal)
        appointmentCheckoutButton.backgroundColor       = .primaryOrange
        appointmentCheckoutButton.tintColor             = .white
        appointmentCheckoutButton.layer.cornerRadius    = 10
    }

    private func configureView() {
        locationLabel.text      = location
        nameLabel.text          = name
        mobileLabel.text        = mobile
        licenseLabel.text       = license
        carTypeLabel.text       = carType
        repairTypeLabel.text    = repairType
        descriptionLabel.text   = carDescription ?? ""
        appointmentLabel.text   = "\(appointment!) \(duration!)"
    }

    @IBAction func confirmAppointmentAction(_ sender: UIButton) {
//        let popupVC = PopupViewController(contentController: SuccessAlert(), popupWidth: self.view.frame.width - 32, popupHeight: self.view.frame.height * 0.5)
//        popupVC.cornerRadius = 20
//        present(popupVC, animated: true)
        guard let appointment = appointment,
              let duration = duration,
              let name = name,
              let mobile = mobile,
              let license = license,
              let carType = carType,
              let repairType = repairType,
              let carDescription = carDescription else { return }
        HUD.showLoadingHUD(inView: self.view, text: "預約中")
        FixMotorService.shared.bookingFixMotor(id: account,
                                               pwd: password,
                                               storeId: store.storeID,
                                               bookingdate: appointment,
                                               duration: duration,
                                               name: name,
                                               phone: mobile,
                                               motorNo: license,
                                               motorType: carType,
                                               fixType: repairType,
                                               description: carDescription) { success, response in
            HUD.hideLoadingHUD(inView: self.view)
            guard success else {
                let errorMsg = response as! String
                Alert.showMessage(title: "", msg: errorMsg, vc: self, handler: nil)
                return
            }

            let successMsg = response as! String
            Alert.showMessage(title: "", msg: successMsg, vc: self) {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
