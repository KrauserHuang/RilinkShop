//
//  ProductInfoCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/11.
//

import UIKit

class ProductInfoCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!

    static let reuseIdentifier = "ProductInfoCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with model: List) {
        productImageView.setImage(imageURL: SHOP_ROOT_URL + model.productPicture)
        nameLabel.text = model.productName
        priceLabel.text = "NT$\(model.productPrice)"
        qtyLabel.text = "X\(model.orderQty)"
        totalLabel.text = "小計：$\(model.totalAmount)"
    }

//    func configure(with model: Product) {
//        productImageView.setImage(imageURL: SHOP_ROOT_URL + model.product_picture)
//        nameLabel.text = model.product_name
//        priceLabel.text = "NT$\(model.product_price)"
//        qtyLabel.text = "X\(model.order_qty)"
//        totalLabel.text = "小計：$\(model.total_amount)"
//    }
//
//    func configure(with model: ProductList) {
//        productImageView.setImage(imageURL: TEST_ROOT_URL + model.productPicture!)
//        nameLabel.text = model.productName
//        priceLabel.text = "NT$\(model.productPrice)"
//        qtyLabel.text = "X\(model.orderQty)"
//        totalLabel.text = "小計：$\(model.totalAmount)"
//    }
//
//    func configure(with model: PackageList) {
//        productImageView.setImage(imageURL: TEST_ROOT_URL + model.productPicture!)
//        nameLabel.text = model.productName
//        priceLabel.text = "NT$\(model.productPrice)"
//        qtyLabel.text = "X\(model.orderQty)"
//        totalLabel.text = "小計：$\(model.totalAmount)"
//    }

}
