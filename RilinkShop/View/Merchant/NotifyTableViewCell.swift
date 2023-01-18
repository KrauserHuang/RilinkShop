//
//  NotifyTableViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2023/1/9.
//

import UIKit

class NotifyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    private func configure() {
        backView.layer.cornerRadius = 10
        backView.layer.shadowOffset = CGSize(width: 1, height: 1)
        backView.layer.shadowOpacity = 0.5
    }
    
    func set(with viewModel: AdminHistory) {
        messageLabel.text = viewModel.message
        timeLabel.text = viewModel.updatetime
        titleLabel.text = viewModel.title
//        switch viewModel.type {
//        case 1:
//            titleLabel.text = "系統群發"
//        case 2:
//            titleLabel.text = "系統單發"
//        case 3:
//            titleLabel.text = "租車預約通知"
//        case 4:
//            titleLabel.text = "附近店家"
//        case 5:
//            titleLabel.text = "還車通知"
//        case 6:
//            titleLabel.text = "機車退款通知"
//        case 7:
//            titleLabel.text = "取消預約通知"
//        default:
//            titleLabel.text = "未知訊息"
//        }
    }
}
