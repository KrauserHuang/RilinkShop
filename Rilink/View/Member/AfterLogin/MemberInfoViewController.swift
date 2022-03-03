//
//  MemberInfoViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/7.
//

import UIKit

class MemberInfoViewController: UIViewController {

    let tool = Tool()
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var idTF: UITextField!
    @IBOutlet weak var boyButton: UIButton!
    @IBAction func boyAction(_ sender: UIButton) {
        boyButton.backgroundColor = tool.customOrange
        boyButton.tintColor = .white
        girlButton.backgroundColor = .white
        girlButton.layer.borderColor = tool.customOrange.cgColor
        girlButton.layer.borderWidth = 1
        girlButton.tintColor = tool.customOrange
    }
    @IBOutlet weak var girlButton: UIButton!
    @IBAction func girlAction(_ sender: UIButton) {
        girlButton.backgroundColor = tool.customOrange
        girlButton.tintColor = .white
        boyButton.backgroundColor = .white
        boyButton.layer.borderColor = tool.customOrange.cgColor
        boyButton.layer.borderWidth = 1
        boyButton.tintColor = tool.customOrange
    }
    @IBOutlet weak var birthdayTF: UITextField!
    @IBOutlet weak var heightTF: UITextField!
    @IBOutlet weak var weightTF: UITextField!
    @IBOutlet weak var numberTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var checkPasswordTF: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboard()
        boyButton.layer.cornerRadius = 4
        boyButton.backgroundColor = tool.customOrange
        boyButton.tintColor = .white
        girlButton.tintColor = tool.customOrange
        girlButton.layer.cornerRadius = 4
        girlButton.backgroundColor = .white
        girlButton.layer.borderWidth = 1
        girlButton.layer.borderColor = tool.customOrange.cgColor
        
        
    }

    @objc func cancelFocus(){
        self.view.endEditing(true)
    }
    
    func hideKeyboard(){
        let tapGes = UIGestureRecognizer(target: self, action: #selector(cancelFocus))
        tapGes.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGes)
    }
    
}

extension MemberInfoViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
