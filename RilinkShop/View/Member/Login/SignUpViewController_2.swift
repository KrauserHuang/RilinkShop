//
//  SignUpViewController_2.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/17.
//

import UIKit

protocol SignupViewController_2_Delegate: AnyObject {
    func finishSignup2With()
}

class SignUpViewController_2: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var verifyCodeTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var resendButton: UIButton!

    var delegate: SignupViewController_2_Delegate?
    var edittingTextField: UITextField?
    let tool = Tool()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureKeyboard()
        tool.makeRoundedCornersButton(button: submitButton)
        submitButton.backgroundColor = Theme.customOrange
        tool.makeRoundedCornersButton(button: resendButton)
        resendButton.backgroundColor = Theme.customOrange
        passwordTextField.isSecureTextEntry = true
        passwordAgainTextField.isSecureTextEntry = true
    }
    // MARK: - Keyboard
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
    // MARK: - 提交驗證碼/密碼
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        let registeCode = verifyCodeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard registeCode != "" else {
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

//        let action = ""  //非修改密碼
        let action = "regpw" // 第一次註冊

        Global.ACCOUNT_PASSWORD = pw1!
        MyKeyChain.setPassword(pw1!)

        HUD.showLoadingHUD(inView: self.view, text: "驗證中")
        UserService.shared.verifyCode(action: action, account: Global.ACCOUNT, accountType: "0", registeCode: registeCode!, pw: pw1!, pw2: pw2!) { (success, response) in
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

                    Alert.showMessage(title: "", msg: "驗證成功", vc: self) {

                        Global.ACCOUNT_PASSWORD = pw1!

                        self.dismiss(animated: true) {
                            self.delegate?.finishSignup2With()
                        }
                    }
                }
            }
        }
    }
    // MARK: - 重送驗證碼
    @IBAction func resendButtonTapped(_ sender: UIButton) {
//        let action = "resetpw" //忘記密碼
        HUD.showLoadingHUD(inView: self.view, text: "連線中")
        UserService.shared.reSendCode(account: Global.ACCOUNT, accountType: "0", action: "0") { (success, response) in
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

                    Alert.showMessage(title: "", msg: "已重送驗證碼", vc: self) {

                    }
                }
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
// MARK: - UITextFieldDelegate
extension SignUpViewController_2: UITextFieldDelegate {
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
