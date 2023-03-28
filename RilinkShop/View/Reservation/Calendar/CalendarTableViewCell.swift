//
//  CalendarTableViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/6/17.
//

import UIKit

enum AppointmentState {
    case available
    case full
    case within24hours
}

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
        let quota = Int(model.quota) ?? 0
        let used = Int(model.used) ?? 0
        let left = quota - used
        if left == 0 {
            appointmentButton.setTitle("已額滿", for: .normal)
            appointmentButton.isUserInteractionEnabled = false
            appointmentButton.backgroundColor = .systemGray4
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
//        dateFormatter.locale = Locale(identifier: "zh_Hant_TW")
//        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        dateFormatter.locale = Locale.ReferenceType.system
        dateFormatter.timeZone = TimeZone.ReferenceType.system
        let openDuration = dateFormatter.date(from: "\(model.bookingDate) \(model.duration)")!
        let openDurationFormat = Date.dateFromGMT(openDuration)
        let timeSinceNow = Date().addingTimeInterval(24*60*60)
        let timeSinceNowFormat = Date.dateFromGMT(timeSinceNow)
        let isWithin24hours = within24hours(openDuration: openDurationFormat, with: timeSinceNowFormat)
        if isWithin24hours {
            appointmentButton.setTitle("不可預約", for: .normal)
            appointmentButton.isUserInteractionEnabled = false
            appointmentButton.backgroundColor = .systemGray4
        } else {
            appointmentButton.setTitle("可選擇", for: .normal)
            appointmentButton.isUserInteractionEnabled = true
            appointmentButton.backgroundColor = .systemTeal
        }
    }
    
    private func within24hours(openDuration: Date, with currentTimePlus24hours: Date) -> Bool {
        let result: ComparisonResult = openDuration.compare(currentTimePlus24hours)
        switch result {
        case .orderedAscending: //openDuration小於currentTimePlus24hours -> 不可預約
            return true
        case .orderedDescending: //openDuration大於currentTimePlus24hours -> 可預約
            return false
        default:
            return false
        }
    }

    @IBAction func appointmentButtonTapped(_ sender: UIButton) {
        delegate?.didMakeAppointment(self)
    }
}
