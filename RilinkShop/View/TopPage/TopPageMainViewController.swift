//
//  TopPageMainViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/7/13.
//

import UIKit

class TopPageMainViewController: UIViewController {

    @IBOutlet weak var storeCollectionView: UICollectionView!
    @IBOutlet weak var packageCollectionView: UICollectionView!
    @IBOutlet weak var optionCollectionView: UICollectionView!
    
    enum Section: String, CaseIterable {
        case all
    }
    
    var stores = [Store]()
    var packages = [Package]()
    let optionImages = ["新車", "二手車", "維修保養", "機車租賃", "精品配件"]
    
    typealias StoreDataSource = UICollectionViewDiffableDataSource<Section, Store>
    typealias StoreSnapshot = NSDiffableDataSourceSnapshot<Section, Store>
    typealias OptionDataSource = UICollectionViewDiffableDataSource<Section, String>
    typealias OptionSnapshot = NSDiffableDataSourceSnapshot<Section, String>
    typealias PackageDataSource = UICollectionViewDiffableDataSource<Section, Package>
    typealias PackageSnapshot = NSDiffableDataSourceSnapshot<Section, Package>
    
    private lazy var storeDataSource = configureStoreDataSource()
    private lazy var optionDataSource = configureOptionDataSource()
    private lazy var packageDataSource = configurePackageDataSource()
    
    let account = MyKeyChain.getAccount() ?? ""
    let password = MyKeyChain.getPassword() ?? ""
    
    var currentIndex = 0
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.hidesBottomBarWhenPushed = false
        tabBarController?.tabBar.isHidden = false
        
        timer = Timer.scheduledTimer(timeInterval: 3.0,
                                     target: self,
                                     selector: #selector(storeCollectionViewAutoScroll),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 輪播Banner計時歸0
        timer?.invalidate()
        currentIndex = 0
    }
    
    func initUI() {
        navigationItems()
        loadStore()
        loadPackage()
        configureCollectionView()
    }
    
    func navigationItems() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LOGO")
        imageView.contentMode = .scaleAspectFit
        
        let leftNavigationItem = UIBarButtonItem(customView: imageView)
        navigationItem.leftBarButtonItem = leftNavigationItem
        
//        let cartImageView = UIImageView()
//        cartImageView.image = UIImage(systemName: "cart")
//        cartImageView.contentMode = .scaleAspectFit
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
    
    func configureCollectionView() {
        let storeNib = UINib(nibName: TopPageStoreCollectionViewCell.reuseIdentifier, bundle: nil)
        storeCollectionView.register(storeNib, forCellWithReuseIdentifier: TopPageStoreCollectionViewCell.reuseIdentifier)
        storeCollectionView.dataSource = storeDataSource
        storeCollectionView.delegate = self
        storeCollectionView.collectionViewLayout = createStoreScrollLayout()
        
        let packageNib = UINib(nibName: TopPagePackageCollectionViewCell.reuseIdentifier, bundle: nil)
        packageCollectionView.register(packageNib, forCellWithReuseIdentifier: TopPagePackageCollectionViewCell.reuseIdentifier)
        packageCollectionView.dataSource = packageDataSource
        packageCollectionView.delegate = self
        packageCollectionView.collectionViewLayout = createGridLayout()
        
        let optionNib = UINib(nibName: TopPageOptionCollectionViewCell.reuseIdentifier, bundle: nil)
        optionCollectionView.register(optionNib, forCellWithReuseIdentifier: TopPageOptionCollectionViewCell.reuseIdentifier)
        optionCollectionView.dataSource = optionDataSource
        optionCollectionView.delegate = self
        optionCollectionView.collectionViewLayout = createOptionImagesLayout()
        optionCollectionView.isScrollEnabled = false
        updateOptionSnapshot()
    }
    @objc private func storeCollectionViewAutoScroll() {
        var indexPath: IndexPath = IndexPath(item: currentIndex, section: 0)
        if currentIndex < stores.count {
            storeCollectionView.scrollToItem(at: indexPath,
                                             at: .centeredHorizontally,
                                             animated: true)
            currentIndex += 1
        } else if currentIndex == stores.count {
            currentIndex = 0
            indexPath = IndexPath(item: currentIndex, section: 0)
            storeCollectionView.scrollToItem(at: indexPath,
                                             at: .centeredHorizontally,
                                             animated: false)
        }
    }
    
    func loadPackage() {
        ProductService.shared.loadPackageList(id: account,
                                              pwd: password) { packagesResponse in
            let wholePackages = packagesResponse
            self.packages = wholePackages
            self.updatePackageSnapshot()
        }
    }
    func loadStore() {
        StoreService.shared.getStoreList(id: account,
                                         pwd: password) { storesResponse in
            let wholeStores = storesResponse
            self.stores = wholeStores
            self.updateStoreSnapshot()
        }
    }
}

extension TopPageMainViewController {
    // MARK: - Store DiffableDataSource/Snapshot
    func configureStoreDataSource() -> StoreDataSource {
        let dataSource = StoreDataSource(collectionView: storeCollectionView) { collectionView, indexPath, store in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopPageStoreCollectionViewCell.reuseIdentifier, for: indexPath) as! TopPageStoreCollectionViewCell
            
            cell.configure(with: store)
            
            return cell
        }
        return dataSource
    }
    func updateStoreSnapshot(animatingChange: Bool = false) {
        var snapshot = StoreSnapshot()
        snapshot.appendSections([.all])
        snapshot.appendItems(stores, toSection: .all)
        
        storeDataSource.apply(snapshot, animatingDifferences: false)
    }
    // MARK: - Package DiffableDataSource/Snapshot
    func configurePackageDataSource() -> PackageDataSource {
        let dataSource = PackageDataSource(collectionView: packageCollectionView) { collectionView, indexPath, package in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopPagePackageCollectionViewCell.reuseIdentifier, for: indexPath) as! TopPagePackageCollectionViewCell
            
            cell.configure(with: package)
            
            return cell
        }
        return dataSource
    }
    func updatePackageSnapshot(animatingChange: Bool = false) {
        var snapshot = PackageSnapshot()
        snapshot.appendSections([.all])
        snapshot.appendItems(packages, toSection: .all)
        
        packageDataSource.apply(snapshot, animatingDifferences: false)
    }
    // MARK: - Store Compositional Layout
    func createStoreScrollLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    // MARK: - Package Compositional Layout
    func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(260.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .continuous
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    // MARK: - Option
    func configureOptionDataSource() -> OptionDataSource {
        let dataSource = OptionDataSource(collectionView: optionCollectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopPageOptionCollectionViewCell.reuseIdentifier, for: indexPath) as! TopPageOptionCollectionViewCell
            
            cell.imageView.image = UIImage(named: itemIdentifier)
            cell.optionLabel.text = itemIdentifier
            
            return cell
        }
        return dataSource
    }
    func updateOptionSnapshot(animatingChange: Bool = false) {
        var snapshot = OptionSnapshot()
        snapshot.appendSections([.all])
        snapshot.appendItems(optionImages, toSection: .all)
        
        optionDataSource.apply(snapshot, animatingDifferences: false)
    }
    func createOptionImagesLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 5)
        
        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .continuous
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

// MARK: - UICollectionViewDelegate
extension TopPageMainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case storeCollectionView:
            let store = stores[indexPath.item]
            let hostelDetailVC = HostelDetailViewController()
            hostelDetailVC.store = store
            hostelDetailVC.fixmotor = store.fixmotor
            navigationController?.pushViewController(hostelDetailVC, animated: true)
        case optionCollectionView:
            Alert.showSecurityAlert(title: "", msg: "敬請期待", vc: self, handler: nil)
        case packageCollectionView:
            let package = packages[indexPath.item]
            let packageInfoVC = PackageInfoViewController()
            packageInfoVC.package = package
            navigationController?.pushViewController(packageInfoVC, animated: true)
        default:
            break
        }
    }
}
