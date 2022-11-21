//
//  OrderStatusCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/11.
//

import UIKit

class OrderStatusCell: UITableViewCell {

    @IBOutlet weak var orderNoLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderAmountLabel: UILabel!
    @IBOutlet weak var orderStatusLabel: UILabel!
    @IBOutlet weak var payStatusLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    func configure(with model: Order) {
    func configure(with model: OrderInfo) {
        orderNoLabel.text = "訂單編號：\(model.orderNo)"
        orderDateLabel.text = "訂單日期：\(model.orderDate)"
        orderAmountLabel.text = "訂單金額：\(model.orderAmount)" // 顯示應付 -> 再改回商品合計
//        orderStatusLabel.text = "訂單狀態：\(model.orderStatus)"
        payStatusLabel.text = "付款狀態：\(model.payStatus)"
        // 訂單狀態
        switch model.orderStatus {
        case "0":
            orderStatusLabel.text = "訂單狀態：處理中"
        case "1":
            orderStatusLabel.text = "訂單狀態：完成" // 完成 -> 已發貨?
        case "2":
            orderStatusLabel.text = "訂單狀態：取消(退款)"
        default:
            orderStatusLabel.text = "訂單狀態：處理中"
        }
        // 付款狀態
        switch model.payStatus {
        case "0":
            payStatusLabel.text = "付款狀態：未付款" // 未付款
        case "-1":
            payStatusLabel.text = "付款狀態：付款中"
        case "1":
            if model.assigntype == "0" {
                payStatusLabel.text = "付款狀態：付款完成"
            } else {
                payStatusLabel.text = "付款狀態：店家派發"
            }
//            payStatusLabel.text = "付款狀態：付款完成"
        default:
            payStatusLabel.text = "付款狀態：處理中"
        }
    }

}
