//
//  UsableTableViewCell.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/10.
//

import UIKit

class UsableTableViewCell: UITableViewCell {

    @IBOutlet weak var ticketImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var buyDay: UILabel!
    @IBOutlet weak var orderNo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
