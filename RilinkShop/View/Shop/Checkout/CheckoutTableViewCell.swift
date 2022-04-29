//
//  CheckoutTableViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/25.
//

import UIKit

class CheckoutTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "CheckoutTableViewCell"
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numebrLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        contentView.frame = contentView.frame.inset(by: margins)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure() {
        productImageView.image = UIImage(named: "nft")
        nameLabel.text = "阿姆斯特朗旋風噴射阿姆斯特朗砲"
        numebrLabel.text = "x2"
        totalCostLabel.text = "$1000"
    }
    
}
