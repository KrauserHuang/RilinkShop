//
//  ForgotPasswordViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/7.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var numberTF: UITextField!
    @IBOutlet weak var vertifyTF: UITextField!
    @IBOutlet weak var getVertify: UIButton!
    @IBAction func getVertifyAction(_ sender: UIButton) {
        getVertify.backgroundColor      = .white
        getVertify.layer.borderWidth    = 2
        getVertify.layer.borderColor    = UIColor.primaryOrange.cgColor
        getVertify.tintColor            = .primaryOrange
    }
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordTF2: UITextField!
    @IBOutlet weak var visibleBtn: UIButton!
    @IBAction func visibleAction(_ sender: UIButton) {
        if passwordTF.isSecureTextEntry {
            visibleBtn.setImage(Images.eye, for: .normal)
            passwordTF.isSecureTextEntry = false
        } else {
            visibleBtn.setImage(Images.eyeSlash, for: .normal)
            passwordTF.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var visibleBtn2: UIButton!
    @IBAction func visibleAction2(_ sender: UIButton) {
        if passwordTF2.isSecureTextEntry {
            visibleBtn2.setImage(Images.eye, for: .normal)
            passwordTF2.isSecureTextEntry = false
        } else {
            visibleBtn2.setImage(Images.eyeSlash, for: .normal)
            passwordTF2.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var agreeButton: UIButton!
    @IBAction func agreeAction(_ sender: UIButton) {
        sender.setImage(SFSymbol.circle, for: .normal)
        sender.setImage(Images.agree, for: .selected)
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
        
        configureButton()
        hidekeyboard()
    }
    
    private func configureButton() {
        getVertify.layer.cornerRadius   = getVertify.frame.height / 2
        getVertify.backgroundColor      = .primaryOrange
        sendButton.layer.cornerRadius   = sendButton.frame.height / 2
        sendButton.backgroundColor      = .primaryOrange
        sendButton.tintColor            = .white
    }
    
    private func hidekeyboard() {
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(cancelFocus))
        tapGes.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGes)
    }
    @objc func cancelFocus() {
        view.endEditing(true)
    }
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
