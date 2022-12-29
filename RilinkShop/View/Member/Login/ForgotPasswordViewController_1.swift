//
//  ForgotPasswordViewController_1.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/18.
//

import UIKit

protocol ForgotPasswordViewController_1_Delegate: AnyObject {
    func finishViewWith(tempAccount: String)
}

class ForgotPasswordViewController_1: UIViewController {

    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!

    weak var delegate: ForgotPasswordViewController_1_Delegate?
    var edittingTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureButton()
        configureKeyboard()
    }
    
    private func configureButton() {
        submitButton.layer.cornerRadius = submitButton.frame.height / 2
        submitButton.backgroundColor    = .primaryOrange
    }
    // MARK: - Keyboard
    private func configureKeyboard() {
        phoneTextField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func submitButtonPressed(_ sender: UIButton) {
        guard let account = phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }

        guard account != "" else {
            Alert.showMessage(title: "", msg: "請先輸入10碼手機號碼", vc: self) {
                self.phoneTextField.becomeFirstResponder()
            }
            return
        }

        guard account.count == 10 else {
            Alert.showMessage(title: "", msg: "輸入格式錯誤,請輸入10碼手機號碼", vc: self) {
                self.phoneTextField.becomeFirstResponder()
            }
            return
        }

        let accountType = "0"
        let action = "1" // 0:註冊重送  1:忘記密碼

        HUD.showLoadingHUD(inView: self.view, text: "處理中")
        UserService.shared.reSendCode(account: account, accountType: accountType, action: action) { (success, response) in

            DispatchQueue.global(qos: .userInitiated).async {
                URLCache.shared.removeAllCachedResponses()

                let returnNum = response as? Int ?? 0
                DispatchQueue.main.sync {

                    HUD.hideLoadingHUD(inView: self.view)

                    guard success else {
                        let errmsg = response as! String
                        Alert.showMessage(title: "", msg: errmsg, vc: self) {
                            self.phoneTextField.becomeFirstResponder()
                        }
                        return
                    }

                    self.dismiss(animated: true) {
                        print(#function)
                        print("account:\(account)")
                        self.delegate?.finishViewWith(tempAccount: account)
                    }
                }
            }
        }
    }
}

extension ForgotPasswordViewController_1: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.edittingTextField = textField
            return true
    }
}
