//
//  StoreIDSelectTableViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/21.
//

import UIKit

class StoreIDSelectTableViewCell: UITableViewCell {

    @IBOutlet weak var storeNameLabel: UILabel!

    static let reuseIdentifier = "StoreIDSelectTableViewCell"
    var storeIDInfo = StoreIDInfo() {
        didSet {
            storeNameLabel.text = storeIDInfo.storeName
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
