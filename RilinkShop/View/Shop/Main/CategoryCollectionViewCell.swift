//
//  CategoryCollectionViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/25.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CategoryCollectionViewCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var indicatorLine: UIView!
    
    var isItemSelected: Bool = false {
        didSet {
            indicatorLine.alpha = isItemSelected ? 1 : 0
            nameLabel.textColor = isItemSelected ? UIColor(hex: "#54a0ff") : .systemGray
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
        nameLabel.text = cellModel.category.productTypeName
    }
}
