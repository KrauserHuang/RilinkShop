//
//  UIImageView + Ext.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/6.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func setImage(imageURL: String) {
        self.kf.setImage(with: URL(string: imageURL))
    }
}
