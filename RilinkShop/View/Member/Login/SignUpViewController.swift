//
//  SignUpViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/7.
//

import UIKit

class SignUpViewController: UIViewController {

    let tool = Tool()
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var birthdayTF: UITextField!
    @IBOutlet weak var numberTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var invitationCodeTF: UITextField!
    @IBOutlet weak var agreeBtn: UIButton!
    @IBAction func agreeAction(_ sender: UIButton) {
        sender.setImage(UIImage(systemName: "circle"), for: .normal)
        sender.setImage(UIImage(named: "agree"), for: .selected)
        sender.isSelected.toggle()
    }
    @IBAction func privateAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(PrivateRuleViewController(), animated: true)
    }
    @IBOutlet weak var signUpButton: UIButton!
    @IBAction func signUpAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var visibleButton: UIButton!
    @IBAction func visibleAction(_ sender: UIButton) {
        if passwordTF.isSecureTextEntry {
            visibleButton.setImage(UIImage(named: "eye"), for: .normal)
            passwordTF.isSecureTextEntry = false
        }else{
            visibleButton.setImage(UIImage(named: "eyeSlash"), for: .normal)
            
            passwordTF.isSecureTextEntry = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboard()
        
        tool.makeRoundedCornersButton(button: signUpButton)
        signUpButton.backgroundColor = tool.customOrange
        
    }
    
    @objc func cancelFocus(){
        self.view.endEditing(true)
    }
    
    func hideKeyboard(){
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(cancelFocus))
        tapGes.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGes)
    }

}

extension SignUpViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
