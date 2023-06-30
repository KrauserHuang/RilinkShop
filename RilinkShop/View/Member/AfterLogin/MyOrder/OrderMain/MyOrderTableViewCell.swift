//
//  MyOrderTableViewCell.swift
//  Rilink
//
//  Created by 王璽權 on 2022/1/11.
//

import UIKit

protocol MyOrderTableViewCellDelegate: AnyObject {
    func payImmediate(_ cell: MyOrderTableViewCell)
    func didTapDetailButton(_ cell: MyOrderTableViewCell)
}

class MyOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var orderNo: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var orderAmount: UILabel!
    @IBOutlet weak var payStatusLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var payButton: UIButton!
    @IBAction func detailAction(_ sender: UIButton) {
        delegate?.didTapDetailButton(self)
    }
    @IBAction func payImmediateAction(_ sender: UIButton) {
        delegate?.payImmediate(self)
    }
    
    weak var delegate: MyOrderTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        detailButton.isHidden = false
        payButton.isHidden = false
        payButton.isEnabled = true
    }
    
    private func configure() {
        detailButton.layer.cornerRadius         = detailButton.frame.height / 2
        detailButton.layer.borderColor          = UIColor.primaryOrange.cgColor
        detailButton.layer.borderWidth          = 3
        detailButton.backgroundColor            = .white
        detailButton.tintColor                  = UIColor.primaryOrange
        
        payButton.layer.cornerRadius   = payButton.frame.height / 2
        payButton.layer.borderColor    = UIColor.primaryOrange.cgColor
        payButton.layer.borderWidth    = 3
        payButton.backgroundColor      = .white
        payButton.tintColor            = UIColor.primaryOrange
        
        outerView.addShadow(cornerRadius: 10,
                            shadowColor: .systemGray,
                            shadowOffset: CGSize(width: 2, height: 2),
                            shadowOpacity: 0.8,
                            shadowRadius: 5)
    }

    func set(with model: Order) {
        orderNo.text        = "訂單編號：\(model.orderNo)"
        orderDate.text      = "訂單日期：\(model.orderDate)"
        orderAmount.text    = "訂單金額：\(model.orderAmount)"
        payStatusLabel.text = "付款狀態：\(model.payStatusText)"
        if model.payStatus == "1" {
            payButton.isHidden = true
        } else {
            if model.orderStatus == "2" {
                payButton.isEnabled = false
                payButton.layer.borderColor = UIColor.systemGray3.cgColor
                payButton.setTitle("逾期取消", for: .normal)
            } else {
                payButton.isHidden = false

            }
        }
    }
}
