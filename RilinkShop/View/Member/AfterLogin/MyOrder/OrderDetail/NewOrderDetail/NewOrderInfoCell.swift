//
//  NewOrderInfoCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2023/2/28.
//

import UIKit
import SnapKit

class NewOrderInfoCell: UITableViewCell {
    
    private let outerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let productImageView = RSProductImageView(frame: .zero)
    private let nameLabel   = RSTitleLabel(textAlignment: .left, fontSize: 16, weight: .regular)
    private let priceLabel  = RSTitleLabel(textAlignment: .left, fontSize: 16, weight: .regular)
    private let qtyLabel    = RSTitleLabel(textAlignment: .left, fontSize: 16, weight: .regular)
    private let totalLabel  = RSTitleLabel(textAlignment: .right, fontSize: 16, weight: .regular)
    
    private let horizontalStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 8
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let verticalStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.spacing = 8
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(outerView)
        outerView.addSubviews(productImageView, verticalStackView)
        
        horizontalStackView.addArrangedSubview(qtyLabel)
        horizontalStackView.addArrangedSubview(totalLabel)
        
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(priceLabel)
        verticalStackView.addArrangedSubview(horizontalStackView)
        
        outerView.addShadow(cornerRadius: 10,
                            shadowColor: .systemGray,
                            shadowOffset: CGSize(width: 2, height: 2),
                            shadowOpacity: 0.8,
                            shadowRadius: 5)
        
        let padding: CGFloat = 10
        
//        NSLayoutConstraint.activate([
//            outerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
//            outerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
//            outerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
//            outerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
//
//            productImageView.topAnchor.constraint(equalTo: outerView.topAnchor, constant: padding),
//            productImageView.leadingAnchor.constraint(equalTo: outerView.leadingAnchor, constant: padding),
//            productImageView.bottomAnchor.constraint(equalTo: outerView.bottomAnchor, constant: -padding),
//            productImageView.heightAnchor.constraint(equalToConstant: 100),
//            productImageView.widthAnchor.constraint(equalTo: productImageView.heightAnchor, multiplier: 1),
//
//            verticalStackView.topAnchor.constraint(equalTo: outerView.topAnchor, constant: padding),
//            verticalStackView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: padding),
//            verticalStackView.trailingAnchor.constraint(equalTo: outerView.trailingAnchor, constant: -padding),
//            verticalStackView.bottomAnchor.constraint(equalTo: outerView.bottomAnchor, constant: -padding),
//        ])
        
        outerView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(contentView).inset(padding)
        }

        productImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalTo(outerView).inset(padding)
            make.size.equalTo(CGSize(width: 100, height: 100))
        }

        verticalStackView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalTo(outerView).inset(padding)
            make.leading.equalTo(productImageView.snp.trailing).offset(padding)
        }
    }
    
    func configure(with model: List) {
        productImageView.setImage(with: SHOP_ROOT_URL + model.productPicture)
        nameLabel.text  = model.productName
        priceLabel.text = "NT$\(model.productPrice)"
        qtyLabel.text   = "X\(model.orderQty)"
        totalLabel.text = "小計：$\(model.totalAmount)"
    }
}
