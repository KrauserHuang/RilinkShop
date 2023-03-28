//
//  UIColor + Ext.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/26.
//

import UIKit

extension UIColor {
    static let primaryOrange    = UIColor(red: 222, green: 119, blue: 58)
    static let defaultGrey      = UIColor(hex: "#262628")

    // 訊息中心頁面
    static let messageOrange    = UIColor(hex: "DC5310")
    static let messageGray      = UIColor(hex: "B7B3B3")
    
    static let pickerViewMainColor = UIColor(hex: "FF5100")
}

extension UIColor {
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
       self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
    convenience init?(hex: String) {
        // trimmingCharacters -> 修剪不必要的字元，.whitespacesAndNewlines -> 空白跟換行符號
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        // replacingOccurrences -> 將所提示在字串內的所有符合的字元調換成另外一個(這裏把#換成空白)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        // UInt64等同Int64，只是將範圍從負數移到整數去
        var rgbValue: UInt64 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        let length = hexSanitized.count
        // Scanner用於掃描指定字串，scanHexInt64掃描字符串前綴是否是0x/0X，並回傳true/false
        // 將0x後面符合16進制數的字符串轉化成10進制，可運用於UIColor關於16進制的轉化
        guard Scanner(string: hexSanitized).scanHexInt64(&rgbValue) else { return nil }
        print(Scanner(string: hexSanitized).scanHexInt64(&rgbValue))

        if length == 6 {
            r = CGFloat((rgbValue & 0xFF00000) >> 16) / 255.0
            g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgbValue & 0x0000FF) / 255.0
        } else if length == 8 {
            r = CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgbValue & 0x000000FF) / 255.0
        } else {
            return nil
        }
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
