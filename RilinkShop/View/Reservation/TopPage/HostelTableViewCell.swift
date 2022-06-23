//
//  HostelTableViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/9.
//

import UIKit

class HostelTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var hostelImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    static let reuseIdentifier = "HostelTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with model: Store) {
        hostelImageView.setImage(imageURL: SHOP_ROOT_URL + model.storePicture)
        nameLabel.text = model.storeName
        addressLabel.text = model.storeAddress
    }
    
}
