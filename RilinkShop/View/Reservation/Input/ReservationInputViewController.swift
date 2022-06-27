//
//  ReservationInputViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/6/16.
//

import UIKit
import SwiftUI
import DropDown

class ReservationInputViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nextStepButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var licenseTextField: UITextField!
    @IBOutlet weak var carTypeTextField: UITextField!
    @IBOutlet weak var repairTypeTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    let dropDown = DropDown()
    var store = Store()
    var edittingTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "資料填寫"
        configureView()
        configureKeyboard()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func configureView() {
        nextStepButton.setTitle("下一步", for: .normal)
        nextStepButton.backgroundColor = UIColor(hex: "#4F846C")
        nextStepButton.tintColor = .white
        nextStepButton.layer.cornerRadius = 10
    }
    // MARK: - Keyboard
    func configureKeyboard() {
        nameTextField.delegate = self
        mobileTextField.delegate = self
        licenseTextField.delegate = self
        carTypeTextField.delegate = self
        repairTypeTextField.delegate = self
        descriptionTextField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    // MARK: - 維修類別
    @IBAction func repairButtonTapped(_ sender: UIButton) {
        dropDown.dataSource = ["保養", "修車", "其他"]
        dropDown.anchorView = sender // drop down list會顯示在所設定的view下(這裡指button)
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) // 依據anchorView的bottom位置插入drop down list
        dropDown.show() // 設定完內容跟位置後要執行顯示
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
            guard let _ = self else { return }
//            sender.setTitle(item, for: .normal) // 點選對應的drop down list item要做什麼
            self?.repairTypeTextField.text = item
        }
    }
    
    @IBAction func nextStepButtonTapped(_ sender: UIButton) {
        let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let mobile = mobileTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let license = licenseTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let carType = carTypeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let repairType = repairTypeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let carDescription = descriptionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        guard name != "" else {
            let msg = "請輸入你的姓名"
            Alert.showMessage(title: "", msg: msg, vc: self) {
                self.nameTextField.becomeFirstResponder()
            }
            return
        }
//
//        guard name.count <= 25 else {
//            let msg = "輸入的名字太長囉，請考慮縮短輸入"
//            Alert.showMessage(title: "", msg: msg, vc: self) {
//                self.nameTextField.becomeFirstResponder()
//            }
//            return
//        }
//
        guard mobile != "" else {
            let msg = "請輸入你的電話"
            Alert.showMessage(title: "", msg: msg, vc: self) {
                self.mobileTextField.becomeFirstResponder()
            }
            return
        }
//
        guard license != "" else {
            let msg = "請輸入你的車牌"
            Alert.showMessage(title: "", msg: msg, vc: self) {
                self.mobileTextField.becomeFirstResponder()
            }
            return
        }
//
        guard carType != "" else {
            let msg = "請輸入你的車款與車型"
            Alert.showMessage(title: "", msg: msg, vc: self) {
                self.mobileTextField.becomeFirstResponder()
            }
            return
        }
//
        guard repairType != "" else {
            let msg = "請輸入你的維修類型"
            Alert.showMessage(title: "", msg: msg, vc: self) {
                self.mobileTextField.becomeFirstResponder()
            }
            return
        }
        
        
        let vc = CalendarViewController()
        vc.name = name
        vc.mobile = mobile
        vc.license = license
        vc.carType = carType
        vc.repairType = repairType
        vc.carDescription = carDescription
        vc.store = store
        vc.location = store.storeName
        navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - UITextFieldDelegate
extension ReservationInputViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.edittingTextField = textField
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // name -> mobile -> license -> carType -> description
        if textField == nameTextField {
            mobileTextField.becomeFirstResponder()
        } else if textField == mobileTextField {
            licenseTextField.becomeFirstResponder()
        } else if textField == licenseTextField {
            carTypeTextField.becomeFirstResponder()
        } else if textField == carTypeTextField {
            descriptionTextField.becomeFirstResponder()
        }
        return true
    }
}
