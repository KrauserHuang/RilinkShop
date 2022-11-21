//
//  UICollectionViewCell + Ext.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/10/21.
//

import UIKit

extension UICollectionReusableView {
    static var nib: UINib {
        return UINib(nibName: String(describing: Self.self), bundle: nil)
    }

//    static var reuseIdentifier: String {
//        return String(describing: Self.self)
//    }
}

extension UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
