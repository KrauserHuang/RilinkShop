//
//  CouponDetailViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2023/3/6.
//

import UIKit

class CouponDetailViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        return scrollView
    }()
    
    let imageView = RSProductImageView(frame: .zero)
    let titleLabel = RSTitleLabel(textAlignment: .center, fontSize: 20)
    let dueDateLabel = RSTitleLabel(textAlignment: .center, fontSize: 20)
    let descriptionLabel = RSTitleLabel(textAlignment: .center, fontSize: 18, weight: .regular)
    let backButton = RSButton(isTinted: false, color: .primaryOrange, title: "返回")
    let useButton = RSButton(isTinted: true, color: .primaryOrange, title: "使用優惠券")
    private lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.spacing = 10
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureUIElements()
    }
    
    private func configureUIElements() {
        view.addSubviews(imageView, titleLabel, dueDateLabel, descriptionLabel, stackView)
        stackView.addArrangedSubview(backButton)
        stackView.addArrangedSubview(useButton)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            titleLabel.heightAnchor.constraint(equalToConstant: 60),
            
            dueDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            dueDateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dueDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            dueDateLabel.heightAnchor.constraint(equalToConstant: 60),
            
            descriptionLabel.topAnchor.constraint(equalTo: dueDateLabel.bottomAnchor, constant: 10),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            descriptionLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -10),
            
            stackView.heightAnchor.constraint(equalToConstant: 40),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
        ])
        
        titleLabel.numberOfLines = 0
        dueDateLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0
        
        titleLabel.text = "歡慶Rilink滿周年,不限門市維修保養95折"
        dueDateLabel.text = "【新會員註冊好禮】\n有效期限:2023-07-25"
        descriptionLabel.text =
        """
票卷使用說明票卷使用說明票卷使用說明
票卷使用說明票卷使用說明票卷使用說明
票卷使用說明票卷使用說明票卷使用說明
票卷使用說明票卷使用說明票卷使用說明
票卷使用說明票卷使用說明票卷使用說明
票卷使用說明票卷使用說明票卷使用說明
票卷使用說明票卷使用說明票卷使用說明
票卷使用說明票卷使用說明票卷使用說明
"""
        
        backButton.addTarget(self, action: #selector(backButtonDidTapped(_:)), for: .touchUpInside)
        useButton.addTarget(self, action: #selector(useButtonDidTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func backButtonDidTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func useButtonDidTapped(_ sender: UIButton) {
        print("There")
        presentGFAlertOnMainThread(title: "你好", message: "今天天氣不錯", buttonTitle: "是吧！")
    }
}
