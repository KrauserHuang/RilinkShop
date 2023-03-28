//
//  UsedTableViewCell.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/10.
//

import UIKit

class UsedTableViewCell: UITableViewCell {

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var ticketImageView: UIImageView!
    @IBOutlet weak var ticketNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var orderNoLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        outerView.addShadow(cornerRadius: 10,
                            shadowColor: .systemGray,
                            shadowOffset: CGSize(width: 2, height: 2),
                            shadowOpacity: 0.8,
                            shadowRadius: 5)
        ticketImageView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with model: AnyObject) {
        if let model = model as? QRCode {
            if let modelProductPicture = model.productPicture {
                ticketImageView.setImage(with: SHOP_ROOT_URL + modelProductPicture)
            } else if let modelPackagePicture = model.packagePicture {
                ticketImageView.setImage(with: SHOP_ROOT_URL + modelPackagePicture)
            }
            if let modelProductName = model.productName {
                ticketNameLabel.text = modelProductName
            } else if let modelPackageName = model.packageName {
                ticketNameLabel.text = modelPackageName
            }

            dateLabel.text = "購買日期：\(model.orderDate)"
            orderNoLabel.text = "訂單編號：\(model.orderNo)"
        } else if let model = model as? Coupon {
            ticketImageView.setImage(with: model.couponPicture)
            ticketNameLabel.text = model.couponName
            dateLabel.text = "有效期限：\(model.couponEnddate)"
        }
    }

}
