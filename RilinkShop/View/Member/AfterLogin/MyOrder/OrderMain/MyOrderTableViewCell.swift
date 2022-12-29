//
//  MyOrderTableViewCell.swift
//  Rilink
//
//  Created by 王璽權 on 2022/1/11.
//

import UIKit

protocol MyOrderTableViewCellDelegate: AnyObject {
    func payImmediate(_ cell: MyOrderTableViewCell)
}

class MyOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var orderNo: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var orderMoney: UILabel!
    @IBOutlet weak var payStatusLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var payImmediateButton: UIButton!
    @IBAction func detailAction(_ sender: UIButton) {
        closure?()
    }
    @IBAction func payImmediateAction(_ sender: UIButton) {
        delegate?.payImmediate(self)
    }

    var closure: (() -> Void)?
    weak var delegate: MyOrderTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func configure() {
        detailButton.layer.cornerRadius         = detailButton.frame.height / 2
        detailButton.layer.borderColor          = UIColor.primaryOrange.cgColor
        detailButton.layer.borderWidth          = 3
        detailButton.backgroundColor            = .white
        detailButton.tintColor                  = UIColor.primaryOrange
        
        payImmediateButton.layer.cornerRadius   = payImmediateButton.frame.height / 2
        payImmediateButton.layer.borderColor    = UIColor.primaryOrange.cgColor
        payImmediateButton.layer.borderWidth    = 3
        payImmediateButton.backgroundColor      = .white
        payImmediateButton.tintColor            = UIColor.primaryOrange
    }

    func set(with model: Order) {
        orderNo.text = "訂單編號：\(model.orderNo)"
        orderDate.text = "訂單日期：\(model.orderDate)"
        orderMoney.text = "訂單金額：\(model.orderAmount)"
        // 付款狀態
        switch model.payStatus {
        case "0":
            payStatusLabel.text = "付款狀態：未付款" // 未付款
            payImmediateButton.isHidden = false
        case "-1":
            payStatusLabel.text = "付款狀態：付款中"
        case "1":
            if model.assigntype == "0" {
                payStatusLabel.text = "付款狀態：付款完成"
            } else {
                payStatusLabel.text = "付款狀態：店家派發"
            }
            payImmediateButton.alpha = 0
            payImmediateButton.isUserInteractionEnabled = false
        default:
            payStatusLabel.text = "付款狀態：處理中"
            payImmediateButton.isHidden = false
        }
    }
}
