//
//  CartTableViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/25.
//

import UIKit

protocol CartTableViewCellDelegate: AnyObject {
    func removeItem(_ cell: CartTableViewCell)
    func didAddQty(_ cell: CartTableViewCell)
    func didSubstractQty(_ cell: CartTableViewCell)
}

class CartTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "CartTableViewCell"
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var stepperOuterView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var substractButton: UIButton!
    @IBOutlet weak var itemNumberLabel: UILabel!
    
    weak var delegate: CartTableViewCellDelegate?
    var itemNumber = 1
    var minValue = 0
    var stepValue = 1
    var stock = Int()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.borderColor = UIColor.systemGray.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 10
        configureView()
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
    
    func configureView() {
        // stepper外圍
        stepperOuterView.backgroundColor = .systemGray6
        stepperOuterView.layer.cornerRadius = stepperOuterView.frame.height / 2
        // 加減
        addButton.tintColor = UIColor(hex: "#4F846C")
        addButton.backgroundColor = UIColor(hex: "#D6E5E2")
        addButton.layer.borderColor = UIColor(hex: "#4F846C")?.cgColor
        addButton.layer.borderWidth = 1
        addButton.layer.cornerRadius = addButton.frame.height / 2
        substractButton.tintColor = UIColor(hex: "#4F846C")
        substractButton.backgroundColor = UIColor(hex: "#D6E5E2")
        substractButton.layer.borderColor = UIColor(hex: "#4F846C")?.cgColor
        substractButton.layer.borderWidth = 1
        substractButton.layer.cornerRadius = substractButton.frame.height / 2
        // 中間的數字
        itemNumberLabel.backgroundColor = .clear
    }
    
    func configure() {
        productImageView.image = UIImage(named: "nft")
        nameLabel.text = "商品名稱：阿姆斯特朗旋風噴射阿姆斯特朗砲"
        costLabel.text = "售價：1000"
        numberLabel.text = "X 1"
        totalCostLabel.text = "小記：$29,980"
    }
    
    func configure(with model: Product) {
        nameLabel.text = model.product_name
        numberLabel.text = "X \(model.order_qty)"
        itemNumberLabel.text = model.order_qty
        costLabel.text = "$\(model.product_price)"
        totalCostLabel.text = "小記：$\(model.total_amount)"
        
        let imageURLString = SHOP_ROOT_URL + model.product_picture
        productImageView.setImage(imageURL: imageURLString)
    }
    
    @IBAction func removeItemButtonTapped(_ sender: UIButton) {
        delegate?.removeItem(self)
    }
    @IBAction func itemNumberStepper(_ sender: UIButton) {
        if sender.tag == 0 { // 點minus
//            if itemNumber > minValue {
//                itemNumber -= stepValue
//            }
            delegate?.didSubstractQty(self)
        } else if sender.tag == 1 { // 點plus
//            if itemNumber < stock {
//                itemNumber += stepValue
//            }
            delegate?.didAddQty(self)
        }
    }
    
}
