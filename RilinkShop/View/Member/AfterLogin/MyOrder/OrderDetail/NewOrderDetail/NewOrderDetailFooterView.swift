//
//  NewOrderDetailFooterView.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2023/2/28.
//

import UIKit

class NewOrderDetailFooterView: UITableViewHeaderFooterView {
    
    private let orderAmountText = RSTitleLabel(textAlignment: .left, fontSize: 17, weight: .medium)
    private let discountAmountText = RSTitleLabel(textAlignment: .left, fontSize: 17, weight: .medium)
    private let orderPayText = RSTitleLabel(textAlignment: .left, fontSize: 17, weight: .medium)
    
    private let orderAmountLabel = RSTitleLabel(textAlignment: .left, fontSize: 16, weight: .regular)
    private let discountAmountLabel = RSTitleLabel(textAlignment: .left, fontSize: 16, weight: .regular)
    private let orderPayLabel = RSTitleLabel(textAlignment: .left, fontSize: 16, weight: .regular)
    
    private lazy var textStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .leading
        sv.distribution = .fillEqually
        sv.spacing = 4
        sv.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var labelStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .trailing
        sv.distribution = .fillEqually
        sv.spacing = 4
        sv.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(textStackView, labelStackView)
        let texts = [orderAmountText, discountAmountText, orderPayText]
        let labels = [orderAmountLabel, discountAmountLabel, orderPayLabel]
        
        texts.forEach { textStackView.addArrangedSubview($0) }
        labels.forEach { labelStackView.addArrangedSubview($0) }
        
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            textStackView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            textStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            textStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            
            labelStackView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            labelStackView.leadingAnchor.constraint(equalTo: textStackView.trailingAnchor, constant: 10),
            labelStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            labelStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
        ])
        
        orderAmountText.text    = "商品合計"
        discountAmountText.text = "點數折扣"
        orderPayText.text       = "應付金額合計"
    }
    
    func set(with model: Order) {
        orderAmountLabel.text       = "$ \(model.orderAmount)"
        discountAmountLabel.text    = "$ \(model.discountAmount)"
        orderPayLabel.text          = "$ \(model.orderPay)"
    }
}
