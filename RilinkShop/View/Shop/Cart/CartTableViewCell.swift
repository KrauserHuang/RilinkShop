//
//  CartTableViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/25.
//

import UIKit

protocol CartTableViewCellDelegate: AnyObject {
    func removeItem(_ cell: CartTableViewCell)
}

class CartTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "CartTableViewCell"
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    
    weak var delegate: CartTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.borderColor = UIColor.systemGray.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 10
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        contentView.frame = contentView.frame.inset(by: margins)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure() {
        productImageView.image = UIImage(named: "nft")
        nameLabel.text = "商品名稱：阿姆斯特朗旋風噴射阿姆斯特朗砲"
        costLabel.text = "售價：1000"
        numberLabel.text = "X 1"
        totalCostLabel.text = "小記：$29,980"
    }
    @IBAction func removeItemButtonTapped(_ sender: UIButton) {
        delegate?.removeItem(self)
    }
    
}
