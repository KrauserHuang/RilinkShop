//
//  ProductInfoCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/11.
//

import UIKit

class ProductInfoCell: UITableViewCell {

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        configure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func configure() {
        outerView.addShadow(cornerRadius: 10,
                            shadowColor: .systemGray,
                            shadowOffset: CGSize(width: 2, height: 2),
                            shadowOpacity: 0.8,
                            shadowRadius: 5)
        
        productImageView.contentMode = .scaleAspectFill
        productImageView.layer.cornerRadius = 10
        productImageView.clipsToBounds = true
    }

    func configure(with model: List) {
        productImageView.setImage(with: SHOP_ROOT_URL + model.productPicture)
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
