//
//  UIImage + Ext.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/12.
//

import Foundation
import UIKit

extension UIImage {
    func imageResized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
