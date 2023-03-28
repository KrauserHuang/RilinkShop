//
//  RSProductImageView.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2023/3/1.
//

import UIKit

class RSProductImageView: UIImageView {
    
    let placeholderImage = Images.placeholder
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        contentMode = .scaleAspectFill
        translatesAutoresizingMaskIntoConstraints = false
        image = placeholderImage
    }
    
    func setImage(from urlString: String) {
//        NetworkManager.shared.downloadImage(for: urlString) { [weak self] image in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                self.image = image
//            }
//        }
        self.setImage(with: urlString)
    }
}
