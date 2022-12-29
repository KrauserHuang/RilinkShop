//
//  StoreCollectionViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/7/13.
//

import UIKit

class StoreCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!

//    static let reuseIdentifier = "StoreCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView.layer.cornerRadius = 10
    }

    func configure(with model: Store) {
        nameLabel.text      = model.storeName
        locationLabel.text  = "地址：\(model.storeAddress)"
        phoneLabel.text     = "電話：\(model.storePhone)"
        imageView.setImage(with: SHOP_ROOT_URL + model.storePicture)
    }
}
