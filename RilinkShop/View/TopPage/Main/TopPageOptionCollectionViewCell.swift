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

    static let reuseIdentifier = "TopPageOptionCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with option: String) {
        optionLabel.text = option
    }
}
