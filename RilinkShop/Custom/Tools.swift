//
//  Tools.swift
//  Rilink
//
//  Created by 王璽權 on 2022/1/17.
//

import Foundation
import UIKit

class Tool {

    func makeRoundedCornersButton( button: UIButton) {
        button.layer.cornerRadius = button.frame.height / 2
    }

    let customOrange = UIColor(red: 255/255, green: 82/255, blue: 2/255, alpha: 1)
    let customGreen = UIColor(hex: "4F846C")

}

class Theme {
    static let customOrange = UIColor(red: 222/255, green: 119/255, blue: 58/255, alpha: 1)
}
