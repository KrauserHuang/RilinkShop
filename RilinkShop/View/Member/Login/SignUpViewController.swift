//
//  SignUpViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/7.
//

import UIKit
import SnapKit

protocol SignUpViewControllerDelegate: AnyObject {
    func finishSignup3With()
}

class SignUpViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var birthdayTF: UITextField!
    @IBOutlet weak var birthdayButton: UIButton!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var invitationCodeTF: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!

    weak var delegate: SignUpViewControllerDelegate?
    var edittingTextField: UITextField?
    var birthdayDate: Date?
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
    var datePicker = DatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextField()
        configureKeyboard()
        configreButton()
        accountLabel.text = Global.ACCOUNT
    }
    // MARK: - Keyboard
    func configureKeyboard() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        if self.view.subviews.contains(where: { $0 is DatePicker }) { // 確認Keyboard要顯示前是否有datePicker存在
            datePicker.snp.remakeConstraints { make in
                make.leading.trailing.equalTo(view)
                make.top.equalTo(view.snp.bottom)
            }

            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.datePicker.removeFromSuperview()
            }
        } else {
            guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            scrollView.contentInset = contentInsets
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.contentInset = contentInsets
    }
    
    private func configureTextField() {
        nameTF.delegate                 = self
        birthdayTF.delegate             = self
        emailTF.delegate                = self
        invitationCodeTF.delegate       = self
        
        nameTF.returnKeyType            = .next
        emailTF.returnKeyType           = .next
        invitationCodeTF.returnKeyType  = .next
    }
    
    private func configreButton() {
        signUpButton.layer.cornerRadius = signUpButton.frame.height / 2
        signUpButton.backgroundColor    = .primaryOrange
    }
    // MARK: - BirthdayTF上覆蓋一個button來呼叫DatePicker
    @IBAction func showDatePicker(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.view.subviews.contains(where: { $0 is DatePicker }) {
            datePicker.snp.remakeConstraints { make in
                make.leading.trailing.equalTo(view)
                make.top.equalTo(view.snp.bottom)
            }

            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.datePicker.removeFromSuperview()
            }
        } else {
            datePicker.delegate = self
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
    }
    // MARK: - GenderSwitch
    @IBAction func genderSwitchAction(_ sender: UIButton) {
        if sender == maleButton {
            femaleButton.isSelected = false
        } else {
            maleButton.isSelected = false
        }
        sender.isSelected = true
    }
    // MARK: - Submit SignUp
    @IBAction func signUpAction(_ sender: UIButton) {
        let name = nameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard name != "" else {
            Alert.showMessage(title: "", msg: "請填入您的姓名", vc: self) {
                self.nameTF.becomeFirstResponder()
            }
            return
        }

        guard name.count <= 25 else {
            Alert.showMessage(title: "", msg: "輸入的名字太長囉，請考慮縮短輸入。", vc: self) {
                self.nameTF.becomeFirstResponder()
            }
            return
        }

        let email = emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard email != "" else {
            Alert.showMessage(title: "", msg: "請填入您的電子郵件", vc: self) {
                self.emailTF.becomeFirstResponder()
            }
            return
        }

        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        let predicate  = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        guard predicate.evaluate(with: email) else {
            let message = "輸入電子郵件格式錯誤囉"
            Alert.showMessage(title: "", msg: message, vc: self) {
                self.emailTF.becomeFirstResponder()
            }
            return
        }

        let birthday = birthdayTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard birthday != "" else {
            Alert.showMessage(title: "", msg: "請填入您的生日", vc: self) {
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

        let city    = ""
        let region  = ""
        let address = ""

        let accountType = "0"

        let referrerPhone = invitationCodeTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if referrerPhone != "" {
            let phoneRegEx = "(09)+[0-9]{8}"
            let phonePredicate  = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
            guard phonePredicate.evaluate(with: referrerPhone) else {
                let message = "輸入推薦碼格式錯誤"
                Alert.showMessage(title: "", msg: message, vc: self) {
                    self.invitationCodeTF.becomeFirstResponder()
                }
                return
            }
        }

        HUD.showLoadingHUD(inView: self.view, text: "註冊中")
        UserService.shared.InitPersonalData(account: Global.ACCOUNT,
                                            pw: Global.ACCOUNT_PASSWORD,
                                            accountType: accountType,
                                            name: name,
                                            tel: Global.ACCOUNT,
                                            birthday: birthday!,
                                            email: email!,
                                            sex: sex,
                                            city: city,
                                            region: region,
                                            address: address,
                                            referrerPhone: referrerPhone!) { (success, response) in
            DispatchQueue.global(qos: .userInitiated).async {
                URLCache.shared.removeAllCachedResponses()
                DispatchQueue.main.sync {
                    HUD.hideLoadingHUD(inView: self.view)

                    guard success else {
                        let errmsg = response as! String
                        Alert.showMessage(title: "", msg: errmsg, vc: self) {

                        }
                        return
                    }

                    Alert.showMessage(title: "", msg: "資料更新成功\n請重新登入使用", vc: self) {

                        self.dismiss(animated: true) {
                            self.delegate?.finishSignup3With()
                        }
                    }
                }
            }
        }
    }
}
// MARK: - UITextField Delegate
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.edittingTextField = textField
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTF {
            emailTF.becomeFirstResponder()
        } else if textField == emailTF {
            invitationCodeTF.becomeFirstResponder()
        } else if textField == invitationCodeTF {
            self.view.endEditing(true)
        }
        return true
    }
}
// MARK: - DatePickerDelegate
extension SignUpViewController: DatePickerDelegate {
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
