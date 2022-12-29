//
//  LoginViewController_1.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/18.
//

import UIKit
import SnapKit

protocol LoginViewController_1_Delegate: AnyObject {
    func finishLoginView(_ viewController: LoginViewController_1, action: finishLoginViewWith)
    func showStoreID(_ viewController: LoginViewController_1)
}

class LoginViewController_1: UIViewController {

    @IBOutlet weak var loginSegmentedControl: UISegmentedControl!
    @IBOutlet weak var storeIDButton: UIButton!
    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var visibleButton: UIButton!
    @IBOutlet weak var privateButton: UIButton!
    
    var delegate: LoginViewController_1_Delegate?
    var storeIDs: [StoreIDInfo]?
    var storeIDInfo: StoreIDInfo?
    let storePicker = StorePicker()
    let toolBar = UIToolbar()
    var storeID: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarController?.tabBar.isHidden = true
        storeIDButton.isHidden = true
        
        configureButton()
        hideKeyBoard()
        getStoreID()
        configureTextField()
        configureStorePicker()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        accountTextField.text   = ""
        passwordTextField.text  = ""
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.storePicker.removeFromSuperview()
            self.toolBar.removeFromSuperview()
        }
    }
    
    private func configureButton() {
        storeIDButton.layer.cornerRadius    = storeIDButton.frame.height / 2
        storeIDButton.backgroundColor       = .primaryOrange
        loginButton.layer.cornerRadius      = loginButton.frame.height / 2
        loginButton.backgroundColor         = .primaryOrange
        signupButton.layer.cornerRadius     = signupButton.frame.height / 2
        signupButton.backgroundColor        = .primaryOrange
    }
    
    private func configureTextField() {
        accountTextField.delegate   = self
        passwordTextField.delegate  = self
    }
    
    private func hideKeyBoard() {
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(cancelFocus))
        tapGes.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGes)
    }
    @objc func cancelFocus() {
        view.endEditing(true)
    }
    
    private func configureStorePicker() {
        storePicker.toolBarDelegate = self
        storePicker.delegate        = self
        storePicker.selectRow(0, inComponent: 0, animated: false)
    }
    
    private func getStoreID() {
        HUD.showLoadingHUD(inView: view, text: "取得店家資訊中")
        UserService.shared.getStoreIDList(storeAcc: "99999", storePwd: "99999") { success, response in
            
            DispatchQueue.global(qos: .userInitiated).async {
                URLCache.shared.removeAllCachedResponses()
                DispatchQueue.main.async {
                    HUD.hideLoadingHUD(inView: self.view)

                    guard success else {
                        return
                    }

                    guard let storeIDInfo = response as? [StoreIDInfo] else {
                        print("response downcast fail")
                        return
                    }
                    self.storeIDs = storeIDInfo
                }
            }
        }
    }
    // MARK: - SegmentedControl
    @IBAction func loginSegmentedControl(_ sender: UISegmentedControl) {
        accountTextField.text = ""
        passwordTextField.text = ""
        if sender.selectedSegmentIndex == 0 {
            storeIDButton.isHidden = true
            signupButton.isHidden = false
        } else {
            storeIDButton.isHidden = false
            signupButton.isHidden = true
        }
    }
    // MARK: - Button to call pickerView
    @IBAction func showStoreID(_ sender: UIButton) {
        view.addSubview(storePicker)

        toolBar.barStyle        = .default
        toolBar.isTranslucent   = true
        toolBar.tintColor       = .black
        toolBar.sizeToFit()

        let doneButton  = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        view.addSubview(toolBar)

        storePicker.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
        toolBar.snp.makeConstraints { make in
            make.leading.trailing.equalTo(storePicker)
            make.bottom.equalTo(storePicker.snp.top)
        }

        var storePickerTopConstraint: Constraint?
        var storePickerBottomConstraint: Constraint?
        storePicker.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view)
            storePickerTopConstraint = make.top.equalTo(view.snp.bottom).constraint
            storePickerBottomConstraint = make.bottom.equalToSuperview().constraint
            storePickerTopConstraint?.isActive = true
            storePickerBottomConstraint?.isActive = false
        }

        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25) {
            storePickerTopConstraint?.isActive = false
            storePickerBottomConstraint?.isActive = true
            self.view.layoutIfNeeded()
        }
    }
    @objc func doneTapped(_ sender: UIBarButtonItem) {
        storePicker.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.snp.bottom)
        }

        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.storePicker.removeFromSuperview()
            self.toolBar.removeFromSuperview()
        }
    }
    // MARK: - Password visibility
    @IBAction func visibleAction(_ sender: UIButton) {
        if passwordTextField.isSecureTextEntry {
            visibleButton.setImage(Images.eye, for: .normal)
            passwordTextField.isSecureTextEntry = false
        } else {
            visibleButton.setImage(Images.eyeSlash, for: .normal)
            passwordTextField.isSecureTextEntry = true
        }
    }
    // MARK: - Login
    @IBAction func loginAction(_ sender: UIButton) {
        /*
         0. 檢查欄位有無空白
         1. 檢查是否用店長或一般使用者登入
         2. 檢查欄位輸入格式有無錯誤(基礎檢查)
         3. 與後端檢查使否有對應
         */
        guard let account = accountTextField.text, let password = passwordTextField.text else { return }
        guard account != "", password != "" else {
            Alert.showMessage(title: "欄位不可空白", msg: "請輸入電話號碼、密碼", vc: self)
            return
        }

        Global.ACCOUNT = account
        Global.ACCOUNT_PASSWORD = password
//        LocalStorageManager.shared.setData(account, key: .userIdKey)
//        LocalStorageManager.shared.setData(password, key: .userPasswordKey)
        MyKeyChain.setAccount(account)
        MyKeyChain.setPassword(password)

        print(#function)
        print("password:\(password)")
        print("globalpassword:\(Global.ACCOUNT_PASSWORD)")
        // 一般使用者登入
        if loginSegmentedControl.selectedSegmentIndex == 0 {
            // 只檢查密碼格式
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
//                        LocalStorageManager.shared.setData(account, key: .userIdKey)
//                        LocalStorageManager.shared.setData(password, key: .userPasswordKey)
                        MyKeyChain.setAccount(Global.ACCOUNT)
                        MyKeyChain.setPassword(Global.ACCOUNT_PASSWORD)
                        
//                        NotificationService.shared.memberSetToken(id: account,
//                                                                  pwd: password,
//                                                                  token: <#T##String#>) { success, response in
//                            <#code#>
//                        }

                        self.delegate?.finishLoginView(self, action: .Login)
                    }
                }
            }
        } else if loginSegmentedControl.selectedSegmentIndex == 1 { // 店長登入

            guard storeIDButton.titleLabel?.text != "店家ID" else {
                let errorMsg = "請選擇店家"
                Alert.showMessage(title: "", msg: errorMsg, vc: self, handler: nil)
                return
            }

            Global.ACCOUNT = account
            Global.ACCOUNT_PASSWORD = password

            let storeID = storeID ?? ""

            HUD.showLoadingHUD(inView: self.view, text: "登入中")

            UserService.shared.storeAdminLogin(storeAcc: account, storePwd: password, storeID: storeID) { success, response in
                DispatchQueue.global(qos: .userInitiated).async {
                    URLCache.shared.removeAllCachedResponses()
                    DispatchQueue.main.async {

                        HUD.hideLoadingHUD(inView: self.view)

                        guard success else {
                            let errmsg = response as! String
                            Alert.showMessage(title: "", msg: errmsg, vc: self, handler: nil)
                            return
                        }
                        
//                        LocalStorageManager.shared.setData(account, key: .userIdKey)
//                        LocalStorageManager.shared.setData(password, key: .userPasswordKey)
                        MyKeyChain.setBossAccount(Global.ACCOUNT)
                        MyKeyChain.setBossPassword(Global.ACCOUNT_PASSWORD)

//                        self.delegate?.finishLoginView(self, action: .BossLogIn)
                        let vc = StoreAppViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    // MARK: - Forgot
    @IBAction func forgotPwAction(_ sender: UIButton) {
        delegate?.finishLoginView(self, action: .Forget)
    }
    // MARK: - SignUp
    @IBAction func signUpAction(_ sender: UIButton) {
        dismiss(animated: true) {
            self.delegate?.finishLoginView(self, action: .Singup)
        }
    }
    // MARK: - 條款頁
    @IBAction func privateAction(_ sender: UIButton) {
        navigationController?.pushViewController(PrivateRuleViewController(), animated: true)
    }
}
// MARK: - UITextFieldDelegate
extension LoginViewController_1: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
// MARK: - StorePickerDelegate本身(調用done的動作，點下去要做下收的動畫)
extension LoginViewController_1: StorePickerDelegate {
    func didTapDone(_ picker: StorePicker) {
        picker.snp.remakeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.top.equalTo(view.snp.bottom)
        }

        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            picker.removeFromSuperview()
        }
    }
}
// MARK: - UIPickerViewDelegate/DataSource(呈現pickerView內容物-store_name)
extension LoginViewController_1: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return storeIDs?.count ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return storeIDs?[row].storeName ?? ""
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let storeName = storeIDs?[row].storeName ?? ""
        storeIDButton.setTitle(storeName, for: .normal)

        let storeID = storeIDs?[row].storeID ?? ""
        self.storeID = storeID
    }
}
