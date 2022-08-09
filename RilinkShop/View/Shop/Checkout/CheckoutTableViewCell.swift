//
//  CheckoutTableViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/25.
//

import UIKit

class CheckoutTableViewCell: UITableViewCell {

    static let reuseIdentifier = "CheckoutTableViewCell"

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        productImageView.layer.cornerRadius = 10
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        contentView.frame = contentView.frame.inset(by: margins)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure() {
        productImageView.image = UIImage(named: "nft")
        nameLabel.text = "阿姆斯特朗旋風噴射阿姆斯特朗砲"
        numberLabel.text = "x2"
        totalCostLabel.text = "$1000"
    }

    func configure(with model: Product) {
        nameLabel.text = model.product_name
        numberLabel.text = "X \(model.order_qty)"
        totalCostLabel.text = "$\(model.total_amount)"

        let imageURLString = SHOP_ROOT_URL + model.product_picture
        productImageView.setImage(imageURL: imageURLString)
    }

}
