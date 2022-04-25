//
//  ForgotPasswordViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/7.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    let tool = Tool()
    
    @IBOutlet weak var numberTF: UITextField!
    @IBOutlet weak var vertifyTF: UITextField!
    @IBOutlet weak var getVertify: UIButton!
    @IBAction func getVertifyAction(_ sender: UIButton) {
        getVertify.backgroundColor = .white
        getVertify.layer.borderWidth = 2
        getVertify.layer.borderColor = tool.customOrange.cgColor
        getVertify.tintColor = tool.customOrange
    }
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordTF2: UITextField!
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
    @IBOutlet weak var visibleBtn2: UIButton!
    @IBAction func visibleAction2(_ sender: UIButton) {
        if passwordTF2.isSecureTextEntry {
            visibleBtn2.setImage(UIImage(named: "eye"), for: .normal)
            passwordTF2.isSecureTextEntry = false
        }else{
            visibleBtn2.setImage(UIImage(named: "eyeSlash"), for: .normal)
            
            passwordTF2.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var agreeButton: UIButton!
    @IBAction func agreeAction(_ sender: UIButton) {
        sender.setImage(UIImage(systemName: "circle"), for: .normal)
        sender.setImage(UIImage(named: "agree"), for: .selected)
        sender.isSelected.toggle()
    }
    @IBAction func privateAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(PrivateRuleViewController(), animated: true)
    }
    @IBOutlet weak var sendButton: UIButton!
    @IBAction func sendAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hidekeyboard()
        tool.makeRoundedCornersButton(button: getVertify)
        getVertify.backgroundColor = tool.customOrange
        tool.makeRoundedCornersButton(button: sendButton)
        sendButton.backgroundColor = tool.customOrange
        sendButton.tintColor = .white
        
    }
    
    @objc func cancelFocus(){
        self.view.endEditing(true)
    }
    
    func hidekeyboard(){
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(cancelFocus))
        tapGes.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGes)
        
    }

}

extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
