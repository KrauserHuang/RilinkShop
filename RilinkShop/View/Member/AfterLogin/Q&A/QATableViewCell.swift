//
//  QATableViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/9/22.
//

import UIKit

class QATableViewCell: UITableViewCell {

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        configure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    private func configure() {
        outerView.backgroundColor = .white
        outerView.addShadow(cornerRadius: 10,
                            shadowColor: .systemGray,
                            shadowOffset: CGSize(width: 2, height: 2),
                            shadowOpacity: 0.8,
                            shadowRadius: 5)
        contentLabel.numberOfLines = 0
        contentLabel.font = .systemFont(ofSize: 16)
    }

    func configure(with model: QA) {
        contentLabel.text = model.content
    }
}
