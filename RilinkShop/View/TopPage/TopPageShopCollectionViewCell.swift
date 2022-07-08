//
//  TopPageShopCollectionViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/26.
//

import UIKit

class TopPageShopCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "TopPageShopCollectionViewCell"

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with model: Package) {
        let imageURLString = SHOP_ROOT_URL + model.productPicture
        imageView.setImage(imageURL: imageURLString)
    }
    
//    func configure(with model: Item) {
//        switch model {
//        case .product(let product):
//            // there will be no product here
//            break
//        case .package(let package):
//            let imageURLString = SHOP_ROOT_URL + package.productPicture
//            imageView.setImage(imageURL: imageURLString)
//        }
//    }
}
