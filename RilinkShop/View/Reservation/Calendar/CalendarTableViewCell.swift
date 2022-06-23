//
//  CalendarTableViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/6/17.
//

import UIKit

protocol CalendarTableViewCellDelegate: AnyObject {
    func didMakeAppointment(_ cell: CalendarTableViewCell)
}

class CalendarTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var appointmentButton: UIButton!
    
    weak var delegate: CalendarTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        appointmentButton.layer.cornerRadius = appointmentButton.frame.height / 2
        appointmentButton.backgroundColor = .systemTeal
        appointmentButton.tintColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure() {
        timeLabel.text = "15:00"
    }
    @IBAction func appointmentButtonTapped(_ sender: UIButton) {
        delegate?.didMakeAppointment(self)
    }
    
}
