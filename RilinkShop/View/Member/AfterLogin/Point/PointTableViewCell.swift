//
//  PointTableViewCell.swift
//  Rilink
//
//  Created by 王璽權 on 2022/1/11.
//

import UIKit

class PointTableViewCell: UITableViewCell {

    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
