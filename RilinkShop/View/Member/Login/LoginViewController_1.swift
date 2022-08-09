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

    let tool = Tool()
    var delegate: LoginViewController_1_Delegate?
    var storeIDs: [StoreIDInfo]?
    var storeIDInfo: StoreIDInfo?
//    {
//        didSet {
//            let storeMode = storeIDInfo != nil
//            textFieldView.isHidden = !storeMode
//            loginButton.isHidden = !storeMode
//            signupButton.isHidden = !storeMode
//            privateButton.isHidden = !storeMode
//        }
//    }
    let storePicker = StorePicker()
    let toolBar = UIToolbar()
    var storeID: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarController?.tabBar.isHidden = true
        storeIDButton.isHidden = true

        hideKeyBoard()
        getStoreID()
        tool.makeRoundedCornersButton(button: storeIDButton)
        storeIDButton.backgroundColor = Theme.customOrange
        tool.makeRoundedCornersButton(button: loginButton)
        loginButton.backgroundColor = Theme.customOrange
        tool.makeRoundedCornersButton(button: signupButton)
        signupButton.backgroundColor = Theme.customOrange

        accountTextField.delegate = self
        passwordTextField.delegate = self

        storePicker.toolBarDelegate = self
        storePicker.delegate = self
        storePicker.selectRow(0, inComponent: 0, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        accountTextField.text = ""
        passwordTextField.text = ""
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
    // MARK: - Keyboard
    func hideKeyBoard() {
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(cancelFocus))
        tapGes.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGes)
    }
    @objc func cancelFocus() {
        self.view.endEditing(true)
    }
    // MARK: - StoreID
    func getStoreID() {
        let storeAcc = "99999" // 後端強制數值
        let storePwd = "99999" // 後端強制數值
        HUD.showLoadingHUD(inView: self.view, text: "取得店家資訊中")
        UserService.shared.getStoreIDList(storeAcc: storeAcc, storePwd: storePwd) { success, response in
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
//            storeIDButton.setTitle("店家ID", for: .normal)
        } else {
            storeIDButton.isHidden = false
            signupButton.isHidden = true
        }
    }
    // MARK: - Button to call pickerView
    @IBAction func showStoreID(_ sender: UIButton) {
//        storePicker.toolBarDelegate = self
//        storePicker.delegate = self

        view.addSubview(storePicker)

        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped(_:)))
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

        self.view.layoutIfNeeded()
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
         1. 檢查是否用店長或一般使用者登入
         2. 檢查欄位輸入格式有無錯誤(基礎檢查)
         3. 與後端檢查使否有對應
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

        Global.ACCOUNT = account
        Global.ACCOUNT_PASSWORD = password
        MyKeyChain.setAccount(account)
        MyKeyChain.setPassword(password)
        UserService.shared.id = account
        UserService.shared.pwd = password

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

//            let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", "^[A-Za-z0-9]{6,12}$")
//            guard passwordPredicate.evaluate(with: password) else {
//                let alert = UIAlertController.simpleOKAlert(title: "密碼格式錯誤", message: "請輸入6-12碼英數字混合", buttonTitle: "確認", action: nil)
//                present(alert, animated: true, completion: nil)
//                return
//            }

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
        self.navigationController?.pushViewController(PrivateRuleViewController(), animated: true)
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
        print(#function)
        print(storeID)
    }
}
