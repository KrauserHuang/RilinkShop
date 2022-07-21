//
//  ShopMainViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/7/13.
//

import UIKit
import DropDown

enum Item: Hashable {
    case product(Product)
    case package(Package)
}

struct CategoryCellModel {
    var category: Category
    var isSelected: Bool = false
}

class ShopMainViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var shopTypeButton: UIButton!
    @IBOutlet weak var searchBarTextField: UITextField! {
        didSet {
            let view = UIView()
            let imageView = UIImageView(image: UIImage(named: "search"))
            view.addSubview(imageView)
            imageView.frame = CGRect(x: 6, y: 4.5, width: 18, height: 21)
            view.frame = CGRect(x: 0, y: 0, width: 24, height: 30)
            searchBarTextField.leftView = view
            searchBarTextField.leftViewMode = .always
        }
    }
    
    enum Section: String, CaseIterable {
        case all
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    private lazy var dataSource = configureDataSource()
    
    var categories = [CategoryCellModel]()
    
    var products = [Product]()
    var filteredProducts = [Product]()
    
    var packages = [Package]()
    
    var items = [Item]()
    var filteredItems = [Item]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    let dropDown = DropDown()
    
    let account = MyKeyChain.getAccount() ?? ""
    let password = MyKeyChain.getPassword() ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.hidesBottomBarWhenPushed = false
        tabBarController?.tabBar.isHidden = false
//        collectionView.contentInsetAdjustmentBehavior = .automatic
//        initUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissKeyboard()
    }
    
    func initUI() {
        navigationItems()
        configureCollectionView()
        loadProductType()
        configureKeyboard()
    }
    
    func navigationItems() {
        let shoppingcartButton = UIBarButtonItem(image: UIImage(systemName: "cart"),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(toCartViewController))
        navigationItem.rightBarButtonItem = shoppingcartButton
    }
    @objc private func toCartViewController() {
        let vc = CartViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func configureKeyboard() {
        searchBarTextField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func configureCollectionView() {
        let nib = UINib(nibName: ShopCollectionViewCell.reuseIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: ShopCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
//        collectionView.dataSource = self
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createGridLayout()
    }
    
    func loadProductType() {
        ProductService.shared.getProductType(id: account,
                                             pwd: password) { responseCategories in
            var isFirstCategory = true
            let packageCategory = Category(pid: "", productType: "", productTypeName: "套票")
            var wholeCategories = responseCategories
            wholeCategories.append(packageCategory)
            self.categories = wholeCategories.map {
                if isFirstCategory {
                    isFirstCategory = false
                    return CategoryCellModel(category: $0, isSelected: true)
                } else {
                    return CategoryCellModel(category: $0)
                }
            }
            if let firstType = self.categories.first {
                self.shopTypeButton.setTitle(firstType.category.productTypeName, for: .normal)
            }
            self.loadProductList()
        }
    }
    
    func loadProductList() {
        HUD.showLoadingHUD(inView: self.view, text: "載入商品中")
        ProductService.shared.loadProductList(id: account,
                                              pwd: password) { responseProducts in
            HUD.hideLoadingHUD(inView: self.view)
            let wholeProducts = responseProducts
            self.products = wholeProducts
            
            ProductService.shared.loadPackageList(id: self.account,
                                                  pwd: self.password) { packagesResponse in
                let wholePackages = packagesResponse
                self.packages = wholePackages
                
                self.items.removeAll()
                for product in self.products {
                    self.items.append(Item.product(product))
                }
                for package in self.packages {
                    self.items.append(Item.package(package))
                }
                
                self.filteredItems = self.items.filter {
                    switch $0 {

                    case .product(let product):
                        if product.product_type == self.categories.first?.category.productType {
                            return true
                        } else {
                            return false
                        }
                    case .package:
                        if self.categories.first?.category.productTypeName == "套票" {
                            return true
                        } else {
                            return false
                        }
                    }
                }
                self.updateSnapshot()
            }
        }
    }
    @IBAction func shopTypeButtonTapped(_ sender: UIButton) {
        var typeNames = [String]()
        for category in categories {
            typeNames.append(category.category.productTypeName)
        }
        dropDown.dataSource = typeNames
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.shopTypeButton.setTitle(item, for: .normal)
            
            self.filteredItems.removeAll()
            for singleItem in self.items {
                switch singleItem {
                case .product(let product):
                    if product.producttype_name == item {
                        self.filteredItems.append(singleItem)
                    } else {
//                        print("append product失敗！")
                    }
                case .package:
                    if item == "套票" {
                        self.filteredItems.append(singleItem)
                    } else {
//                        print("append package失敗！")
                    }
                }
            }
            self.updateSnapshot()
        }
    }
}
// MARK: - UICollectionViewDelegate/DataSource
extension ShopMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredItems.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: ShopCollectionViewCell.reuseIdentifier, for: indexPath) as! ShopCollectionViewCell
        
        let singleItem = filteredItems[indexPath.item]
        item.configure(with: singleItem)
        
        return item
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = filteredItems[indexPath.item]
        let productDetailVC = ProductDetailViewController()
        productDetailVC.itemInfo = item
        navigationController?.pushViewController(productDetailVC, animated: true)
    }
}
// MARK: - Item DiffableDataSource/Snapshot/Compositional Layout
extension ShopMainViewController {
    func configureDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopCollectionViewCell.reuseIdentifier, for: indexPath) as! ShopCollectionViewCell
            
            cell.configure(with: itemIdentifier)
            
            return cell
        }
        return dataSource
    }
    func updateSnapshot(animatingChange: Bool = false) {
        var snapshot = Snapshot()
        snapshot.appendSections([.all])
        snapshot.appendItems(filteredItems, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(260.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}
// MARK: - UITextFieldDelegate
extension ShopMainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
// MARK: - UIGestureRecognizerDelegate
extension ShopMainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        print("shouldReceive")
        if touch.view == collectionView {
            print("tap點擊有效")
            return true
        } else {
            print("tap點擊失效")
            return false
        }
    }
}
