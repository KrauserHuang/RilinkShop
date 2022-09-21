//
//  UIBarButtonItem + Ext.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/28.
//

import UIKit

private var handle: UInt8 = 0

extension CAShapeLayer {
    func drawRoundedRect(rect: CGRect, andColor color: UIColor, filled: Bool) {
        fillColor = filled ? color.cgColor : UIColor.white.cgColor
        strokeColor = color.cgColor
        path = UIBezierPath(roundedRect: rect, cornerRadius: 7).cgPath
    }
}

extension UIBarButtonItem {
    private var badgeLayer: CAShapeLayer? {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as? CAShapeLayer
        } else {
            return nil
        }
    }

    func setBadge(offset: CGPoint = .zero,
                  color: UIColor = .red,
                  filled: Bool = true,
                  fontSize: CGFloat = 11) {
        badgeLayer?.removeFromSuperlayer()
        guard let view = self.value(forKey: "view") as? UIView else { return }

        var font = UIFont.systemFont(ofSize: fontSize)

        if #available(iOS 9.0, *) {
            font = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .regular)
        }
        // Size of the dot
        let badgeSize = UILabel(frame: CGRect(x: 22, y: -5, width: 10, height: 10))
        // Initialize Badge
        let badge = CAShapeLayer()

        let height = badgeSize.bounds.height
        let width = badgeSize.bounds.width
        // x position is offset from right-hand side
//        let x = view.frame.width - width + offset.x
        /*
         I suggest you try the x and y sets, for my case, i will use this coordinates for better result,
         but depends on the size of your image
         */
        let x = view.frame.width + offset.x - 17
        let y = view.frame.height + offset.y - 34

//        let badgeFrame = CGRect(origin: CGPoint(x: x, y: offset.y), size: CGSize(width: width, height: height))
        let badgeFrame = CGRect(origin: CGPoint(x: x, y: y),
                                size: CGSize(width: width, height: height))

        badge.drawRoundedRect(rect: badgeFrame, andColor: color, filled: filled)
        view.layer.addSublayer(badge)
        // Initialize Badge's label
        let label = CATextLayer()
        label.alignmentMode = .center
        label.font = font
        label.fontSize = font.pointSize

        label.frame = badgeFrame
        label.foregroundColor = filled ? UIColor.white.cgColor : color.cgColor
        label.backgroundColor = UIColor.clear.cgColor
        label.contentsScale = UIScreen.main.scale
        badge.addSublayer(label)
        // Save badge as UIBarButtonItem property
        objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        // Bring layer to front
        badge.zPosition = 1_000
    }

    func removeBadge() {
        badgeLayer?.removeFromSuperlayer()
    }
}

// MARK: - With number
//// private var handle: UInt8 = 0
// extension CAShapeLayer {
//    func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor, filled: Bool) {
//        fillColor = filled ? color.cgColor : UIColor.white.cgColor
//        strokeColor = color.cgColor
//        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
//        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
//    }
// }
//
// extension UIBarButtonItem {
//    func addBadge(number: Int, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = UIColor.red, andFilled filled: Bool = true) {
//        guard let view = self.value(forKey: "view") as? UIView else { return }
//
//        badgeLayer?.removeFromSuperlayer()
//
//        // Initialize Badge
//        let badge = CAShapeLayer()
//        let radius = CGFloat(7)
//        let location = CGPoint(x: view.frame.width - (radius + offset.x), y: (radius + offset.y))
//        badge.drawCircleAtLocation(location: location, withRadius: radius, andColor: color, filled: filled)
//        view.layer.addSublayer(badge)
//
//        // Initialiaze Badge's label
//        let label = CATextLayer()
//        label.string = "\(number)"
//        label.alignmentMode = CATextLayerAlignmentMode.center
//        label.fontSize = 11
//        label.frame = CGRect(origin: CGPoint(x: location.x - 4, y: offset.y), size: CGSize(width: 8, height: 16))
//        label.foregroundColor = filled ? UIColor.white.cgColor : color.cgColor
//        label.backgroundColor = UIColor.clear.cgColor
//        label.contentsScale = UIScreen.main.scale
//        badge.addSublayer(label)
//
//        // Save Badge as UIBarButtonItem property
//        objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//    }
//
//    func updateBadge(number: Int) {
//        if let text = badgeLayer?.sublayers?.filter({ $0 is CATextLayer }).first as? CATextLayer {
//            text.string = "\(number)"
//        }
//    }
//
//    func removeBadge() {
//        badgeLayer?.removeFromSuperlayer()
//    }
// }
