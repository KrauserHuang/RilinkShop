//
//  StoreDetailMainTextCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/7/13.
//

import UIKit

class StoreDetailMainTextCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    static let reuseIdentifier = "StoreDetailMainTextCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with model: Store) {
        nameLabel.text = model.storeName
        locationLabel.text = model.storeAddress
        phoneLabel.text = "電話：\(model.storePhone)"
    }
}
