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

        appointmentButton.setTitle("可選擇", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with model: FixMotor) {
        timeLabel.text = model.duration
        let quota = Int(model.quota)! ?? 0
        let used = Int(model.used)! ?? 0
        let left = quota - used
        if left == 0 {
            appointmentButton.setTitle("已額滿", for: .normal)
            appointmentButton.isUserInteractionEnabled = false
            appointmentButton.backgroundColor = .systemGray4
        }
    }

    @IBAction func appointmentButtonTapped(_ sender: UIButton) {
        delegate?.didMakeAppointment(self)
    }

}
