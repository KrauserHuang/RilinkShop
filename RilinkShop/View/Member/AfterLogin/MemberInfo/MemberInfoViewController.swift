//
//  MemberInfoViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/7.
//

import UIKit
import SnapKit

protocol MemberInfoViewControllerDelegate: AnyObject {
    func memberInfoDidUpdate(_ viewController: MemberInfoViewController)
}

class MemberInfoViewController: UIViewController {
    
    enum Gender {
        case male
        case female
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    
    @IBOutlet weak var birthdayTF: UITextField!
    @IBOutlet weak var numberTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var saveEditButton: UIButton!
    
    let tool = Tool()
    var user: User?
    var account = Global.ACCOUNT
    var password = Global.ACCOUNT_PASSWORD
    weak var delegate: MemberInfoViewControllerDelegate?
    var edittingTextField: UITextField?
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.tabBarController?.tabBar.isHidden = true
        configureKeyboard()
        
        tool.makeRoundedCornersButton(button: saveEditButton)
        saveEditButton.backgroundColor = tool.customGreen
        
        getUserData()
//        configureView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
        print(user)
        nameTF.text = user?.name ?? ""
        birthdayTF.text = user?.birthday ?? ""
        numberTF.text = user?.account ?? ""
        emailTF.text = user?.email ?? ""
        
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
//        saveEditButton.titleLabel?.font.pointSize = 25 要怎麼改文字大小
//        saveEditButton.我要改變style to default but how!
//        saveEditButton.我要接著改變文字變粗體
//        saveEditButton.layer.cornerRadius = saveEditButton.frame.size.height / 2
//        saveEditButton.layer.cornerRadius = saveEditButton.bounds.height / 2
        saveEditButton.layer.cornerRadius = saveEditButton.frame.height / 2
        saveEditButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveEditButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    func getUserData() {
        let accountType = "0"
//        sleep(1)
//        HUD.showLoadingHUD(inView: self.view, text: "")
        UserService.shared.getPersonalData(account: account, pw: password, accountType: accountType) { success, response in
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
                        self.nameTF.text = user.name
                        self.birthdayTF.text = user.birthday
                        self.numberTF.text = user.account
                        self.emailTF.text = user.email
                    }
                }
            }
        }
    }
    // MARK: - Keyboard
    func configureKeyboard(){
        nameTF.delegate = self
        birthdayTF.delegate = self
        numberTF.delegate = self
        emailTF.delegate = self
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGes)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func dismissKeyboard(){
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // MARK: - BirthdayTF上覆蓋一個button來呼叫DatePicker
    @IBAction func showDatePicker(_ sender: UIButton) {
        let datePicker = DatePicker()
        datePicker.delegate = self
        datePicker.setDate(dateFormatter.date(from: birthdayTF.text!) ?? Date())
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
    // MARK: - GenderSwitch
    @IBAction func genderSwitch(_ sender: UIButton) {
        if sender == maleButton {
            femaleButton.isSelected = false
        } else {
            maleButton.isSelected = false
        }
        sender.isSelected = true
    }
    // MARK: - Submit Edit Change
    @IBAction func saveEditButtonTapped(_ sender: UIButton) {
        let accountType = "0"
        guard let tel = numberTF.text else {
            return
        }
        
        guard let name = nameTF.text,
              name != "" else {
                  let message = "請輸入姓名"
                  Alert.showMessage(title: "", msg: message, vc: self) {
                      self.nameTF.becomeFirstResponder()
                  }
                  return
              }
        
        guard let email = emailTF.text,
              email != "" else {
                  let message = "請輸入電子郵件"
                  Alert.showMessage(title: "", msg: message, vc: self) {
                      self.emailTF.becomeFirstResponder()
                  }
                  return
              }
        
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        let predicate  = NSPredicate(format: "SELF MATCHES %@", emailRegEx)

        guard predicate.evaluate(with: email) else {
            let message = "輸入電子郵件格式錯誤"
            Alert.showMessage(title: "", msg: message, vc: self) {
                self.emailTF.becomeFirstResponder()
            }
            return
        }
        
        guard let birthday = birthdayTF.text,
              birthday != "" else {
                  let message = "請輸入生日"
                  Alert.showMessage(title: "", msg: message, vc: self) {
                      self.birthdayTF.becomeFirstResponder()
                  }
                  return
              }
        
        var sex = ""
        if maleButton.isSelected {
            sex = "0"
        } else {
            sex = "1"
        }
        
        let city = ""
        let region = ""
        let address = ""
        
        HUD.showLoadingHUD(inView: self.view, text: "")
        UserService.shared.modifyPersonalData(account: Global.ACCOUNT, pw: Global.ACCOUNT_PASSWORD, accountType: accountType, name: name, tel: tel, birthday: birthday, email: email, sex: sex, city: city, region: region, address: address) { success, response in
            DispatchQueue.global(qos: .userInitiated).async {
                URLCache.shared.removeAllCachedResponses()
                DispatchQueue.main.sync {
                    HUD.hideLoadingHUD(inView: self.view)
                    guard success else {
                        let message = response as! String
                        Alert.showMessage(title: "", msg: message, vc: self, handler: nil)
                        return
                    }
                    
                    Alert.showMessage(title: "", msg: "修改成功", vc: self) {
                        self.navigationController?.popViewController(animated: true)
                        self.delegate?.memberInfoDidUpdate(self)
                    }
                }
            }
        }
    }
}
// MARK: - UITextFieldDelegate
extension MemberInfoViewController: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.edittingTextField = textField
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTF {
            numberTF.becomeFirstResponder()
        } else if textField == numberTF {
            emailTF.becomeFirstResponder()
        } else if textField == emailTF {
            textField.resignFirstResponder()
        }
        return true
    }
}
// MARK: - DatePickerDelegate
extension MemberInfoViewController: DatePickerDelegate {
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
        birthdayTF.text = dateFormatter.string(from: date)
    }
}
