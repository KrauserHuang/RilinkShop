//
//  NewOrderInfoCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2023/2/28.
//

import UIKit
import SnapKit

class NewOrderInfoCell: UITableViewCell {
    
    let productImageView = RSProductImageView(frame: .zero)
    let nameLabel = RSTitleLabel(textAlignment: .left, fontSize: 18, weight: .medium)
    let priceLabel = RSTitleLabel(textAlignment: .left, fontSize: 18, weight: .medium)
    let qtyLabel = RSTitleLabel(textAlignment: .left, fontSize: 18, weight: .medium)
    let totalLabel = RSTitleLabel(textAlignment: .right, fontSize: 18, weight: .medium)
    
    let horizontalStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()
    
    let verticalStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 8
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
        contentView.addSubviews(productImageView, verticalStackView)
        
        horizontalStackView.addArrangedSubview(qtyLabel)
        horizontalStackView.addArrangedSubview(totalLabel)
        
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(priceLabel)
        verticalStackView.addArrangedSubview(horizontalStackView)
        
        productImageView.snp.makeConstraints { make in
            make.centerYWithinMargins.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalTo(verticalStackView).inset(-10)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.centerY.equalTo(productImageView)
            make.trailing.equalToSuperview().inset(-10)
        }
    }
    
    func set(with model: List) {
        productImageView.setImage(with: SHOP_ROOT_URL + model.productPicture)
        nameLabel.text  = model.productName
        priceLabel.text = "NT$\(model.productPrice)"
        qtyLabel.text   = "X\(model.orderQty)"
        totalLabel.text = "小計：$\(model.totalAmount)"
    }
}
