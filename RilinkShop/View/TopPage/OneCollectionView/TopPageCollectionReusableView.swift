//
//  TopPageCollectionReusableView.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/9/27.
//

import UIKit

class TopPageCollectionReusableView: UICollectionReusableView {
    static let reuseIdentifier = "TopPageCollectionReusableView"
//    let label: UILabel
//
//    enum Constants {
//        static let padding: CGFloat = 20.0
//    }

    override init(frame: CGRect) {
//        label = UILabel()
        super.init(frame: .zero)
//        backgroundColor = .clear
//        label.numberOfLines = 0
//        addSubview(label)
//        label.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),
//            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding),
//            label.topAnchor.constraint(equalTo: topAnchor, constant: Constants.padding),
//            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.padding)
//        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
