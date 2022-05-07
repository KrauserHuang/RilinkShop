//
//  HostelCollectionViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/26.
//

import UIKit

class HostelCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "HostelCollectionViewCell"

    @IBOutlet weak var hostelImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
//    func configure(with model: Package) {
//        let imageURLString = TEST_ROOT_URL + model.productPicture
//        hostelImageView.setImage(imageURL: imageURLString)
//    }
}
