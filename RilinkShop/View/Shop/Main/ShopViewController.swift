//
//  ShopViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/6.
//

import UIKit

protocol ShopViewControllerDelegate: AnyObject {
    func showInfo(_ viewController: ShopViewController, for item: Product)
}

struct CategoryCellModel: Hashable {
    let category: Category
    var isSelected: Bool = false
}

class ShopViewController: UIViewController {
    
    enum Section {
        case all
    }
    
    @IBOutlet weak var cartButton: UIBarButtonItem!
    @IBOutlet weak var anotherCategoryCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var listTableView: UITableView!
    
    weak var delegate: ShopViewControllerDelegate?
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, CategoryCellModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, CategoryCellModel>
//    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Category>
//    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, String>
    
    private lazy var dataSource = configureDataSource()
    
    var categories = [CategoryCellModel]() {
        didSet {
            DispatchQueue.main.async {
                self.anotherCategoryCollectionView.reloadData()
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
        
        loadProductType()
        configureCollectionView()
        configureTableView()
        cartButton.setBadge()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.hidesBottomBarWhenPushed = false
        self.tabBarController?.tabBar.isHidden = false
//        self.automaticallyAdjustsScrollViewInsets = false
        self.listTableView.contentInsetAdjustmentBehavior = .automatic
//        loadProductType()
//        configureCollectionView()
//        configureTableView()
        
    }
    
    func configureCollectionView() {
        let anotherNib = UINib(nibName: AnotherCollectionViewCell.reuseIdentifier, bundle: nil)
        anotherCategoryCollectionView.register(anotherNib, forCellWithReuseIdentifier: AnotherCollectionViewCell.reuseIdentifier)
        anotherCategoryCollectionView.delegate = self
        // 2022/5/3修改dataSource改採用UICollectionViewDiffableDataSource
        anotherCategoryCollectionView.dataSource = dataSource
        // 2022/5/3修改UICollectionViewFlowLayout改採用UICollectionViewCompositionalLayout
        anotherCategoryCollectionView.collectionViewLayout = createCategoryLayout()
        anotherCategoryCollectionView.isScrollEnabled = false
        // 2022/5/3資料顯示方式改採NSDiffableDataSourceSnapshot
        updateSnapshot()
    }
    
    func configureTableView() {
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(UINib(nibName: ListTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ListTableViewCell.reuseIdentifier)
        listTableView.separatorStyle = .none
        listTableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func loadProductType() {
//        ProductService.shared.getProductType(id: "0911838460", pwd: "simon07801") { responseCategories in
        ProductService.shared.getProductType(id: "0910619306", pwd: "a12345678") { responseCategories in
            var isFirstCategory = true
            self.categories = responseCategories.map {
                if isFirstCategory {
                    isFirstCategory = false
                    return CategoryCellModel(category: $0, isSelected: true)
                } else {
                    return CategoryCellModel(category: $0)
                }
            }
//            print("---------------")
//            print("\(self.categories)")
            self.updateSnapshot()
//            ProductService.shared.getProductList(id: "0911838460", pwd: "simon07801") { responseProducts in
            ProductService.shared.loadProductList(id: "0910619306", pwd: "a12345678") { responseProducts in
                self.products = responseProducts
                self.filteredProducts = self.products.filter({ product in
//                    product.productType == self.categories.first?.category.productType
                    product.product_type == self.categories.first?.category.productType
                })
//                self.anotherCategoryCollectionView.reloadData()
//                self.listTableView.reloadData()
            }
        }
    }
    @IBAction func toCartVC(_ sender: UIBarButtonItem) {
        let cartVC = CartViewController()
        navigationController?.pushViewController(cartVC, animated: true)
    }
    
}
// MARK: - UITableViewDelegate/DataSource
extension ShopViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier, for: indexPath) as! ListTableViewCell
        
        let product = filteredProducts[indexPath.row]
        cell.configure(with: product)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = filteredProducts[indexPath.row]
//        delegate?.showInfo(self, for: item)
        let productDetailVC = ProductDetailViewController()
        productDetailVC.itemInfo = item
        navigationController?.pushViewController(productDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 122
    }
}
// MARK: - UICollectionViewDelegate/DataSource
extension ShopViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return categories.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let item = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
//
//        let category = categories[indexPath.row]
//        item.configure(with: category)
//        item.isItemSelected = category.isSelected
//
//        return item
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // UI
        for (index, _) in categories.enumerated() {
            categories[index].isSelected = index == indexPath.item
            updateSnapshot()
        }
        // filteredItems update
        filteredProducts.removeAll()
        for product in products {
//            if product.productType == categories[indexPath.item].category.productType {
            if product.product_type == categories[indexPath.item].category.productType {
                filteredProducts.append(product)
            }
        }
    }
}

//extension ShopViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: indexPath.item, height: 50)
//    }
//}
// MARK: - DataSource/Snapshot/CompositionalLayout
extension ShopViewController {
    // data source
    func configureDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: anotherCategoryCollectionView) { collectionView, indexPath, categoryCellModel -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnotherCollectionViewCell.reuseIdentifier, for: indexPath) as! AnotherCollectionViewCell
            
            if let category = self.dataSource.itemIdentifier(for: indexPath) {
                cell.configure(with: category)
                cell.isItemSelected = category.isSelected
            }
            
//            cell.label.text = category.category.productTypeName
//            cell.configure()
//            cell.isItemSelected = self.categories[indexPath.row].isSelected
//            cell.isItemSelected = category.isSelected
            
            return cell
        }
        return dataSource
    }
    // snapshot
    func updateSnapshot(animatingChange: Bool = false) {
        var snapshot = Snapshot()
        snapshot.appendSections([.all])
//        let allCategories = categories.map { $0 }
//        snapshot.appendItems(allCategories, toSection: .all)
        snapshot.appendItems(categories, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: animatingChange, completion: nil)
    }
    // compositional layout
    func createCategoryLayout() -> UICollectionViewLayout {
//        let estimatedWidth: CGFloat = 100
//        let estimatedHeight: CGFloat = 50
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                              heightDimension: .fractionalHeight(1))
//        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
//                                              heightDimension: .fractionalHeight(1))
//        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(estimatedWidth),
//                                              heightDimension: .estimated(estimatedHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: .fixed(8), bottom: nil)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(50.0))
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
//                                               heightDimension: .estimated(estimatedHeight))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 4)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
//        section.interGroupSpacing = 8
        section.orthogonalScrollingBehavior = .continuous
//        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

extension ShopViewController {
    func generateCompositionalLayout(with layoutSections: [DefinesCompositionalLayout]) -> UICollectionViewCompositionalLayout {
        // 使用UICollectionViewCompositionalLayout(sectionProvider:)展開如下
        return UICollectionViewCompositionalLayout { [weak self] (section, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let strongSelf = self else { return nil }
            let eachSection = layoutSections[section]
            
            //assumes that collection view's width is the same as view controller's view's width
            //if this is not the case, you will have to get the collection view's width through other means
            let availableWidth: CGFloat = layoutEnvironment.container.effectiveContentSize.width
            
            //get the compositional layout option from the enum
            let compositionalLayout = eachSection.layoutInfo(using: layoutEnvironment)
            
            //we'll start by figuring out the size of each cell
            let cellLayoutSize: NSCollectionLayoutSize
            
            //if cell has minimum width requirements, then we need to calculate the available space and distribute the cells accordingly
            switch compositionalLayout {
            case .minWidthDynamicHeight(let minWidth, let estimatedHeight):
                cellLayoutSize = strongSelf.determineCellLayoutSize(availableWidth: availableWidth,
                                                                    minWidth: minWidth,
                                                                    estimatedOrFixedHeight: estimatedHeight,
                                                                    fixedDimensions: false,
                                                                    layoutEnvironment: layoutEnvironment,
                                                                    compositionalSection: eachSection)
                
            case .minWidthFixedHeight(let minWidth, let fixedHeight):
                cellLayoutSize = strongSelf.determineCellLayoutSize(availableWidth: availableWidth,
                                                                    minWidth: minWidth,
                                                                    estimatedOrFixedHeight: fixedHeight,
                                                                    fixedDimensions: true,
                                                                    layoutEnvironment: layoutEnvironment,
                                                                    compositionalSection: eachSection)
            default:
                cellLayoutSize = NSCollectionLayoutSize(with: compositionalLayout)
            }
            
            //assumes that each group is going to take the entire screen horizontally
            let groupLayoutSize = NSCollectionLayoutSize.init(widthDimension: .fractionalWidth(1.0), heightDimension: cellLayoutSize.heightDimension)
            
            let groupLayout: NSCollectionLayoutGroup
            
            if cellLayoutSize.widthDimension.isFractionalWidth {
                //if we are using fractional width, we need to specify number of items per row because
                //according to the doc, group layout uses this logic to lay the items out
                //Specifies a group that will have N items equally sized along the horizontal axis.
                //use interItemSpacing to insert space between items
                let numberOfItemsPerGroup = Int(round(CGFloat(1) / cellLayoutSize.widthDimension.dimension))
                
                
                let subItemInGroup = NSCollectionLayoutItem(layoutSize: cellLayoutSize)
                groupLayout = NSCollectionLayoutGroup.horizontal(layoutSize: groupLayoutSize,
                                                                 subitem: subItemInGroup,
                                                                 count: numberOfItemsPerGroup)
            } else {
                //if we are using absolute or estimate width, then we can use this instead
                // Specifies a group that will repeat items until available horizontal space is exhausted.
                // note: any remaining space after laying out items can be apportioned among flexible interItemSpacing definitions
                groupLayout = NSCollectionLayoutGroup.horizontal (
                    layoutSize: groupLayoutSize,
                    subitems: [.init(layoutSize: cellLayoutSize)]
                )
            }
            
            //assumes that spacing in each section will be identical for each cell within that section
            groupLayout.interItemSpacing = .fixed(eachSection.interItemSpacing)
            
            let sectionLayoutSize = NSCollectionLayoutSection(group: groupLayout)
            sectionLayoutSize.contentInsets = eachSection.sectionInsets(layoutEnvironment: layoutEnvironment)
            sectionLayoutSize.interGroupSpacing = eachSection.interGroupSpacing
            return sectionLayoutSize
        }
    }
    /// determines the layout size of each cell heuristically if there is a minimum width requirements
    private func determineCellLayoutSize(availableWidth: CGFloat, minWidth: CGFloat, estimatedOrFixedHeight: CGFloat, fixedDimensions: Bool, layoutEnvironment: NSCollectionLayoutEnvironment, compositionalSection: DefinesCompositionalLayout) -> NSCollectionLayoutSize {
        //get the content insets of the view, if any
        let viewContentInset: UIEdgeInsets = view.safeAreaInsets
        
        //this logic is using heuristics. In reality, interitem spacing is only needed n-1 times.
        //in other words, if you place n cells in a row, then you only need interitem spacing for n-1 times.
        //however, that makes the calculations complicated because you will have to perform at least 2 passes to figure out the exact
        //placement of each cell.
        
        //we simply calcualte the available space that can be used for cell placement and determine how many cells can fit
        let cellWidthInteritemSpacingIncluded = Int(minWidth + compositionalSection.interItemSpacing)
        let sectionContentInset = compositionalSection.sectionInsets(layoutEnvironment: layoutEnvironment)
        let usableWidthForCellLayout = availableWidth - (viewContentInset.left + viewContentInset.right) - (sectionContentInset.leading + sectionContentInset.trailing)
        
        let numberOfCellsThatWouldFitTheScreen = CGFloat(Int(usableWidthForCellLayout) / cellWidthInteritemSpacingIncluded)
        
        if Int(numberOfCellsThatWouldFitTheScreen) <= 1 {
            //if we end up with zero cells, then make the cell take the entire space
            if fixedDimensions {
                return NSCollectionLayoutSize(with: .fullWidthFixedHeight(fixedHeight: estimatedOrFixedHeight))
            } else {
                return NSCollectionLayoutSize(with: .fullWidthDynamicHeight(estimatedHeight: estimatedOrFixedHeight))
            }
        } else {
            //if we can fit more than one cell, then divide the available space evenly for each cell
            let fractionOfScreen = CGFloat(1) / numberOfCellsThatWouldFitTheScreen
            if fixedDimensions {
                return NSCollectionLayoutSize(with: .fractionalWidthFixedHeight(fractionalWidth: fractionOfScreen, fixedHeight: estimatedOrFixedHeight))
            } else {
                return NSCollectionLayoutSize(with: .fractionalWidthDynamicHeight(fractionalWidth: fractionOfScreen, estimatedHeight: estimatedOrFixedHeight))
            }
        }
    }
}
