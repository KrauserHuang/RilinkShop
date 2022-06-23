//
//  UsableTableViewCell.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/10.
//

import UIKit

class UsableTableViewCell: UITableViewCell {

    @IBOutlet weak var ticketImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var buyDay: UILabel!
    @IBOutlet weak var orderNo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with model: UNQRCode) {
        if let modelProductPicture = model.productPicture {
            ticketImage.setImage(imageURL: SHOP_ROOT_URL + modelProductPicture)
        } else if let modelPackagePicture = model.packagePicture {
            ticketImage.setImage(imageURL: SHOP_ROOT_URL + modelPackagePicture)
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
