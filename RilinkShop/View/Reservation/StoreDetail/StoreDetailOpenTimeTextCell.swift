//
//  StoreDetailOpenTimeTextCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/7/13.
//

import UIKit

class StoreDetailOpenTimeTextCell: UITableViewCell {

    @IBOutlet weak var openTimeLabel: UILabel!
    
    static let reuseIdentifier = "StoreDetailOpenTimeTextCell"
    
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
        openTimeLabel.text = model.storeOpentime
    }
}
