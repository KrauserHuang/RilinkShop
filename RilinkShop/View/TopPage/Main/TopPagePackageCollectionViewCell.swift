//
//  TopPagePackageCollectionViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/7/14.
//

import UIKit

class TopPagePackageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    static let reuseIdentifier = "TopPagePackageCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        imageView.layer.cornerRadius = 15
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = 15
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor.black.cgColor
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOpacity = 0.4
        bgView.layer.shadowOffset = CGSize(width: 2, height: -2)
    }
    
    func configure(with model: Package) {
        let imageURLString = SHOP_ROOT_URL + model.productPicture
        imageView.setImage(imageURL: imageURLString)
        
        nameLabel.text = model.productName
        costLabel.text = "NT$ \(model.productPrice)"
    }
}
