//
//  PackageDetailStepperCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/7.
//

import UIKit

class PackageDetailStepperCell: UITableViewCell {

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var itemNumberLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    
    static let reuseIdentifier = "PackageDetailStepperCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
