//
//  HostelTypeCollectionViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/9.
//

import UIKit

class HostelTypeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    
    static let reuseIdentifier = "HostelTypeCollectionViewCell"

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
    
    var isItemSelected: Bool = false {
        didSet {
            typeLabel.textColor = isItemSelected ? .systemGray6 : UIColor(hex: "#4F846C")
            outerView.backgroundColor = isItemSelected ? UIColor(hex: "4F846C") : .systemGray6
        }
    }
    
    func configure(with cellModel: StoreTypeCellModel) {
        typeLabel.text = cellModel.type.name
    }

}
