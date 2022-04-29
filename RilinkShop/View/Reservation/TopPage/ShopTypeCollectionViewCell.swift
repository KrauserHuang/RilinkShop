//
//  ShopTypeCollectionViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/27.
//

import UIKit

class ShopTypeCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ShopTypeCollectionViewCell"

    @IBOutlet weak var outerView: UIView! {
        didSet {
            outerView.backgroundColor = .clear
//            outerView.layer.borderWidth = 1
//            outerView.layer.borderColor = UIColor(hex: "#54a0ff")?.cgColor
//            outerView.layer.cornerRadius = 2
        }
    }
    @IBOutlet weak var typeLabel: UILabel! {
        didSet {
            typeLabel.textColor = UIColor(hex: "#54a0ff")
        }
    }
    
    var isItemSelected: Bool = false {
        didSet {
//            outerView.layer.borderWidth = isItemSelected ? 1 : 0
            typeLabel.textColor = isItemSelected ? UIColor(hex: "#54a0ff") : .systemGray
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        isItemSelected = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isItemSelected = false
    }
    
    func configure(with cellModel: CategoryCellModel) {
        typeLabel.text = cellModel.category.productTypeName
    }

}
