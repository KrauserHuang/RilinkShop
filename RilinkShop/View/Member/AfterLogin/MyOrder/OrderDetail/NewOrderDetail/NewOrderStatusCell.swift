//
//  NewOrderStatusCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2023/2/28.
//

import UIKit

class NewOrderStatusCell: UITableViewCell {
    
    /*
     訂單編號
     訂單日期
     訂單金額
     訂單狀態
     付款狀態
     */
    
    private let outerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let orderNoText = RSTitleLabel(textAlignment: .left, fontSize: 16, weight: .regular)
    private let orderDateText = RSTitleLabel(textAlignment: .left, fontSize: 16, weight: .regular)
    private let orderAmountText = RSTitleLabel(textAlignment: .left, fontSize: 16, weight: .regular)
    private let payStatusText = RSTitleLabel(textAlignment: .left, fontSize: 16, weight: .regular)
    private let orderStatusText = RSTitleLabel(textAlignment: .left, fontSize: 16, weight: .regular)
    
    private let orderNoLabel = RSTitleLabel(textAlignment: .right, fontSize: 16, weight: .regular)
    private let orderDateLabel = RSTitleLabel(textAlignment: .right, fontSize: 16, weight: .regular)
    private let orderAmountLabel = RSTitleLabel(textAlignment: .right, fontSize: 16, weight: .regular)
    private let payStatusLabel = RSTitleLabel(textAlignment: .right, fontSize: 16, weight: .regular)
    private let orderStatusLabel = RSTitleLabel(textAlignment: .right, fontSize: 16, weight: .regular)
    
    private let textStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 8
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let labelStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
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
        outerView.addSubviews(textStackView, labelStackView)
        
        let textAltogether = [orderNoText, orderDateText, orderAmountText, payStatusText, orderStatusText]
        let labelAltogether = [orderNoLabel, orderDateLabel, orderAmountLabel, payStatusLabel, orderStatusLabel]
        
        textAltogether.forEach { textStackView.addArrangedSubview($0) }
        labelAltogether.forEach { labelStackView.addArrangedSubview($0) }
        
        outerView.addShadow(cornerRadius: 10,
                            shadowColor: .systemGray,
                            shadowOffset: CGSize(width: 2, height: 2),
                            shadowOpacity: 0.8,
                            shadowRadius: 5)
        
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            outerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            outerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            outerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            outerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            
            textStackView.topAnchor.constraint(equalTo: outerView.topAnchor, constant: padding),
            textStackView.leadingAnchor.constraint(equalTo: outerView.leadingAnchor, constant: padding),
            textStackView.bottomAnchor.constraint(equalTo: outerView.bottomAnchor, constant: -padding),
            
            labelStackView.topAnchor.constraint(equalTo: outerView.topAnchor, constant: padding),
            labelStackView.leadingAnchor.constraint(equalTo: textStackView.trailingAnchor, constant: padding),
            labelStackView.bottomAnchor.constraint(equalTo: outerView.bottomAnchor, constant: -padding),
            labelStackView.trailingAnchor.constraint(equalTo: outerView.trailingAnchor, constant: -padding)
        ])
        
        orderNoText.text        = "訂單編號："
        orderDateText.text      = "訂單日期："
        orderAmountText.text    = "訂單金額："
        payStatusText.text      = "訂單狀態："
        orderStatusText.text    = "付款狀態："
    }
    
    func configure(with model: OrderInfo) {
        orderNoLabel.text       = model.orderNo
        orderDateLabel.text     = model.orderDate
        orderAmountLabel.text   = model.orderAmount     // 顯示應付 -> 再改回商品合計
        payStatusLabel.text     = model.payStatusText   // 付款狀態
        orderStatusLabel.text   = model.orderStatusText // 訂單狀態
    }
}
