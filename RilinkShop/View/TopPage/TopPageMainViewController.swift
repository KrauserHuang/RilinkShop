//
//  TopPageMainViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/7/13.
//

import UIKit
import BadgeHub

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
    var optionDidPicked = Options.newCar

    typealias StoreDataSource = UICollectionViewDiffableDataSource<Section, Store>
    typealias StoreSnapshot = NSDiffableDataSourceSnapshot<Section, Store>
    typealias OptionDataSource = UICollectionViewDiffableDataSource<Section, String>
    typealias OptionSnapshot = NSDiffableDataSourceSnapshot<Section, String>
    typealias PackageDataSource = UICollectionViewDiffableDataSource<Section, Package>
    typealias PackageSnapshot = NSDiffableDataSourceSnapshot<Section, Package>

    private lazy var storeDataSource = configureStoreDataSource()
    private lazy var optionDataSource = configureOptionDataSource()
    private lazy var packageDataSource = configurePackageDataSource()

//    var account = MyKeyChain.getAccount() ?? ""
//    var password = MyKeyChain.getPassword() ?? ""

    var currentIndex = 0
    var timer: Timer?
    private var hub: BadgeHub?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()

        print("TopPageMainViewController " + #function)
        print("GlobalAccount:\(Global.ACCOUNT)")
        print("GlobalPassword:\(Global.ACCOUNT_PASSWORD)")
        print("-----------------------------------")
        print("MyKeychainAccount:\(MyKeyChain.getAccount())")
        print("MyKeychainPassword:\(MyKeyChain.getPassword())")
        print("-----------------------------------")
        print("UserServiceAccount:\(UserService.shared.id)")
        print("UserServicePassword:\(UserService.shared.pwd)")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.hidesBottomBarWhenPushed = false
        tabBarController?.tabBar.isHidden = false

//        updateStoreSnapshot()
//        updateOptionSnapshot()
//        updatePackageSnapshot()
//        initUI()
//        configureCollectionView()
        loadStore()
        loadPackage()

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
        configureCollectionView()
//        loadData()
        loadStore()
        loadPackage()

    }

    func navigationItems() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LOGO")
        imageView.contentMode = .scaleAspectFit

        let leftNavigationItem = UIBarButtonItem(customView: imageView)
        navigationItem.leftBarButtonItem = leftNavigationItem

        let shoppingcartButton = UIBarButtonItem(image: UIImage(systemName: "cart"),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(toCartViewController))
//        hub = BadgeHub(view: imageView)
//        hub?.moveCircleBy(x: -15, y: 15)
//        hub?.setCount(2)
        navigationItem.rightBarButtonItem = shoppingcartButton
//        hub = BadgeHub(barButtonItem: navigationItem.rightBarButtonItem!)
////        hub?.moveCircleBy(x: -15, y: 15)
//        hub?.setCount(2)
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

    func loadData() {
        HUD.showLoadingHUD(inView: self.view, text: "")
        let queueGroup = DispatchGroup()
        queueGroup.enter()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            StoreService.shared.getStoreList(id: Global.ACCOUNT,
                                             pwd: Global.ACCOUNT_PASSWORD) { storesResponse in
                let wholeStores = storesResponse
                self.stores = wholeStores
                queueGroup.leave()
            }
            queueGroup.enter()
            ProductService.shared.loadPackageList(id: Global.ACCOUNT,
                                                  pwd: Global.ACCOUNT_PASSWORD) { packagesResponse in
                let wholePackages = packagesResponse
                self.packages = wholePackages
                queueGroup.leave()
            }
        }
        HUD.hideLoadingHUD(inView: self.view)

        queueGroup.notify(queue: DispatchQueue.main) {

            self.updateStoreSnapshot()
            self.updatePackageSnapshot()
        }
    }

    func loadPackage() {
//        HUD.showLoadingHUD(inView: self.view, text: "")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            ProductService.shared.loadPackageList(id: MyKeyChain.getAccount() ?? UserService.shared.id,
                                                  pwd: MyKeyChain.getPassword() ?? UserService.shared.pwd) { packagesResponse in
                let wholePackages = packagesResponse
                self.packages = wholePackages
                self.updatePackageSnapshot()
            }
        }
//        HUD.hideLoadingHUD(inView: self.view)
    }
    func loadStore() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            StoreService.shared.getStoreList(id: MyKeyChain.getAccount() ?? UserService.shared.id,
                                             pwd: MyKeyChain.getPassword() ?? UserService.shared.pwd) { storesResponse in
                let wholeStores = storesResponse
                self.stores = wholeStores
                self.updateStoreSnapshot()
            }
        }
    }
}

extension TopPageMainViewController {
    // MARK: - Store DiffableDataSource/Snapshot/Compositional Layout
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
    func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(260.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)

        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }
    // MARK: - Option DiffableDataSource/Snapshot/Compositional Layout
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
        item.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 10, bottom: 12, trailing: 10)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 5)

        let section = NSCollectionLayoutSection(group: group)
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
            var urlString = ""
            switch indexPath.row {
            case 0:
//                optionDidPicked = .newCar
                let vc = QRCodeViewController()
                present(vc, animated: true, completion: nil)
            case 1:
                optionDidPicked = .secondhandCar
            case 2:
                optionDidPicked = .repair
            case 3:
                optionDidPicked = .rent
            default:
                optionDidPicked = .accessory
            }
            urlString = optionDidPicked.urlString
            print("urlString:\(urlString)")
            let wkWebVC = MainPageWebViewController()
//            wkWebVC.delegate = self
            wkWebVC.urlStr = urlString
            navigationController?.pushViewController(wkWebVC, animated: true)
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
