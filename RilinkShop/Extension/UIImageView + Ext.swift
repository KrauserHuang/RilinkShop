//
//  UIImageView + Ext.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/6.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(with imageURL: String) {
        self.kf.setImage(with: URL(string: imageURL))
    }
}
