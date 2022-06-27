//
//  Success.swift
//  Rilink
//
//  Created by 王璽權 on 2022/1/13.
//

import Foundation
import UIKit
import EzPopup

class SuccessAlert: UIViewController{
//popupWidth: self.view.frame.width - 32, popupHeight: self.view.frame.height * 0.5
    
//    let successAlert = SuccessAlert()
    
    let okImageView: UIImageView = {
        let theImageView = UIImageView()
            theImageView.image = UIImage(named: "checked")
            theImageView.translatesAutoresizingMaskIntoConstraints = false //You need to call this property so the image is added to your view
        return theImageView
    }()
    
    let datelabel: UILabel = {
        let label = UILabel()
        label.text = "2021/04/10 星期六 14:00"
        label.textColor = UIColor(red: 10/255, green: 160/255, blue: 110/255, alpha: 1)
        label.font = label.font.withSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let successReservationLabel: UILabel = {
        let label = UILabel()
        label.text = "預約成功"
        label.textColor = UIColor(red: 10/255, green: 160/255, blue: 110/255, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 10/255, green: 160/255, blue: 110/255, alpha: 1)
        button.setTitle("確認", for: .normal)
        button.layer.cornerRadius = 22.5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let addMoreReservationButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = UIColor.white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 10/255, green: 160/255, blue: 110/255, alpha: 1).cgColor
        button.setTitleColor(UIColor(red: 10/255, green: 160/255, blue: 110/255, alpha: 1), for: .normal)
        button.setTitle("添加更多預約", for: .normal)
        button.layer.cornerRadius = 22.5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("取消預約", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
//        let objectArray: [UIView] = [okImageView, datelabel, successReservationLabel, confirmButton, addMoreReservationButton, cancelButton]
        let objectArray: [UIView] = [okImageView, datelabel, successReservationLabel, confirmButton]
        
        for obj in objectArray{
            self.view.addSubview(obj)
        }
        
        setImageView()
        setLabel()
        setButton()
        
        confirmButton.addTarget(self, action: #selector(confirmButtonAction(_:)), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonAction(_:)), for: .touchUpInside)
    }
    @objc func confirmButtonAction(_ sender: UIButton) {
        dismiss(animated: true) {
//            self.navigationController?.popToRootViewController(animated: true)
            if let controllers = self.navigationController?.viewControllers {
                for controller in controllers {
                    switch controller {
                    case is ShopViewController:
                        self.navigationController?.popToViewController(controller, animated: true)
                    case is TopPageViewController:
                        self.navigationController?.popToViewController(controller, animated: true)
                    case is MemberCenterTableViewController:
                        self.navigationController?.popToViewController(controller, animated: true)
                    default:
                        break
                    }
                }
            }
        }
    }
    @objc func cancelButtonAction(_ sender: UIButton){
        let popupVC = PopupViewController(contentController: AlternateAlert(), popupWidth: self.view.frame.width, popupHeight: self.view.frame.height)
        popupVC.cornerRadius = 20
        
        self.present(popupVC, animated: false){
            self.dismiss(animated: false){
                self.present(popupVC, animated: true, completion: nil)
            }
        }
    }
    func setImageView() {
        okImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        okImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        okImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        okImageView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
    }
    
    func setLabel(){
//        datelabel
        datelabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        datelabel.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
//        successReservationLabel
        successReservationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        successReservationLabel.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 180).isActive = true
    }
    
    func setButton(){
//        confirmButton
        confirmButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmButton.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -150).isActive = true
//        addMoreReservationButton
//        addMoreReservationButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
//        addMoreReservationButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
//        addMoreReservationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        addMoreReservationButton.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -90).isActive = true
//        cancelButton
//        cancelButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
//        cancelButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
//        cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        cancelButton.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
    }
    
}
