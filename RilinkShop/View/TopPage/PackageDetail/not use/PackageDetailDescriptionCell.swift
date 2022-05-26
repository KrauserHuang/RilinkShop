//
//  PackageDetailDescriptionCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/7.
//

import UIKit

class PackageDetailDescriptionCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    
    static let reuseIdentifier = "PackageDetailDescriptionCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with model: Product) {
        descriptionLabel.text = model.product_description
    }

}
