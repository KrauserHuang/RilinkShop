//
//  LoginViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/6.
//

import UIKit

class LoginViewController: UIViewController {

    let tool = Tool()
    
    @IBOutlet weak var accountTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var visibleBtn: UIButton!
    @IBAction func visibleAction(_ sender: UIButton) {
        if passwordTF.isSecureTextEntry {
            visibleBtn.setImage(UIImage(named: "eye"), for: .normal)
            passwordTF.isSecureTextEntry = false
        }else{
            visibleBtn.setImage(UIImage(named: "eyeSlash"), for: .normal)
            
            passwordTF.isSecureTextEntry = true
        }
    }
    @IBAction func forgotPwAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(ForgotPasswordViewController(), animated: true)
    }
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func loginAction(_ sender: UIButton) {
    }
    @IBOutlet weak var signUpButton: UIButton!
    @IBAction func signUpAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    @IBAction func privateAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(PrivateRuleViewController(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyBoard()
        tool.makeRoundedCornersButton(button: loginButton)
        loginButton.backgroundColor = tool.customOrange
        tool.makeRoundedCornersButton(button: signUpButton)
        signUpButton.backgroundColor = tool.customOrange
        
    }

    func hideKeyBoard(){
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(cancelFocus))
        tapGes.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGes)
    }
    
    @objc func cancelFocus(){
        self.view.endEditing(true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
