//
//  PackageDetailCostCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/7.
//

import UIKit

class PackageDetailCostCell: UITableViewCell {

    @IBOutlet weak var costLabel: UILabel!
    
    static let reuseIdentifier = "PackageDetailCostCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func configure(with model: Product) {
//        costLabel.text = model.product_price
//    }
    
    func configure(with model: Package) {
        costLabel.text = model.productPrice
    }
}
