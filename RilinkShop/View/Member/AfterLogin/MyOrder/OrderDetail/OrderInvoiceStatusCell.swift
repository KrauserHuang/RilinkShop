//
//  OrderInvoiceStatusCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2023/3/1.
//

import UIKit

class OrderInvoiceStatusCell: UITableViewCell {
    
    /*
     發票類型
     手機載具
     統一編號
     發票抬頭
     發票號碼 ??
     發票狀態
     開立時間
     隨機碼
     */
    
    let invoiceTypeText = RSTitleLabel(textAlignment: .left, fontSize: 18, weight: .medium)
    let invoicePhoneText = RSTitleLabel(textAlignment: .left, fontSize: 18, weight: .medium)
    let uniformNoText = RSTitleLabel(textAlignment: .left, fontSize: 18, weight: .medium)
    let companyTitleText = RSTitleLabel(textAlignment: .left, fontSize: 18, weight: .medium)
    //發票號碼
    let invoiceStatusText = RSTitleLabel(textAlignment: .left, fontSize: 18, weight: .medium)
    let invoiceDateText = RSTitleLabel(textAlignment: .left, fontSize: 18, weight: .medium)
    let randomNoText = RSTitleLabel(textAlignment: .left, fontSize: 18, weight: .medium)
    
    let invoiceTypeLabel = RSTitleLabel(textAlignment: .left, fontSize: 18, weight: .medium)
    let invoicePhoneLabel = RSTitleLabel(textAlignment: .left, fontSize: 18, weight: .medium)
    let uniformNoLabel = RSTitleLabel(textAlignment: .left, fontSize: 18, weight: .medium)
    let companyTitleLabel = RSTitleLabel(textAlignment: .left, fontSize: 18, weight: .medium)
    //發票號碼
    let invoiceStatusLabel = RSTitleLabel(textAlignment: .left, fontSize: 18, weight: .medium)
    let invoiceDateLabel = RSTitleLabel(textAlignment: .left, fontSize: 18, weight: .medium)
    let randomNoLabel = RSTitleLabel(textAlignment: .left, fontSize: 18, weight: .medium)
    
    let textStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 8
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let labelStackView: UIStackView = {
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
        contentView.addSubviews(textStackView, labelStackView)
        
        let textAltogether = [invoiceTypeText, invoicePhoneText, uniformNoText, companyTitleText, invoiceStatusText, invoiceDateText, randomNoText]
        let labelAltogether = [invoiceTypeLabel, invoicePhoneLabel, uniformNoLabel, companyTitleLabel, invoiceStatusLabel, invoiceDateLabel, randomNoLabel]
        
        textAltogether.forEach { textStackView.addArrangedSubview($0) }
        labelAltogether.forEach { labelStackView.addArrangedSubview($0) }
        
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            textStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            textStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            textStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            
            labelStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            labelStackView.leadingAnchor.constraint(equalTo: textStackView.trailingAnchor, constant: padding),
            labelStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])
        
        invoiceTypeText.text    = "發票類型："
        invoicePhoneText.text   = "手機載具："
        uniformNoText.text      = "統一編號："
        companyTitleText.text   = "發票抬頭："
        invoiceStatusText.text  = "發票狀態："
        invoiceDateText.text    = "開立時間："
        randomNoText.text       = "隨機碼："
    }
    
    func set(with model: OrderInfo) {
        invoiceTypeLabel.text   = model.orderNo
        invoicePhoneLabel.text  = model.orderNo
        uniformNoLabel.text     = model.orderNo
        companyTitleLabel.text  = model.orderNo
        invoiceStatusLabel.text = model.orderNo
        invoiceDateLabel.text   = model.orderNo
        randomNoLabel.text      = model.orderNo
    }
}
