//
//  ReservationTableViewCell.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/6.
//

import UIKit

class ReservationTableViewCell: UITableViewCell {

    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var openingTimeLabel: UILabel!
    @IBOutlet weak var reservationButton: UIButton!
    @IBAction func reservationAction(_ sender: UIButton) {
        closure?()
    }

    var closure: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
