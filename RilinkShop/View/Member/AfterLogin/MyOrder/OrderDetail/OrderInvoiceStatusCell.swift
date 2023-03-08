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
    
    let outerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let invoiceTypeText = RSTitleLabel(textAlignment: .left, fontSize: 16, weight: .regular)
    let invoicePhoneText = RSTitleLabel(textAlignment: .left, fontSize: 16, weight: .regular)
    let uniformNoText = RSTitleLabel(textAlignment: .left, fontSize: 16, weight: .regular)
    let companyTitleText = RSTitleLabel(textAlignment: .left, fontSize: 16, weight: .regular)
    //發票號碼
    let invoiceStatusText = RSTitleLabel(textAlignment: .left, fontSize: 16, weight: .regular)
    let invoiceDateText = RSTitleLabel(textAlignment: .left, fontSize: 16, weight: .regular)
    let randomNoText = RSTitleLabel(textAlignment: .left, fontSize: 16, weight: .regular)
    
    let invoiceTypeLabel = RSTitleLabel(textAlignment: .right, fontSize: 16, weight: .regular)
    let invoicePhoneLabel = RSTitleLabel(textAlignment: .right, fontSize: 16, weight: .regular)
    let uniformNoLabel = RSTitleLabel(textAlignment: .right, fontSize: 16, weight: .regular)
    let companyTitleLabel = RSTitleLabel(textAlignment: .right, fontSize: 16, weight: .regular)
    //發票號碼
    let invoiceStatusLabel = RSTitleLabel(textAlignment: .right, fontSize: 16, weight: .regular)
    let invoiceDateLabel = RSTitleLabel(textAlignment: .right, fontSize: 16, weight: .regular)
    let randomNoLabel = RSTitleLabel(textAlignment: .right, fontSize: 16, weight: .regular)
    
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
        contentView.addSubview(outerView)
        outerView.addSubviews(textStackView, labelStackView)
        
        let textAltogether = [invoiceTypeText, invoicePhoneText, uniformNoText, companyTitleText, invoiceStatusText, invoiceDateText, randomNoText]
        let labelAltogether = [invoiceTypeLabel, invoicePhoneLabel, uniformNoLabel, companyTitleLabel, invoiceStatusLabel, invoiceDateLabel, randomNoLabel]
        
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
        
        invoiceTypeText.text    = "發票類型："
        invoicePhoneText.text   = "手機載具："
        uniformNoText.text      = "統一編號："
        companyTitleText.text   = "發票抬頭："
        invoiceStatusText.text  = "發票狀態："
        invoiceDateText.text    = "開立時間："
        randomNoText.text       = "隨機碼："
    }
    
    func set(with model: OrderInfo) {
        invoiceTypeLabel.text   = model.invoiceTypeText
        invoicePhoneLabel.text  = model.invoicephone ?? " "
        uniformNoLabel.text     = model.uniformno ?? " "
        companyTitleLabel.text  = model.companytitle ?? " "
        invoiceStatusLabel.text = model.invoiceStatusText
        invoiceDateLabel.text   = model.invoicedate ?? " "
        randomNoLabel.text      = model.randomno ?? " "
    }
}
