//
//  ConvertibleTableViewCell.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/10.
//

import UIKit

class ConvertibleTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var exchangeDate: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    @IBAction func copyAction(_ sender: UIButton) {
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func configure() {
        copyButton.layer.cornerRadius   = copyButton.frame.height / 2
        copyButton.backgroundColor      = .white
        copyButton.layer.borderColor    = UIColor.primaryOrange.cgColor
        copyButton.layer.borderWidth    = 2
        copyButton.tintColor            = UIColor.primaryOrange
    }
}
