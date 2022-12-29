//
//  PackageProductDetailTableViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/16.
//

import UIKit

class PackageProductDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var orderQtyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        productImageView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with model: PackageProduct) {
        if let modelProductPicture = model.productPicture {
            productImageView.setImage(with: SHOP_ROOT_URL + modelProductPicture)
        } else {
            print("model.productPicture is nil!")
        }

        if let modelProductName = model.productName {
            productNameLabel.text = modelProductName
        } else {
            print("model.productName is nil!")
        }

        if let modelStoreName = model.storeName {
            storeNameLabel.text = "店家名稱：\(modelStoreName)"
        } else {
            print("model.storeName is nil!")
        }

        if let modelOrderQty = model.orderQty {
            orderQtyLabel.text = "商品數量：\(modelOrderQty)"
        } else {
            print("model.orderQty is nil!")
        }
    }
}
