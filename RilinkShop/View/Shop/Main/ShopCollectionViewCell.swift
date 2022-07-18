//
//  ShopCollectionViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/7/13.
//

import UIKit
import Kingfisher

class ShopCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    static let reuseIdentifier = "ShopCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.2
        imageView.layer.shadowOffset = CGSize(width: 2, height: -2)
    }
    
    func configure(with model: Item) {
        switch model {
        case .product(let product):
            nameLabel.text = product.product_name
            costLabel.text = "$\(product.product_price)"
            
            if let imageURL = URL(string: SHOP_ROOT_URL + product.product_picture) {
                imageView.isHidden = false
                imageView.kf.setImage(with: imageURL)
//                imageView.setImage(imageURL: imageURL)
            } else {
                imageView.isHidden = true
            }
        case .package(let package):
            nameLabel.text = package.productName
            costLabel.text = "$\(package.productPrice)"
            
            if let imageURL = URL(string: SHOP_ROOT_URL + package.productPicture) {
                imageView.isHidden = false
                imageView.kf.setImage(with: imageURL)
//                imageView.setImage(imageURL: imageURL)
            } else {
                imageView.isHidden = true
            }
        }
    }
}
