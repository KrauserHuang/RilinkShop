//
//  ShopTypeTableViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/27.
//

import UIKit

class ShopTypeTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "ShopTypeTableViewCell"

    @IBOutlet weak var shopTypeCollectionView: UICollectionView!
    
    var categories = [CategoryCellModel]() {
        didSet {
            DispatchQueue.main.async {
                self.shopTypeCollectionView.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shopTypeCollectionView.register(UINib(nibName: ShopTypeCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: ShopTypeCollectionViewCell.reuseIdentifier)
        shopTypeCollectionView.delegate = self
        shopTypeCollectionView.dataSource = self
        shopTypeCollectionView.showsHorizontalScrollIndicator = false
        
        if let layout = shopTypeCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.scrollDirection = .horizontal
            let width = UIScreen.main.bounds.width / 4
            layout.itemSize = CGSize(width: width, height: 50)
        }
        
        loadProductType()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadProductType() {
        ProductService.shared.getProductType(id: "0911838460", pwd: "simon07801") { responseCategories in
            var isFirstCategory = true
            self.categories = responseCategories.map {
                if isFirstCategory {
                    isFirstCategory = false
                    return CategoryCellModel(category: $0, isSelected: true)
                } else {
                    return CategoryCellModel(category: $0)
                }
            }
        }
    }
    
}

extension ShopTypeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: ShopTypeCollectionViewCell.reuseIdentifier, for: indexPath) as! ShopTypeCollectionViewCell
        
        let category = categories[indexPath.item]
        item.configure(with: category)
        item.isItemSelected = category.isSelected
        
        return item
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for (index, _) in categories.enumerated() {
            categories[index].isSelected = index == indexPath.item
        }
    }
}
