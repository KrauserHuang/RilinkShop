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
    
    func configure(with model: Store) {
        let imageURLString = TEST_ROOT_URL + model.storePicture
        hostelImageView.setImage(imageURL: imageURLString)
    }
}
