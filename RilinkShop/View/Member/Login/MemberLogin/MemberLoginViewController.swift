//
//  MemberLoginViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/7/6.
//

import UIKit

protocol MemberLoginViewControllerDelegate: AnyObject {
    func finishLoginView(_ viewController: MemberLoginViewController, action: finishLoginViewWith)
}

class MemberLoginViewController: UIViewController {

    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var visibleButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var privateButton: UIButton!

    let tool = Tool()
    var delegate: MemberLoginViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tool.makeRoundedCornersButton(button: loginButton)
        loginButton.backgroundColor = Theme.customOrange
        tool.makeRoundedCornersButton(button: signupButton)
        signupButton.backgroundColor = Theme.customOrange

        hideKeyBoard()
        configureTextField()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        accountTextField.text = ""
        passwordTextField.text = ""
    }

    func configureTextField() {
        accountTextField.delegate = self
        passwordTextField.delegate = self
    }
    // MARK: - Keyboard
    func hideKeyBoard() {
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(cancelFocus))
        tapGes.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGes)
    }
    @objc func cancelFocus() {
        self.view.endEditing(true)
    }
    // MARK: - Password visibility
    @IBAction func visibleAction(_ sender: UIButton) {
        if passwordTextField.isSecureTextEntry {
            visibleButton.setImage(UIImage(named: "eye"), for: .normal)
            passwordTextField.isSecureTextEntry = false
        } else {
            visibleButton.setImage(UIImage(named: "eyeSlash"), for: .normal)
            passwordTextField.isSecureTextEntry = true
        }
    }
    // MARK: - Login
    @IBAction func loginAction(_ sender: UIButton) {
        /*
         0. 檢查欄位有無空白
         1. 檢查欄位輸入格式有無錯誤(基礎檢查)
         2. 與後端檢查使否有對應
         */
        guard let account = accountTextField.text,
              let password = passwordTextField.text else { return }
        guard account != "",
              password != "" else {
                  let alertController = UIAlertController(title: "", message: "欄位不可空白", preferredStyle: .alert)
                  let okAction = UIAlertAction(title: "確認", style: .default, handler: nil)
                  alertController.addAction(okAction)
                  present(alertController, animated: true, completion: nil)
                  return
              }
        let accountPredicate = NSPredicate(format: "SELF MATCHES %@", "^09[0-9]{8}$")
        guard accountPredicate.evaluate(with: account) else {
            let alert = UIAlertController.simpleOKAlert(title: "", message: "請確認是否輸入正確之手機號碼", buttonTitle: "確認", action: nil)
            self.present(alert, animated: true, completion: nil)
            return
        }

        Global.ACCOUNT = account
        Global.ACCOUNT_PASSWORD = password

        HUD.showLoadingHUD(inView: self.view, text: "登入中")

        UserService.shared.userLogin(id: account, pwd: password) { success, response in
            DispatchQueue.global(qos: .userInitiated).async {
                URLCache.shared.removeAllCachedResponses()
                DispatchQueue.main.async {

                    HUD.hideLoadingHUD(inView: self.view)

                    guard success else {
                        let errorMsg = response as! String
                        Alert.showMessage(title: "", msg: errorMsg, vc: self, handler: nil)
                        return
                    }
                    // 登入成功才把帳密儲存在Keychain裡面
                    MyKeyChain.setAccount(Global.ACCOUNT)
                    MyKeyChain.setPassword(Global.ACCOUNT_PASSWORD)

                    self.delegate?.finishLoginView(self, action: .Login)
                }
            }
        }
    }
    // MARK: - Forgot
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        delegate?.finishLoginView(self, action: .Forget)
    }
    // MARK: - Signup
    @IBAction func signupAction(_ sender: UIButton) {
        dismiss(animated: true) {
            self.delegate?.finishLoginView(self, action: .Singup)
        }
    }
    // MARK: - 條款頁
    @IBAction func privateAction(_ sender: UIButton) {
        let vc = PrivateRuleViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension MemberLoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
