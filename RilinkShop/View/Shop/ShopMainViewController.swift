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
    // 類別按鈕
    var categories = [CategoryCellModel]()
    // 商品
    var products = [Product]()
    // 套票
    var packages = [Package]()
    // 所有物件與篩選物件(商品+套票)
    var items = [Item]()
    var filteredItems = [Item]() {
        didSet {
            DispatchQueue.main.async {
                self.updateSnapshot()
            }
        }
    }
    let dropDown = DropDown()

    let notificationCenter = NotificationCenter.default
    var productType: String?
//    var productType = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()

//        print("ShopMainViewController " + #function)
//        print("GlobalAccount:\(Global.ACCOUNT)")
//        print("GlobalPassword:\(Global.ACCOUNT_PASSWORD)")
//        print("-----------------------------------")
//        print("KeyChainAccount:\(MyKeyChain.getAccount())")
//        print("KeyChainPassword:\(MyKeyChain.getPassword())")
//        print("-----------------------------------")
//        print("UserServiceAccount:\(UserService.shared.id)")
//        print("UserServicePassword:\(UserService.shared.pwd)")
//        let notificationName = Notification.Name.productTypeCommingHot
        let notificationName = Notification.Name.hereComesTheProductType
        notificationCenter.addObserver(self,
                                       selector: #selector(navigateFromTopPage(_:)),
                                       name: notificationName,
                                       object: nil)
    }
    @objc func navigateFromTopPage(_ notification: Notification) {
        if let productType = notification.userInfo?["productType"] {
            print(#function)
            print("productType:\(productType)")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.hidesBottomBarWhenPushed = false
        tabBarController?.tabBar.isHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        HUD.showLoadingHUD(inView: view, text: "")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            HUD.hideLoadingHUD(inView: self.view)
            if self.productType == "SC001" {
                self.filteredItems.removeAll()
                for singleItem in self.items {
                    switch singleItem {
                    case .product(let product):
                        if product.product_type == self.productType { // 如果item內容與所有物件內producttype_name有吻合
                            self.filteredItems.append(singleItem) // 則更新filteredItems的內容
                            self.shopTypeButton.setTitle(product.producttype_name, for: .normal)
                        } else {
        //                        print("append product失敗！")
                        }
                    case .package:
                        if self.productType == "套票" {
                            self.filteredItems.append(singleItem)
                        } else {
        //                        print("append package失敗！")
                        }
                    }
                }
            } else if self.productType == "Rent" {
                self.filteredItems.removeAll()
                for singleItem in self.items {
                    switch singleItem {
                    case .product(let product):
                        if product.product_type == self.productType { // 如果item內容與所有物件內producttype_name有吻合
                            self.filteredItems.append(singleItem) // 則更新filteredItems的內容
                            self.shopTypeButton.setTitle(product.producttype_name, for: .normal)
                        } else {
        //                        print("append product失敗！")
                        }
                    case .package:
                        if self.productType == "套票" {
                            self.filteredItems.append(singleItem)
                        } else {
        //                        print("append package失敗！")
                        }
                    }
                }
            } else {
                return
            }
        }

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissKeyboard()
        notificationCenter.removeObserver(self)
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
//        let vc = CartViewController(account: LocalStorageManager.shared.getData(String.self, forKey: .userIdKey)!,
//                                    password: LocalStorageManager.shared.getData(String.self, forKey: .userPasswordKey)!)
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
//        ProductService.shared.getProductType(id: LocalStorageManager.shared.getData(String.self, forKey: .userIdKey)!,
//                                             pwd: LocalStorageManager.shared.getData(String.self, forKey: .userPasswordKey)!) { responseCategories in
        ProductService.shared.getProductType(id: MyKeyChain.getAccount() ?? "",
                                             pwd: MyKeyChain.getPassword() ?? "") { responseCategories in
//        ProductService.shared.getProductType(id: MyKeyChain.getAccount() ?? UserService.shared.id,
//                                             pwd: MyKeyChain.getPassword() ?? UserService.shared.pwd) { responseCategories in
            var isFirstCategory = true
            let packageCategory = Category(pid: "", productType: "", productTypeName: "套票") // 建立一個空的類別儲存套票
            var wholeCategories = responseCategories // 建立全部類別，先加入商品類別(從API來)
            wholeCategories.append(packageCategory) // 將套票類別也加進來
            self.categories = wholeCategories.map {
                if isFirstCategory {
                    isFirstCategory = false
                    return CategoryCellModel(category: $0, isSelected: true) // 之前是為了變化categoryCollectionViewCell的UI做的，這邊應該沒用途
                } else {
                    return CategoryCellModel(category: $0)
                }
            }
            if let firstType = self.categories.first { // 從類別中的第一個提出來顯示(假如是“保健食品”，那就直接變更button的UI)
                self.shopTypeButton.setTitle(firstType.category.productTypeName, for: .normal)
            }
            self.loadProductList()
        }
    }

    func loadProductList() {
        HUD.showLoadingHUD(inView: self.view, text: "載入商品中")
//        ProductService.shared.loadProductList(id: LocalStorageManager.shared.getData(String.self, forKey: .userIdKey)!,
//                                              pwd: LocalStorageManager.shared.getData(String.self, forKey: .userPasswordKey)!) { responseProducts in
        ProductService.shared.loadProductList(id: MyKeyChain.getAccount() ?? "",
                                              pwd: MyKeyChain.getPassword() ?? "") { responseProducts in
//        ProductService.shared.loadProductList(id: MyKeyChain.getAccount() ?? UserService.shared.id,
//                                              pwd: MyKeyChain.getPassword() ?? UserService.shared.pwd) { responseProducts in
            HUD.hideLoadingHUD(inView: self.view)
            let wholeProducts = responseProducts
            self.products = wholeProducts
            
//            ProductService.shared.loadPackageList(id: LocalStorageManager.shared.getData(String.self, forKey: .userIdKey)!,
//                                                  pwd: LocalStorageManager.shared.getData(String.self, forKey: .userPasswordKey)!) { packagesResponse in
            ProductService.shared.loadPackageList(id: MyKeyChain.getAccount() ?? "",
                                                  pwd: MyKeyChain.getPassword() ?? "") { packagesResponse in
//            ProductService.shared.loadPackageList(id: MyKeyChain.getAccount() ?? UserService.shared.id,
//                                                  pwd: MyKeyChain.getPassword() ?? UserService.shared.pwd) { packagesResponse in
                let wholePackages = packagesResponse
                self.packages = wholePackages

                self.items.removeAll() // 先移除所有物件

                for product in self.products {
                    self.items.append(Item.product(product)) // 將個別product放進items裡面
                }
                for package in self.packages {
                    self.items.append(Item.package(package)) // 將個別package放進items裡面
                }

                self.filteredItems = self.items.filter { // 將所有物件(items)進行篩選至篩選物件(filteredItems)裡面
                    switch $0 { // 先篩選第一層(如果使用者選取商品類別)
                    case .product(let product):
                        if product.product_type == self.categories.first?.category.productType {
                            return true
                        } else {
                            return false
                        }
                    case .package: // (套票類別，沒API所以有做死)
                        if self.categories.first?.category.productTypeName == "套票" {
                            return true
                        } else {
                            return false
                        }
                    }
                }
            }
        }
    }

    func loadProductList(productType: String) {
//        ProductService.shared.loadProductList(id: LocalStorageManager.shared.getData(String.self, forKey: .userIdKey)!,
//                                              pwd: LocalStorageManager.shared.getData(String.self, forKey: .userPasswordKey)!,
//                                              productType: productType) { success, response in
        ProductService.shared.loadProductList(id: MyKeyChain.getAccount() ?? "",
                                              pwd: MyKeyChain.getPassword() ?? "",
                                              productType: productType) { success, response in
//        ProductService.shared.loadProductList(id: MyKeyChain.getAccount() ?? UserService.shared.id,
//                                              pwd: MyKeyChain.getPassword() ?? UserService.shared.pwd,
//                                              productType: productType) { success, response in
            guard success else {
                let errorMsg = response as! String
                Alert.showMessage(title: "", msg: errorMsg, vc: self)
                return
            }

            let productList = response as! [Product]
            self.products = productList
            self.filteredItems.removeAll()
            for product in self.products {
                self.items.append(Item.product(product))
            }
            print(#function, "items:\(self.items)")
            self.filteredItems = self.items.filter({
                switch $0 { // 先篩選第一層(如果使用者選取商品類別)
                case .product(let product):
                    if product.product_type == self.categories.first?.category.productType {
                        return true
                    } else {
                        return false
                    }
                case .package: // (套票類別，沒API所以有做死)
                    if self.categories.first?.category.productTypeName == "套票" {
                        return true
                    } else {
                        return false
                    }
                }
            })
        }
    }

    @IBAction func shopTypeButtonTapped(_ sender: UIButton) {
        var typeNames = [String]()
        for category in categories {
            typeNames.append(category.category.productTypeName)
        }
        dropDown.dataSource = typeNames
        dropDown.anchorView = shopTypeButton
        dropDown.bottomOffset = CGPoint(x: 0, y: shopTypeButton.frame.size.height)
        dropDown.show()
        dropDown.selectionAction = { [weak self] (_: Int, item: String) in
            guard let self = self else { return }
            self.shopTypeButton.setTitle(item, for: .normal) // 點擊dropDown的item則將item的內容放進button的UI

            self.filteredItems.removeAll()
            for singleItem in self.items {
                switch singleItem {
                case .product(let product):
                    if product.producttype_name == item { // 如果item內容與所有物件內producttype_name有吻合
                        self.filteredItems.append(singleItem) // 則更新filteredItems的內容
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
        }
    }
}
// MARK: - UICollectionViewDelegate/DataSource
// extension ShopMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
extension ShopMainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }

//        let item = filteredItems[indexPath.item]
//        let productDetailVC = ProductDetailViewController(account: LocalStorageManager.shared.getData(String.self, forKey: .userIdKey)!,
//                                                          password: LocalStorageManager.shared.getData(String.self, forKey: .userPasswordKey)!)
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
    func updateSnapshot(animatingChange: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.all])
        snapshot.appendItems(filteredItems, toSection: .all)

        dataSource.apply(snapshot, animatingDifferences: animatingChange)
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
// MARK: - UIGestureRecognizerDelegate(為了避開collectionViewCell點擊效果)
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
