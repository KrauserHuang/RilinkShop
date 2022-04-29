//
//  ShopViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/6.
//

import UIKit

protocol ShopViewControllerDelegate: AnyObject {
    func showInfo(_ viewController: ShopViewController)
}

struct CategoryCellModel {
    let category: Category
    var isSelected: Bool = false
}

class ShopViewController: UIViewController {
    
    @IBOutlet weak var cartButton: UIBarButtonItem!
    @IBOutlet weak var anotherCategoryCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var listTableView: UITableView!
    
    var categories = [CategoryCellModel]() {
        didSet {
            DispatchQueue.main.async {
                self.categoryCollectionView.reloadData()
            }
        }
    }
    var products = [Product]()
    var filteredProducts = [Product]() {
        didSet {
            DispatchQueue.main.async {
                self.listTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureTableView()
        loadProductType()
        cartButton.setBadge()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.hidesBottomBarWhenPushed = false
        self.tabBarController?.tabBar.isHidden = false
//        self.automaticallyAdjustsScrollViewInsets = false
        self.listTableView.contentInsetAdjustmentBehavior = .automatic
        configureCollectionView()
        configureTableView()
    }
    
    func configureCollectionView() {
        let categoryNib = UINib(nibName: CategoryCollectionViewCell.reuseIdentifier, bundle: nil)
        print("---------")
        print(categoryNib)
        print("---------")
        categoryCollectionView.register(categoryNib, forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
//        categoryCollectionView.showsHorizontalScrollIndicator = false
//        categoryCollectionView.showsVerticalScrollIndicator = false
        if let layout = categoryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 5
            let width = UIScreen.main.bounds.width / 4
            print("width: \(width)")
            layout.itemSize = CGSize(width: width, height: 50)
        }
    }
    
    func configureTableView() {
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(UINib(nibName: ListTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ListTableViewCell.reuseIdentifier)
        listTableView.separatorStyle = .none
        listTableView.estimatedRowHeight = UITableView.automaticDimension
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
            
            ProductService.shared.getProductList(id: "0911838460", pwd: "simon07801") { responseProducts in
                self.products = responseProducts
                self.filteredProducts = self.products.filter({ product in
                    product.productType == self.categories.first?.category.productType
                })
            }
        }
    }
    @IBAction func toCartVC(_ sender: UIBarButtonItem) {
        let cartVC = CartViewController()
        navigationController?.pushViewController(cartVC, animated: true)
    }
    
}

extension ShopViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProducts.count
//        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier, for: indexPath) as! ListTableViewCell
        
        let product = filteredProducts[indexPath.row]
        cell.configure(with: product)
//        cell.configure()
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ProductDetailViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 122
    }
}

extension ShopViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
        
        let category = categories[indexPath.row]
        item.configure(with: category)
        item.isItemSelected = category.isSelected
        
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // UI
        for (index, _) in categories.enumerated() {
            categories[index].isSelected = index == indexPath.item
        }
        // filteredItems update
        filteredProducts.removeAll()
        for product in products {
            if product.productType == categories[indexPath.item].category.productType {
                filteredProducts.append(product)
            }
        }
    }
}
