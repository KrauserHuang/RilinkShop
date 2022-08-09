//
//  TopPageViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/7/21.
//

import UIKit

// fileprivate extension TopPageViewController {
//    enum Section: Int, CaseIterable {
//        case store
//        case option
//        case package
//        case all
//    }
// }

class TopPageViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    enum Section: String, CaseIterable {
        case store
//        case option
        case package
//        case all
    }

    enum TopPageDataType: Hashable {
        case store(Store)
        case option(String)
        case package(Package)
    }

    var stores = [Store]()
    var packages = [Package]()
    let optionImages = ["新車", "二手車", "維修保養", "機車租賃", "精品配件"]

    typealias DataSource = UICollectionViewDiffableDataSource<Section, TopPageDataType>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, TopPageDataType>

    private lazy var dataSource = configureDataSource()

    private var sections = Section.allCases

    var account = MyKeyChain.getAccount() ?? ""
    var password = MyKeyChain.getPassword() ?? ""

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
        updateSnapshot()
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
//        collectionView.dataSource = storeDataSource
        collectionView.delegate = self
//        collectionView.collectionViewLayout = createStoreScrollLayout()

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
            self.updateSnapshot()
        }
    }
    // MARK: - Load package API
    func loadPackage() {
        ProductService.shared.loadPackageList(id: account,
                                              pwd: password) { packagesResponse in
            let wholePackages = packagesResponse
            self.packages = wholePackages
            self.updateSnapshot()
        }
    }
}
extension TopPageViewController {
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
        snapshot.appendSections(sections)
//        sections.forEach { section in
//            snapshot.appendItems(<#T##identifiers: [TopPageDataType]##[TopPageDataType]#>, toSection: <#T##Section?#>)
//        }
//        snapshot.appendSections([.all])
//        snapshot.appendItems(stores, toSection: .all)

    }
    func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [unowned self] sectionIndex, _ in
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
