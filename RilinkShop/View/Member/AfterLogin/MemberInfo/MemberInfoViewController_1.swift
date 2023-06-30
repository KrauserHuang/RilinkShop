//
//  MemberInfoViewController_1.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/25.
//

import UIKit
import SnapKit

protocol MemberInfoViewController_1_Delegate: AnyObject {
    func memberInfoDidUpdate(_ viewController: MemberInfoViewController_1)
}

class MemberInfoViewController_1: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var storeTypeLabel: UILabel!
    @IBOutlet weak var storeListLabel: UILabel!
    @IBOutlet weak var saveEditButton: UIButton!

    weak var delegate: MemberInfoViewController_1_Delegate?
    var edittingTextField: UITextField?
    var user: User?
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
    var account = MyKeyChain.getAccount() ?? ""
    var password = MyKeyChain.getPassword() ?? ""
    var storeTypes: [StoreTypeList] = []
    var stores: [Store] = []
    var realStores: [RealStore] = []
    
    var selectedStoreTypeIndex = 0
    var selectedStoreIndex = 0
    
    let storeTypePickerView = UIPickerView()
    let storePickerView = UIPickerView()
    let toolBar = UIToolbar()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureButton()
        configureTextField()
        configureKeyboard()
        getUserDate()
        getStore()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureViewController()
    }
    
    private func configureViewController() {
        nameTextField.text      = user?.name ?? ""
        birthdayTextField.text  = user?.birthday ?? ""
        phoneLabel.text         = user?.tel ?? ""
        emailTextField.text     = user?.email ?? ""
        storeTypeLabel.text     = user?.referrerStoreType ?? "無推薦店家類別"
        storeListLabel.text     = user?.referrerStoreName ?? "無推薦店家"
        
        if user?.sex == "1" {
            femaleButton.isSelected = true
        } else {
            maleButton.isSelected = true
        }
    }
    
    private func configureButton() {
        saveEditButton.setTitle("儲存變更", for: .normal)
        saveEditButton.setTitleColor(.black, for: .normal)
        saveEditButton.backgroundColor      = .white
        saveEditButton.layer.borderWidth    = 1
        saveEditButton.layer.borderColor    = UIColor.primaryOrange.cgColor
        saveEditButton.layer.cornerRadius   = saveEditButton.frame.height / 2
        saveEditButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureTextField() {
        nameTextField.delegate      = self
        birthdayTextField.delegate  = self
        emailTextField.delegate     = self
        
        nameTextField.returnKeyType  = .next
        emailTextField.returnKeyType = .next
    }

    private func getUserDate() {
        let accountType = "0"
        sleep(1)
        
        UserService.shared.getPersonalData(account: account, pw: password, accountType: accountType) { success, response in
            DispatchQueue.global(qos: .userInitiated).async {
                URLCache.shared.removeAllCachedResponses()
                DispatchQueue.main.async {
                    
                    guard success else {
                        return
                    }

                    Global.personalData = response as? User

                    if let user = response as? User {
                        self.user                   = user
                        self.nameTextField.text     = user.name
                        self.birthdayTextField.text = user.birthday
                        self.phoneLabel.text        = user.account
                        self.emailTextField.text    = user.email
                    }
                }
            }
        }
    }
    private func getStore() {
        UserService.shared.getStoreTypeList { success, response in
            guard success else {
                return
            }
            
            self.storeTypes = response as! [StoreTypeList]
            self.storeTypes.append(StoreTypeList(storetype_id: "", storetype_name: "無"))
            
            self.storeTypes.forEach { storeType in
                StoreService.shared.getStoreList(storeType: storeType.storetype_id) { storeList in
                    self.stores = storeList as [Store]
                    if storeType.storetype_id == "" {
                        let realStore = RealStore(storeType: storeType, stores: [Store(storeID: "", storeName: "無")])
                        self.realStores.append(realStore)
                    } else {
                        let realStore = RealStore(storeType: storeType, stores: self.stores)
                        self.realStores.append(realStore)
                    }
                }
            }
        }
    }
    // MARK: - Keyboard
    private func configureKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let contentInsets                   = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset             = contentInsets
        scrollView.scrollIndicatorInsets    = contentInsets
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        let contentInsets                   = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.contentInset             = contentInsets
        scrollView.scrollIndicatorInsets    = contentInsets
    }
    // MARK: - Close the controller
    @IBAction func xmarkTapped(_ sender: UIButton) {
        dismiss(animated: true)
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

    // MARK: - GenderSwitch
    @IBAction func genderSwitch(_ sender: UIButton) {
        if sender == maleButton {
            femaleButton.isSelected = false
        } else {
            maleButton.isSelected = false
        }
        sender.isSelected = true
    }

    @IBAction func saveEditButtonTapped(_ sender: UIButton) {
        let accountType = "0"
        guard let tel = phoneLabel.text else {
            return
        }

        guard let name = nameTextField.text,
              name != "" else {
                  let message = "請輸入姓名"
                  Alert.showMessage(title: "", msg: message, vc: self) {
                      self.nameTextField.becomeFirstResponder()
                  }
                  return
              }

        guard let email = emailTextField.text,
              email != "" else {
                  let message = "請輸入電子郵件"
                  Alert.showMessage(title: "", msg: message, vc: self) {
                      self.emailTextField.becomeFirstResponder()
                  }
                  return
              }

        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        let predicate  = NSPredicate(format: "SELF MATCHES %@", emailRegEx)

        guard predicate.evaluate(with: email) else {
            let message = "輸入電子郵件格式錯誤"
            Alert.showMessage(title: "", msg: message, vc: self) {
                self.emailTextField.becomeFirstResponder()
            }
            return
        }

        guard let birthday = birthdayTextField.text,
              birthday != "" else {
                  let message = "請輸入生日"
                  Alert.showMessage(title: "", msg: message, vc: self) {
                      self.birthdayTextField.becomeFirstResponder()
                  }
                  return
              }

        var sex = ""
        if maleButton.isSelected {
            sex = "0"
        } else if femaleButton.isSelected {
            sex = "1"
        }

        let city = ""
        let region = ""
        let address = ""
        var referrerShopStoreId = realStores[selectedStoreTypeIndex].stores[selectedStoreIndex].storeID
        var referrerShopStoreType = realStores[selectedStoreTypeIndex].storeType.storetype_id
        
        if referrerShopStoreId == "",
           referrerShopStoreType == "" {
            referrerShopStoreId = "-1"
            referrerShopStoreType = "-1"
        }

        HUD.showLoadingHUD(inView: self.view, text: "")
        UserService.shared.modifyPersonalData(account: Global.ACCOUNT,
                                              pw: Global.ACCOUNT_PASSWORD,
                                              accountType: accountType,
                                              name: name,
                                              tel: tel,
                                              birthday: birthday,
                                              email: email,
                                              sex: sex,
                                              city: city,
                                              region: region,
                                              address: address,
                                              referrerPhone: "",
                                              referrerShopStoreId: referrerShopStoreId,
                                              referrerShopStoreType: referrerShopStoreType) { success, response in
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
                        self.dismiss(animated: true, completion: nil)
                        self.delegate?.memberInfoDidUpdate(self)
                    }
                }
            }
        }
    }

}
// MARK: - UITextFieldDelegate
extension MemberInfoViewController_1: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        edittingTextField = textField
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
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
