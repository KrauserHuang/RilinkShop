//
//  MessageTableViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/10/21.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func configure() {
        outerView.addShadow(cornerRadius: 10,
                            shadowColor: .systemGray,
                            shadowOffset: CGSize(width: 2, height: 2),
                            shadowOpacity: 0.8,
                            shadowRadius: 5)
        titleLabel.textColor = .messageOrange
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        dateLabel.textColor  = .messageGray
        descriptionLabel.numberOfLines = 0
    }
    
    func configure(with model: History) {
        titleLabel.text = model.title
        descriptionLabel.text = model.message
        dateLabel.text = model.push_datetime
    }
}
