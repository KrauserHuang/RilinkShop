//
//  UIView + Ext.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/8/12.
//

import UIKit

// MARK: - Quick setup for cornerRadius/border/shadow
extension UIView {
    func addCornerRadius(_ radius: CGFloat = 4) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }

    func addBorder(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }

    func makeRound() {
        layer.masksToBounds = false
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }

    func addShadow(cornerRadius: CGFloat = 16,
                   shadowColor: UIColor = UIColor(white: .zero, alpha: 0.5),
                   shadowOffset: CGSize = CGSize(width: 0.0, height: 3.0),
                   shadowOpacity: Float = 0.3,
                   shadowRadius: CGFloat = 5) {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
    }
}

protocol Badgeable {}

extension UIView: Badgeable {
    func addBadge() {
        translatesAutoresizingMaskIntoConstraints = false

        let diameter: CGFloat = 30
        let badge = UIButton()

        badge.translatesAutoresizingMaskIntoConstraints = false
        badge.contentEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        badge.layer.cornerRadius = diameter / 2
        badge.setTitleColor(.white, for: .normal)
        badge.backgroundColor = .systemRed
        badge.setTitle("4", for: .normal)

        self.addSubview(badge)

        NSLayoutConstraint.activate([
            badge.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            badge.bottomAnchor.constraint(equalTo: topAnchor, constant: 16),
            badge.widthAnchor.constraint(greaterThanOrEqualToConstant: diameter),
            badge.heightAnchor.constraint(equalToConstant: diameter)
        ])
    }
}

extension UIView {

    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
