//
//  QATableViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/9/22.
//

import UIKit

class QATableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentLabel.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with model: QA) {
        contentLabel.text = model.content
    }

}
