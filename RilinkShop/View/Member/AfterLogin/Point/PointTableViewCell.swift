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
    @IBOutlet weak var eachPointLabel: UILabel!
    @IBOutlet weak var totalPointLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    func configure(with model: Point) {
        stateLabel.text = model.msg
        dateLabel.text = model.time
        eachPointLabel.text = model.point
    }
}
