//
//  ReservationInputViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/6/16.
//

import UIKit
import SwiftUI

class ReservationInputViewController: UIViewController {

    @IBOutlet weak var nextStepButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var licenseTextField: UITextField!
    @IBOutlet weak var carTypeTextField: UITextField!
    @IBOutlet weak var repairTypeTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "資料填寫"
        configureView()
        configureTextField()
    }
    
    func configureView() {
        nextStepButton.setTitle("下一步", for: .normal)
        nextStepButton.backgroundColor = UIColor(hex: "#4F846C")
        nextStepButton.tintColor = .white
        nextStepButton.layer.cornerRadius = 10
    }
    
    func configureTextField() {
        nameTextField.delegate = self
        mobileTextField.delegate = self
        licenseTextField.delegate = self
        carTypeTextField.delegate = self
        repairTypeTextField.delegate = self
        descriptionTextField.delegate = self
    }
    
    @IBAction func nextStepButtonTapped(_ sender: UIButton) {
        let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let mobile = mobileTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let license = licenseTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let carType = carTypeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let repairType = repairTypeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let description = descriptionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
//        guard name != "" else {
//            let msg = "請輸入你的姓名"
//            Alert.showMessage(title: "", msg: msg, vc: self) {
//                self.nameTextField.becomeFirstResponder()
//            }
//            return
//        }
//
//        guard name.count <= 25 else {
//            let msg = "輸入的名字太長囉，請考慮縮短輸入"
//            Alert.showMessage(title: "", msg: msg, vc: self) {
//                self.nameTextField.becomeFirstResponder()
//            }
//            return
//        }
//
//        guard mobile != "" else {
//            let msg = "請輸入你的電話"
//            Alert.showMessage(title: "", msg: msg, vc: self) {
//                self.mobileTextField.becomeFirstResponder()
//            }
//            return
//        }
//
//        guard license != "" else {
//            let msg = "請輸入你的車牌"
//            Alert.showMessage(title: "", msg: msg, vc: self) {
//                self.mobileTextField.becomeFirstResponder()
//            }
//            return
//        }
//
//        guard carType != "" else {
//            let msg = "請輸入你的車款與車型"
//            Alert.showMessage(title: "", msg: msg, vc: self) {
//                self.mobileTextField.becomeFirstResponder()
//            }
//            return
//        }
//
//        guard repairType != "" else {
//            let msg = "請輸入你的維修類型"
//            Alert.showMessage(title: "", msg: msg, vc: self) {
//                self.mobileTextField.becomeFirstResponder()
//            }
//            return
//        }
        
        
        let vc = CalendarViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ReservationInputViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //
        return true
    }
}
