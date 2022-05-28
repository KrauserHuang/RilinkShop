//
//  MemberInfoViewController_1.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/25.
//

import UIKit
import SnapKit

class MemberInfoViewController_1: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var saveEditButton: UIButton!
    
    var edittingTextField: UITextField?
    var user: User?
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureKeyboard()
        getUserDate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        nameTextField.text = user?.name ?? ""
        birthdayTextField.text = user?.birthday ?? ""
        phoneTextField.text = user?.tel ?? ""
        emailTextField.text = user?.email ?? ""
        
        if user?.sex == "1" {
            femaleButton.isSelected = true
        } else {
            maleButton.isSelected = true
        }
    }
    func configureView() {
        saveEditButton.backgroundColor = UIColor(hex: "4F846C")
        saveEditButton.setTitle("儲存變更", for: .normal)
        saveEditButton.setTitleColor(.white, for: .normal)
        saveEditButton.layer.cornerRadius = 20
        saveEditButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func getUserDate() {
        let accountType = "0"
        sleep(1)
//        HUD.showLoadingHUD(inView: self.view, text: "")
        UserService.shared.getPersonalData(account: MyKeyChain.getAccount() ?? "", pw: MyKeyChain.getPassword() ?? "", accountType: accountType) { success, response in
            DispatchQueue.global(qos: .userInitiated).async {
                URLCache.shared.removeAllCachedResponses()
                DispatchQueue.main.async {
                    
//                    HUD.hideLoadingHUD(inView: self.view)
                    guard success else {
                        return
                    }
                    
                    Global.personalData = response as? User
                    
                    if let user = response as? User {
                        self.user = user
                        self.nameTextField.text = user.name
                        self.birthdayTextField.text = user.birthday
                        self.phoneTextField.text = user.account
                        self.emailTextField.text = user.email
                    }
                }
            }
        }
    }
    // MARK: - Keyboard
    func configureKeyboard() {
        nameTextField.delegate = self
        birthdayTextField.delegate = self
        phoneTextField.delegate = self
        emailTextField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        view.addGestureRecognizer(tap)
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
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
    // MARK: - BirthdayTextField上覆蓋一個button來觸發DatePicker
    @IBAction func showDatePicker(_ sender: UIButton) {
        let datePicker = DatePicker()
        datePicker.delegate = self
        datePicker.setDate(dateFormatter.date(from: birthdayTextField.text!) ?? Date())
        view.addSubview(datePicker)
        var datePickerTopConstraint: Constraint?
        var datePickerBottomConstraint: Constraint?
        datePicker.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view)
            datePickerTopConstraint = make.top.equalTo(view.snp.bottom).constraint
            datePickerBottomConstraint = make.bottom.equalToSuperview().constraint
            datePickerTopConstraint?.isActive = true
            datePickerBottomConstraint?.isActive = false
        }
        
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25) {
            datePickerTopConstraint?.isActive = false
            datePickerBottomConstraint?.isActive = true
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.scrollView.scrollRectToVisible(sender.frame, animated: true)
        }
    }
    
//    @IBAction func tapView(_ sender: Any) {
//        self.view.endEditing(true)
//    }
    
    // MARK: - GenderSwitch
    @IBAction func genderSwitch(_ sender: UIButton) {
        if sender == maleButton {
            femaleButton.isSelected = false
        } else {
            maleButton.isSelected = false
        }
        sender.isSelected = true
    }
    @IBAction func show(_ sender: UIButton) {
        print("---------")
    }
    
    @IBAction func saveEditButtonTapped(_ sender: UIButton) {
        print("+++++++++")
    }
    
}
// MARK: - UITextFieldDelegate
extension MemberInfoViewController_1: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.edittingTextField = textField
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            phoneTextField.becomeFirstResponder()
        } else if textField == phoneTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}
// MARK: - DatePickerDelegate
extension MemberInfoViewController_1: DatePickerDelegate {
    func datePickerDidSelectDone(_ datePicker: DatePicker) {
        datePicker.snp.remakeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.top.equalTo(view.snp.bottom)
        }
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            datePicker.removeFromSuperview()
        }
    }
    
    func datePickerDidSelectDate(_ datePicker: DatePicker, date: Date) {
        birthdayTextField.text = dateFormatter.string(from: date)
    }
}
