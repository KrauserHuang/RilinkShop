//
//  TopPageViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/7/21.
//

import UIKit

//fileprivate extension TopPageViewController {
//    enum Section: Int, CaseIterable {
//        case store
//        case option
//        case package
//        case all
//    }
//}

class TopPageViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    enum Section: String, CaseIterable {
        case all
    }
    
    enum TopPageDataType: Hashable {
        case store(Store)
        case option(String)
        case package(Package)
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
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, TopPageDataType>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, TopPageDataType>
    
    private lazy var storeDataSource = configureStoreDataSource()
    private lazy var optionDataSource = configureOptionDataSource()
    private lazy var packageDataSource = configurePackageDataSource()
    private lazy var dataSource = configureDataSource()
    
    let account = MyKeyChain.getAccount() ?? ""
    let password = MyKeyChain.getPassword() ?? ""
    
    var currentIndex = 0
    var timer: Timer?
    
    var storeSection: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        return section
    }
    
    var optionSection: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 10, bottom: 20, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 5)
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    var packageSection: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(260.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStoreSnapshot()
//        updatePackageSnapshot()
//        updateOptionSnapshot()
    }
    
    func initUI() {
        loadStore()
        loadPackage()
        configureCollectionView()
    }
    // MARK: - Regist/DataSource/Delegate/Compositional Layout setting
    func configureCollectionView() {
        let storeNib = UINib(nibName: TopPageStoreCollectionViewCell.reuseIdentifier, bundle: nil)
        collectionView.register(storeNib, forCellWithReuseIdentifier: TopPageStoreCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = storeDataSource
        collectionView.delegate = self
        collectionView.collectionViewLayout = createStoreScrollLayout()
        
        let packageNib = UINib(nibName: TopPagePackageCollectionViewCell.reuseIdentifier, bundle: nil)
        collectionView.register(packageNib, forCellWithReuseIdentifier: TopPagePackageCollectionViewCell.reuseIdentifier)
//        collectionView.dataSource = packageDataSource
//        collectionView.delegate = self
//        collectionView.collectionViewLayout = createPackageGridLayout()
        
        let optionNib = UINib(nibName: TopPageOptionCollectionViewCell.reuseIdentifier, bundle: nil)
        collectionView.register(optionNib, forCellWithReuseIdentifier: TopPageOptionCollectionViewCell.reuseIdentifier)
//        collectionView.dataSource = optionDataSource
//        collectionView.delegate = self
//        collectionView.collectionViewLayout = createOptionImagesLayout()
//        collectionView.isScrollEnabled = false
//        updateOptionSnapshot()
        
    }
    // MARK: - Load store API
    func loadStore() {
        StoreService.shared.getStoreList(id: account,
                                         pwd: password) { storesResponse in
            let wholeStores = storesResponse
            self.stores = wholeStores
            self.updateStoreSnapshot()
        }
    }
    // MARK: - Load package API
    func loadPackage() {
        ProductService.shared.loadPackageList(id: account,
                                              pwd: password) { packagesResponse in
            let wholePackages = packagesResponse
            self.packages = wholePackages
            self.updatePackageSnapshot()
        }
    }
}
extension TopPageViewController {
    // MARK: - Store DiffableDataSource/Snapshot/Compositional Layout
    func configureStoreDataSource() -> StoreDataSource {
        let dataSource = StoreDataSource(collectionView: collectionView) { collectionView, indexPath, store in
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
    // MARK: - Package DiffableDataSource/Snapshot/Compositional Layout
    func configurePackageDataSource() -> PackageDataSource {
        let dataSource = PackageDataSource(collectionView: collectionView) { collectionView, indexPath, package in
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
    func createPackageGridLayout() -> UICollectionViewLayout {
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
    // MARK: - Option DiffableDataSource/Snapshot/Compositional Layout
    func configureOptionDataSource() -> OptionDataSource {
        let dataSource = OptionDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
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
        item.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 10, bottom: 20, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 5)
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    // MARK: - All DiffableDataSource/Snapshot/Compositional Layout
    func configureDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .store(let store):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopPageStoreCollectionViewCell.reuseIdentifier, for: indexPath) as! TopPageStoreCollectionViewCell
                 cell.configure(with: store)
                 return cell
            case .option(let option):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopPageOptionCollectionViewCell.reuseIdentifier, for: indexPath) as! TopPageOptionCollectionViewCell
                cell.imageView.image = UIImage(named: option)
                cell.optionLabel.text = option
                 return cell
            case .package(let package):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopPagePackageCollectionViewCell.reuseIdentifier, for: indexPath) as! TopPagePackageCollectionViewCell
                cell.configure(with: package)
                return cell
            }
        }
        return dataSource
    }
    func updateSnapshot(animatingChange: Bool = false) {
        var snapshot = Snapshot()
        snapshot.appendSections([.all])
        
    }
    func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [unowned self] sectionIndex, environment in
            switch sectionIndex {
            case 0:
                return self.storeSection
            case 1:
                return self.optionSection
            case 2:
                return self.packageSection
            default:
                return nil
            }
//            if sectionIndex == 0 {
//                return self.storeSection
//            } else if sectionIndex == 1 {
//                return self.optionSection
//            } else {
//                return self.packageSection
//            }
        }
    }
}

extension TopPageViewController: UICollectionViewDelegate {
    
}
