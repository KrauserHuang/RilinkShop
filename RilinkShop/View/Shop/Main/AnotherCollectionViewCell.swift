//
//  AnotherCollectionViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/3.
//

import UIKit

class AnotherCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "AnotherCollectionViewCell"
    
    @IBOutlet private weak var outerView: UIView!
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var indicatorLine: UIView!
    
    var isItemSelected: Bool = false {
        didSet {
//            indicatorLine.alpha = isItemSelected ? 1 : 0
//            label.textColor = isItemSelected ? UIColor(hex: "#4F846C") : .systemGray
            label.textColor = isItemSelected ? .systemGray6 : UIColor(hex: "#4F846C")
            outerView.backgroundColor = isItemSelected ? UIColor(hex: "4F846C") : .systemGray6
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        isItemSelected = false
        outerView.layer.cornerRadius = 5
        outerView.backgroundColor = UIColor(hex: "4F846C")
        label.textColor = .systemGray6
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isItemSelected = false
    }
    
//    override func sizeThatFits(_ size: CGSize) -> CGSize {
//        return CGSize(width: label.sizeThatFits(size).width + 32, height: 32)
//    }
    
    func configure(with cellModel: CategoryCellModel) {
        label.text = cellModel.category.productTypeName
    }
}
