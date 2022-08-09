//
//  ShopTypeCollectionViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/27.
//

import UIKit

class ShopTypeCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "ShopTypeCollectionViewCell"

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var typeLabel: UILabel!

    var isItemSelected: Bool = false {
        didSet {
            typeLabel.textColor = isItemSelected ? .systemGray6 : UIColor(hex: "#4F846C")
            outerView.backgroundColor = isItemSelected ? UIColor(hex: "4F846C") : .systemGray6
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        isItemSelected = false
        outerView.layer.cornerRadius = 5
        outerView.backgroundColor = UIColor(hex: "4F846C")
        typeLabel.textColor = .systemGray6
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        isItemSelected = false
    }

    func configure(with cellModel: CategoryCellModel) {
        typeLabel.text = cellModel.category.productTypeName
    }

}
