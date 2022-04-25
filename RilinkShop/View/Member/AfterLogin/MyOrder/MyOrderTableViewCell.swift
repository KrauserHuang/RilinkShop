//
//  MyOrderTableViewCell.swift
//  Rilink
//
//  Created by 王璽權 on 2022/1/11.
//

import UIKit

class MyOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var orderNo: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var orderMoney: UILabel!
    @IBOutlet weak var orderState: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    @IBAction func detailAction(_ sender: UIButton) {
        closure?()
    }
    
    var closure: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
