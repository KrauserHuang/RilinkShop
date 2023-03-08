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
        contentView.layer.borderColor       = UIColor.systemGray.cgColor
        contentView.layer.borderWidth       = 1
        contentView.layer.cornerRadius      = 10
        productImageView.layer.cornerRadius = 10
        initCell()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let margins         = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        contentView.frame   = contentView.frame.inset(by: margins)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func initCell() {
        totalCostLabel.textColor            = .primaryOrange
        
        stepperOuterView.backgroundColor    = .systemGray6 // stepper外圍
        stepperOuterView.layer.cornerRadius = stepperOuterView.frame.height / 2
        
        addButton.tintColor                 = .white // 加減
        addButton.backgroundColor           = .primaryOrange
        addButton.layer.cornerRadius        = addButton.frame.height / 2
        substractButton.tintColor           = .white
        substractButton.backgroundColor     = .primaryOrange
        substractButton.layer.cornerRadius  = substractButton.frame.height / 2
        
        itemNumberLabel.backgroundColor     = .clear // 中間的數字
    }

    func configure(with model: Product) {
        nameLabel.text          = model.product_name
        numberLabel.text        = "X \(model.order_qty)"
        itemNumberLabel.text    = model.order_qty
        costLabel.text          = "$\(model.product_price)"
        totalCostLabel.text     = "小記：$\(model.total_amount)"
        let imageURLString      = SHOP_ROOT_URL + model.product_picture
        productImageView.setImage(with: imageURLString)
    }

    @IBAction func removeItemButtonTapped(_ sender: UIButton) {
        delegate?.removeItem(self)
    }
    @IBAction func itemNumberStepper(_ sender: UIButton) {
        if sender.tag == 0 {                // 點minus
            delegate?.didSubstractQty(self)
        } else if sender.tag == 1 {         // 點plus
            delegate?.didAddQty(self)
        }
    }
}
