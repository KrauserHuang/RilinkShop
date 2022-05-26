//
//  ListTableViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/25.
//

import UIKit
import Kingfisher

class ListTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "ListTableViewCell"

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
        itemImageView.image = UIImage(named: "nft")
        nameLabel.text = "阿姆斯特朗旋風噴射阿姆斯特朗砲"
        costLabel.text = "1000"
    }
    
    func configure(with model: Product) {
//        nameLabel.text = model.productName
//        costLabel.text = model.productPrice
        nameLabel.text = model.product_name
        costLabel.text = "$\(model.product_price)"
        
        if let imageURL = URL(string: TEST_ROOT_URL + model.product_picture) {
            itemImageView.isHidden = false
            itemImageView.kf.setImage(with: imageURL)
        } else {
            itemImageView.isHidden = true
        }
    }
    
    func configure(with model: Item) {
        switch model {
        case .product(let product):
            nameLabel.text = product.product_name
            costLabel.text = "$\(product.product_price)"
            
            if let imageURL = URL(string: TEST_ROOT_URL + product.product_picture) {
                itemImageView.isHidden = false
                itemImageView.kf.setImage(with: imageURL)
            } else {
                itemImageView.isHidden = true
            }
        case .package(let package):
            nameLabel.text = package.productName
            costLabel.text = "$\(package.productPrice)"
            
            if let imageURL = URL(string: TEST_ROOT_URL + package.productPicture) {
                itemImageView.isHidden = false
                itemImageView.kf.setImage(with: imageURL)
            } else {
                itemImageView.isHidden = true
            }
        }
    }
}
