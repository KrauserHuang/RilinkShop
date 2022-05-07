//
//  PackageDetailNameCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/7.
//

import UIKit

class PackageDetailNameCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.numberOfLines = 0
        }
    }
    
    static let reuseIdentifier = "PackageDetailNameCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with model: Product) {
        nameLabel.text = model.product_name
    }

}
