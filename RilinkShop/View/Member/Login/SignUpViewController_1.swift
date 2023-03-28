//
//  SignUpViewController_1.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/17.
//

import UIKit

protocol SignUpViewController_1_Delegate: AnyObject {
    func finishSignup1WithSubmitCode(_ viewController: SignUpViewController_1, resultType: Int)  // 1:繼續驗證  2:前往登入頁
}

class SignUpViewController_1: UIViewController {

    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!

    weak var delegate: SignUpViewController_1_Delegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureButton()
    }

    private func configureButton() {
        submitButton.layer.cornerRadius = submitButton.bounds.size.height / 2
        submitButton.backgroundColor    = .primaryOrange
    }
    // MARK: - Agree Button切換
    @IBAction func agreeAction(_ sender: UIButton) {
        sender.setImage(SFSymbol.checkmark, for: .normal)
        sender.setImage(SFSymbol.checkmarkFill, for: .selected)
        sender.isSelected.toggle()
    }
    // MARK: - 顯示條款頁
    @IBAction func toRulePageAction(_ sender: UIButton) {
        let vc = PrivateRuleViewController()
        present(vc, animated: true, completion: nil)
    }
    // MARK: - 提交手機號碼系統回傳驗證碼給使用者
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        guard let account = accountTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              account.count == 10 else {
            let alertController = UIAlertController(title: "", message: "請先輸入10碼手機號碼", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.accountTextField.becomeFirstResponder()
            }
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }

        guard agreeButton.isSelected else {
            let alertController = UIAlertController(title: "", message: "請先勾選同意《會員條款》以及《隱私權政策》", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }

        HUD.showLoadingHUD(inView: self.view, text: "處理中")
        UserService.shared.signUp(account: account) { (success, response) in
            DispatchQueue.global(qos: .userInitiated).async {
                URLCache.shared.removeAllCachedResponses()

                let returnNum = response as? Int ?? 0

                DispatchQueue.main.sync {
                    HUD.hideLoadingHUD(inView: self.view)

                    guard success else {
                        let errmsg = response as! String
                        Alert.showMessage(title: "", msg: errmsg, vc: self) {
                            self.accountTextField.becomeFirstResponder()
                        }
                        return
                    }

                    /*
                    101 新增成功
                    102 已有帳號, 已重送驗證碼
                    103 已填寫完成, 請直接登入
                    */
                    
//                    LocalStorageManager.shared.setData(account, key: .userIdKey)
                    Global.ACCOUNT = account
                    MyKeyChain.setAccount(account)

                    if returnNum == 101 {

                        let message = "帳號新增成功\n驗證碼已發送"
                        Alert.showMessage(title: "", msg: message, vc: self) {
                            self.dismiss(animated: true) {
                                self.delegate?.finishSignup1WithSubmitCode(self, resultType: 1)
                            }
                        }

                    } else if returnNum == 102 {
                        let message = "帳號存在\n驗證碼已重新發送"
                        Alert.showMessage(title: "", msg: message, vc: self) {
                            self.dismiss(animated: true) {
                                self.delegate?.finishSignup1WithSubmitCode(self, resultType: 1)
                            }
                        }

                    } else if returnNum == 103 {
                        let message = "帳號已存在\n請前往登入"
                        Alert.showMessage(title: "", msg: message, vc: self) {
                            self.dismiss(animated: true) {
//                                self.delegate?.finishSignup1WithSubmitCode(self, resultType: 2)
                            }
                        }
                    }
                }
            }
        }
    }
}
