//
//  StoreAdminLoginViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/7/6.
//

import UIKit
import SnapKit

protocol StoreAdminLoginViewControllerDelegate: AnyObject {
    func finishLoginView(_ viewController: StoreAdminLoginViewController, action: finishLoginViewWith)
    func showStoreID(_ viewController: StoreAdminLoginViewController)
}

class StoreAdminLoginViewController: UIViewController {

    @IBOutlet weak var storeTextField: UITextField!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var visibleButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var privateButton: UIButton!
    
    var delegate: StoreAdminLoginViewControllerDelegate?
    var storeIDs: [StoreIDInfo]?
    var storeIDInfo: StoreIDInfo?
    let storePicker = StorePicker()
    let toolBar = UIToolbar()
    var storeID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextField()
        configureButton()
        configureStorePicker()
        hideKeyBoard()
        getStoreID()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        storeTextField.text     = ""
        accountTextField.text   = ""
        passwordTextField.text  = ""
    }

    private func configureTextField() {
        storeTextField.delegate     = self
        accountTextField.delegate   = self
        passwordTextField.delegate  = self
    }
    
    private func configureButton() {
        loginButton.layer.cornerRadius  = loginButton.frame.height / 2
        loginButton.backgroundColor     = .primaryOrange
    }
    
    private func configureStorePicker() {
        storePicker.toolBarDelegate = self
        storePicker.delegate        = self
        storePicker.selectRow(0, inComponent: 0, animated: false)
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
            HUD.hideLoadingHUD(inView: self.view)
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
    @IBAction func storeSelection(_ sender: UIButton) {
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
    @IBAction func loginAction(_ sender: UIButton) {
        /*
         0. 檢查欄位有無空白
         1. 檢查是否用店長或一般使用者登入
         2. 檢查欄位輸入格式有無錯誤(基礎檢查)
         3. 與後端檢查使否有對應
         */
        guard let account = accountTextField.text,
              let password = passwordTextField.text,
              let store = storeTextField.text else { return }
        guard account != "",
              password != "",
              store != "" else {
                  let alertController = UIAlertController(title: "", message: "欄位不可空白", preferredStyle: .alert)
                  let okAction = UIAlertAction(title: "確認", style: .default, handler: nil)
                  alertController.addAction(okAction)
                  present(alertController, animated: true, completion: nil)
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
                    
//                    LocalStorageManager.shared.setData(account, key: .userIdKey)
//                    LocalStorageManager.shared.setData(password, key: .userPasswordKey)
                    MyKeyChain.setBossAccount(Global.ACCOUNT)
                    MyKeyChain.setBossPassword(Global.ACCOUNT_PASSWORD)

//                        self.delegate?.finishLoginView(self, action: .BossLogIn)
//                    let vc = StoreAppViewController()
                    let vc = UIStoryboard(name: "Merchant", bundle: nil).instantiateViewController(withIdentifier: "MerchantNavigationController") as! MerchantNavigationController
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    // MARK: - Forgot
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        delegate?.finishLoginView(self, action: .Forget)
    }
    // MARK: - 條款頁
    @IBAction func privateAction(_ sender: UIButton) {
        let vc = PrivateRuleViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension StoreAdminLoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
// MARK: - StorePickerDelegate本身(調用done的動作，點下去要做下收的動畫)
extension StoreAdminLoginViewController: StorePickerDelegate {
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
extension StoreAdminLoginViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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

        let storeID = storeIDs?[row].storeID ?? ""
        self.storeID = storeID
        print(#function)
        print(storeID)
    }
}
