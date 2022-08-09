//
//  Success.swift
//  Rilink
//
//  Created by 王璽權 on 2022/1/13.
//

import Foundation
import UIKit
import SwiftUI

class AlternateAlert: UIViewController {
// popupWidth: self.view.frame.width - 32, popupHeight: self.view.frame.height * 0.5

//    let successAlert = SuccessAlert()

    let alternateImageView: UIImageView = {
        let theImageView = UIImageView()
            theImageView.image = UIImage(named: "alternate")
            theImageView.translatesAutoresizingMaskIntoConstraints = false // You need to call this property so the image is added to your view
        return theImageView
    }()

    let datelabel: UILabel = {
        let label = UILabel()
        label.text = "2021/04/10 星期六 14:00  候補第 1 位"
        label.textColor = UIColor(red: 10/255, green: 109/255, blue: 160/255, alpha: 1)
        label.font = label.font.withSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let remindLabel: UILabel = {
        let label = UILabel()
        label.text = "若有空位釋出時，將會以電話個別通知，再請留意來電，謝謝。"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.lightGray
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let confirmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 10/255, green: 109/255, blue: 160/255, alpha: 1)
        button.setTitle("確認", for: .normal)
        button.layer.cornerRadius = 22.5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let addMoreReservationButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = UIColor.white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 10/255, green: 109/255, blue: 160/255, alpha: 1).cgColor
        button.setTitleColor(UIColor(red: 10/255, green: 109/255, blue: 160/255, alpha: 1), for: .normal)
        button.setTitle("添加更多預約", for: .normal)
        button.layer.cornerRadius = 22.5
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    let cancelButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("取消候補", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        let objectArray: [ UIView] = [ alternateImageView, datelabel, remindLabel, confirmButton, addMoreReservationButton, cancelButton]

        for obj in objectArray {
            self.view.addSubview(obj)
        }

        setImageView()
        setLabel()
        setButton()

    }
    func setImageView() {
        alternateImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        alternateImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        alternateImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        alternateImageView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
    }

    func setLabel() {
//        datelabel
        datelabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        datelabel.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
//        remindLabel
        remindLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        remindLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        remindLabel.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
    }

    func setButton() {
//        confirmButton
        confirmButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmButton.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -150).isActive = true
//        addMoreReservationButton
        addMoreReservationButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        addMoreReservationButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        addMoreReservationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addMoreReservationButton.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -90).isActive = true
//        cancelButton
        cancelButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
    }

}
