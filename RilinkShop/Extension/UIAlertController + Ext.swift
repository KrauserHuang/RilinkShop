//
//  UIAlertController + Ext.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/27.
//

import Foundation
import UIKit

extension UIAlertController {
    static func simpleOKAlert(title: String, message: String, buttonTitle: String, action: ((UIAlertAction)->())?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: action)
        alert.addAction(action)
        return alert
    }
}
