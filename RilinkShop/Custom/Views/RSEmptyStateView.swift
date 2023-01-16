//
//  RSEmptyStateView.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2023/1/16.
//

import UIKit

class RSEmptyStateView: UIView {
    
    private let messageLabel: UILabel = {
        let label                       = UILabel()
        label.textAlignment             = .center
        label.font                      = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor                 = .lightGray
        label.numberOfLines             = 0
        label.minimumScaleFactor        = 0.7
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(message: String) {
        self.init(frame: .zero)
        messageLabel.text = message
    }
    
    private func configure() {
        backgroundColor = .white
        addSubviews(iconImageView, messageLabel)
        setupMessageLabel()
        setupIconImageView()
    }
    
    private func setupMessageLabel() {
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            messageLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    private func setupIconImageView() {
        iconImageView.image = Images.dataSearching
        
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 80),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor)
        ])
    }

}
