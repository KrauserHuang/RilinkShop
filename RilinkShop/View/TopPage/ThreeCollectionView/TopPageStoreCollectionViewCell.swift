//
//  TopPageStoreCollectionViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/7/14.
//

import UIKit

class TopPageStoreCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = 10
//        contentView.backgroundColor = .systemBlue
    }

    func configure(with model: Store) {
        let imageURLString = SHOP_ROOT_URL + model.storePicture
        imageView.setImage(with: imageURLString)
    }

    func configure(with model: Banner) {
        let imageURLString = SHOP_ROOT_URL + model.bannerPicture
        imageView.setImage(with: imageURLString)
    }
}
