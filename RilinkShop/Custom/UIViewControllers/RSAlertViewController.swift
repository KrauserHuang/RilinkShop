//
//  RSAlertViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2023/3/6.
//

import UIKit

class RSAlertViewController: UIViewController {
    
    let containerView = RSAlertView()
    let titleLabel = RSTitleLabel(textAlignment: .center, fontSize: 20)
    let messageLabel = RSBodyLabel(textAlignment: .center)
    let okButton = RSButton(isTinted: true, color: .primaryOrange, title: "OK")
    let cancelButton = RSButton(isTinted: false, color: .primaryOrange, title: "取消")
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.spacing = 8
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    
    init(alertTitle: String?, message: String?, buttonTitle: String?) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle     = alertTitle
        self.message        = message
        self.buttonTitle    = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        configureContainerView()
        configureTitleLabel()
        configureMessageLabel()
        configureStackView()
    }
    
    private func configureContainerView() {
        view.addSubview(containerView)
        
        containerView.addSubviews(titleLabel, messageLabel, stackView)
        
        stackView.addArrangedSubview(okButton)
        stackView.addArrangedSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 280)
        ])
    }
    
    private func configureTitleLabel() {
        titleLabel.text = alertTitle ?? "錯誤訊息"
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    private func configureMessageLabel() {
        messageLabel.text = message ?? "無訊息"
        messageLabel.numberOfLines = 4
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            messageLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -12)
        ])
    }
    
    private func configureStackView() {
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        okButton.setTitle(buttonTitle ?? "確認", for: .normal)
        okButton.addTarget(self,
                           action: #selector(dismissAlertVC), for: .touchUpInside)
        cancelButton.addTarget(self,
                               action: #selector(dismissAlertVC), for: .touchUpInside)
    }
    @objc func dismissAlertVC() {
        dismiss(animated: true)
    }
    
    private func configureOKButton() {
        
    }
    
    private func configureCancelButton() {
        
    }
}
