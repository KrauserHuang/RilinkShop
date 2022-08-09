//
//  ForgotPasswordViewController_2.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/18.
//

import UIKit

protocol ForgotPasswordViewController_2_Delegate: AnyObject {
    func finishPwdStep2ViewWith()
}

class ForgotPasswordViewController_2: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var verifyCodeTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!

    weak var delegate: ForgotPasswordViewController_2_Delegate?
    let tool = Tool()
    var edittingTextField: UITextField?
    var tempAccount: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureKeyboard()

        tool.makeRoundedCornersButton(button: submitButton)
        submitButton.backgroundColor = Theme.customOrange
    }

    func configureKeyboard() {
        verifyCodeTextField.delegate = self
        passwordTextField.delegate = self
        passwordAgainTextField.delegate = self
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

    @IBAction func submitButtonTapped(_ sender: UIButton) {

        let account = tempAccount
        let accountType = "0"

        let verifyCode = verifyCodeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard verifyCode != "" else {
            Alert.showMessage(title: "", msg: "請輸入驗證碼", vc: self) {
                self.verifyCodeTextField.becomeFirstResponder()
            }
            return
        }

        let pw1 = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard pw1 != "" else {
            Alert.showMessage(title: "", msg: "請設定登入密碼", vc: self) {
                self.passwordTextField.becomeFirstResponder()
            }
            return
        }

        let pw2 = passwordAgainTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard pw2 != "" else {
            Alert.showMessage(title: "", msg: "請再次輸入密碼", vc: self) {
                self.passwordAgainTextField.becomeFirstResponder()
            }
            return
        }

        guard pw1 == pw2 else {
            Alert.showMessage(title: "", msg: "請確認輸入密碼正確", vc: self) {
                self.passwordAgainTextField.becomeFirstResponder()
            }
            return
        }

        let action = "resetpw"  // 非修改密碼

//        Global.ACCOUNT_PASSWORD = pw1!
//        MyKeyChain.setPassword(pw1!)

        HUD.showLoadingHUD(inView: self.view, text: "驗證中")
        UserService.shared.verifyCode(action: action,
                                      account: account!,
                                      accountType: accountType,
                                      registeCode: verifyCode!,
                                      pw: pw1!,
                                      pw2: pw2!) { (success, response) in
            DispatchQueue.global(qos: .userInitiated).async {
                URLCache.shared.removeAllCachedResponses()
                DispatchQueue.main.sync {

                    guard success else {
                        HUD.hideLoadingHUD(inView: self.view)
                        let errmsg = response as! String
                        Alert.showMessage(title: "", msg: errmsg, vc: self) {

                        }
                        return
                    }

                    HUD.hideLoadingHUD(inView: self.view)
                    Global.ACCOUNT_PASSWORD = pw1!
                    MyKeyChain.setPassword(pw1!)

                    let message = "密碼已修改，請以新密碼重新登入。"
                    Alert.showMessage(title: "", msg: message, vc: self) {

                        self.dismiss(animated: true) {
                            self.delegate?.finishPwdStep2ViewWith()
                        }
                    }
                }
            }
        }
    }

    func updateMallPassword(mobile: String, password: String) {

        UserService.shared.mallUpdatePassword(mobile: mobile, password: password) { (_, _) in

            DispatchQueue.global(qos: .userInitiated).async {
                URLCache.shared.removeAllCachedResponses()
                // self.updateCouponPassword(customerid: mobile, newpassword: password)
            }
        }
    }

}
// MARK: - UITextFieldDelegate
extension ForgotPasswordViewController_2: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.edittingTextField = textField
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == verifyCodeTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordAgainTextField.becomeFirstResponder()
        } else if textField == passwordAgainTextField {
            self.view.endEditing(true)
        }
        return true
    }
}
