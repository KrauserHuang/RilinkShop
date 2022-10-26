//
//  TopPageOptionCollectionViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/7/15.
//

import UIKit

class TopPageOptionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var optionLabel: UILabel!

//    static let reuseIdentifier = "TopPageOptionCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        contentView.backgroundColor = .systemPink
    }

    func configure(with option: String) {
        optionLabel.text = option
        imageView.image = UIImage(named: option)
    }
}
