//
//  UsedTableViewCell.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/10.
//

import UIKit

class UsedTableViewCell: UITableViewCell {

    @IBOutlet weak var ticketImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var buyDay: UILabel!
    @IBOutlet weak var orderNo: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ticketImage.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with model: QRCode) {
        if let modelProductPicture = model.productPicture {
            ticketImage.setImage(with: SHOP_ROOT_URL + modelProductPicture)
        } else if let modelPackagePicture = model.packagePicture {
            ticketImage.setImage(with: SHOP_ROOT_URL + modelPackagePicture)
        }
        if let modelProductName = model.productName {
            name.text = modelProductName
        } else if let modelPackageName = model.packageName {
            name.text = modelPackageName
        }

        buyDay.text = "購買日期：\(model.orderDate)"
        orderNo.text = "訂單編號：\(model.orderNo)"
    }

}
