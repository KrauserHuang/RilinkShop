//
//  RSButton.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2023/3/6.
//

import UIKit

class RSButton: UIButton {
    
    var isTinted: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(isTinted: Bool, color: UIColor, title: String) {
        self.init(frame: .zero)
        setTitle(title, for: .normal)
        
        if isTinted {
            backgroundColor = color
            layer.borderColor = UIColor.white.cgColor
            setTitleColor(.white, for: .normal)
        } else {
            backgroundColor = .white
            layer.borderColor = color.cgColor
            setTitleColor(color, for: .normal)
        }
    }
    
    private func configure() {
        layer.cornerRadius = 10
        layer.borderWidth = 1
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
