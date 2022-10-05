//
//  RepairReservationTableViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/9/12.
//

import UIKit

protocol RepairReservationTableViewCellDelegate: AnyObject {
    func didTapExpandButton(_ cell: RepairReservationTableViewCell)
    func didTapCancelButton(_ cell: RepairReservationTableViewCell)
}

class RepairReservationTableViewCell: UITableViewCell {

    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var plateNoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var cancelReservationButton: UIButton!

    @IBOutlet weak var detailStackView: UIStackView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var motorNoLabel: UILabel!
    @IBOutlet weak var motorTypeLabel: UILabel!
    @IBOutlet weak var fixTypeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!

    weak var delegate: RepairReservationTableViewCellDelegate?
    var expandToggle: Bool = false {
        didSet {
            expandButton.setImage(UIImage(systemName: expandToggle == true ? "chevron.up" : "chevron.down"), for: .normal)
            detailStackView.isHidden = expandToggle == true ? false : true
        }
    }
    var isCancelled: Bool = false {
        didSet {
            cancelReservationButton.setTitle(isCancelled == true ? "已取消預約" : "取消預約", for: .normal)
            cancelReservationButton.tintColor = isCancelled == true ? .systemGray5 : .primaryOrange
            cancelReservationButton.isUserInteractionEnabled = isCancelled == true ? false : true
        }
    }
    var canBeCancelled: Bool = true {
        didSet {
//            cancelReservationButton.setTitle(canBeCancelled == true ? "已取消預約" : "取消預約", for: .normal)
            cancelReservationButton.tintColor = canBeCancelled == true ? .primaryOrange : .systemGray5
            cancelReservationButton.isUserInteractionEnabled = canBeCancelled == true ? true : false
        }
    }
    var model: FixMotor? {
        didSet {
            setDetailView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        expandToggle = false
//        setDetailView()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        // 每次切換不同車牌記得都要關掉伸展畫面
        expandToggle = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func expandButtonTapped(_ sender: UIButton) {
        delegate?.didTapExpandButton(self)
    }

    @IBAction func cancelReservationButtonTapped(_ sender: UIButton) {
        delegate?.didTapCancelButton(self)
    }
}

extension RepairReservationTableViewCell {

    func setDetailView() {
        if model?.canCancel == "1" { // canCancel == 1(可以被取消-還沒過期)
            canBeCancelled = true
            if model?.cancel == "1" {
                isCancelled = true
            } else {
                isCancelled = false
            }
        } else {
            canBeCancelled = false
        }
    }

    func configure(with model: FixMotor) {
        // 上半部
        plateNoLabel.text     = model.motorNo
        dateLabel.text        = model.bookingDate
        durationLabel.text    = model.duration
        // 下半部
        storeNameLabel.text   = model.storeName
        motorNoLabel.text     = model.motorNo
        motorTypeLabel.text   = model.motorType
        fixTypeLabel.text     = model.fixType
        descriptionLabel.text = model.description
        nameLabel.text        = model.name
        phoneLabel.text       = model.phone
        // 狀態欄位
        if model.canCancel == "1" { // canCancel == 1(可以被取消-還沒過期)
            canBeCancelled = true
            if model.cancel == "1" {
                isCancelled = true
            } else {
                isCancelled = false
            }
        } else {
            canBeCancelled = false
        }
    }
}
