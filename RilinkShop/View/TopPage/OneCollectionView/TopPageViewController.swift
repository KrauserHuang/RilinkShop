//
//  TopPageViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/7/21.
//

import UIKit
import SafariServices

class TopPageViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    enum Section: String, CaseIterable {
        case all
    }

    enum Constants {
        static let badgeElementKind = "badge-element-kind"
        static let headerElementKind = "header-element-kind"
        static let footerElementKind = "footer-element-kind"
    }

    var packages = [Package]()
    let optionImages = ["新車", "二手車", "維修保養", "機車租賃", "精品配件"]

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Package>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Package>

    private lazy var dataSource = configureDataSource()

    var account = MyKeyChain.getAccount() ?? ""
    var password = MyKeyChain.getPassword() ?? ""

    var currentIndex = 0
    var timer: Timer?

    var bannerList = [Banner]()
    var products = [Product]()
    var filterItmes = [Item]()
    var items = [Item]()

    let notificationCenter = NotificationCenter.default

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()

//        let notificationName = Notification.Name.hereComesTheProductType

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSnapshot()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        notificationCenter.removeObserver(self)
    }
}
// MARK: - internal functions
extension TopPageViewController {
    func initUI() {
        navigationItems()
        loadPackage()
        configureCollectionView()
    }
    func configureCollectionView() {

        let packageNib = UINib(nibName: TopPagePackageCollectionViewCell.reuseIdentifier, bundle: nil)
        collectionView.register(packageNib, forCellWithReuseIdentifier: TopPagePackageCollectionViewCell.reuseIdentifier)
        // 註冊supplementaryView
        let nib = UINib(nibName: String(describing: TopPageMainCollectionReusableView.self), bundle: nil)
        collectionView.register(nib,
                                forSupplementaryViewOfKind: Constants.headerElementKind,
                                withReuseIdentifier: TopPageMainCollectionReusableView.reuseIdentifier)

        collectionView.dataSource = dataSource
//        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = createLayout()
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
    // MARK: - Load banner API
    func loadBanner() {
        BannerService.shared.getBannerList(id: account,
                                           pwd: password) { success, response in
            guard success else {
                let errorMsg = response as! String
                Alert.showMessage(title: "", msg: errorMsg, vc: self)
                return
            }

            let bannerList = response as! [Banner]
            self.bannerList = bannerList
        }
    }
}

extension TopPageViewController {
    // 設定左上logo右上購物車
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
        navigationItem.rightBarButtonItem = shoppingcartButton
    }
    @objc private func toCartViewController() {
        let vc = CartViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension TopPageViewController {
    // MARK: - DiffableDataSource/Snapshot/Compositional Layout
    func configureDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let item = collectionView.dequeueReusableCell(withReuseIdentifier: TopPagePackageCollectionViewCell.reuseIdentifier, for: indexPath) as! TopPagePackageCollectionViewCell

            item.configure(with: itemIdentifier)

            return item
        }
        dataSource.supplementaryViewProvider = { [weak self] (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            if kind == Constants.headerElementKind {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: TopPageMainCollectionReusableView.reuseIdentifier,
                                                                             for: indexPath) as! TopPageMainCollectionReusableView
                headerView.delegate = self
                return headerView
            } else {
                return UICollectionReusableView()
            }
        }

        return dataSource
    }
    func updateSnapshot(animatingChange: Bool = false) {
        var snapshot = Snapshot()
        snapshot.appendSections([.all])
        snapshot.appendItems(packages, toSection: .all)

        dataSource.apply(snapshot, animatingDifferences: animatingChange)
    }
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(260.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                heightDimension: .absolute(440))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: Constants.headerElementKind,
                                                                 alignment: .top)
        header.pinToVisibleBounds = false

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]

        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }

    private func createBannerItem() -> NSCollectionLayoutSupplementaryItem {
        let topRightAnchor = NSCollectionLayoutAnchor(edges: [.top, .trailing], fractionalOffset: CGPoint(x: 0.2, y: -0.2))
        let itemLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                heightDimension: .absolute(260))
        let item = NSCollectionLayoutSupplementaryItem(layoutSize: itemLayoutSize, elementKind: TopPageMainCollectionReusableView.reuseIdentifier, containerAnchor: topRightAnchor)
        return item
    }

    func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {

        switch kind {
        case TopPageMainCollectionReusableView.reuseIdentifier:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: TopPageMainCollectionReusableView.reuseIdentifier,
                                                                        withReuseIdentifier: TopPageMainCollectionReusableView.reuseIdentifier,
                                                                        for: indexPath) as! TopPageMainCollectionReusableView

            return headerView

        default:
            assertionFailure("Handle new kind")
            return nil
        }
    }
}

extension TopPageViewController: TopPageMainCollectionReusableViewDelegate {

    func didTapBanner(_ cell: TopPageMainCollectionReusableView, banner: Banner) {
        if let url = URL(string: banner.bannerLink) {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
    }

    func didTapNewCar(_ button: UIButton, option: String) {
        if let url = URL(string: option) {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
    }

    func didTapSecondhandCar(_ button: UIButton, option: String) {
        if let url = URL(string: option) {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
    }

    func didTapRepair(_ button: UIButton, id: String) {
        let reservationStoryboard = UIStoryboard(name: "Reservation", bundle: nil)
        let vc = reservationStoryboard.instantiateViewController(withIdentifier: "StoreMainViewController") as! StoreMainViewController
        vc.id = id
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func didTapRent(_ button: UIButton, productType: String) {
        let shopStoryboard = UIStoryboard(name: "Shop", bundle: nil)
        let vc = shopStoryboard.instantiateViewController(withIdentifier: "ShopMainViewController") as! ShopMainViewController
        vc.productType = productType

        /*
        let notificationName = Notification.Name.hereComesTheProductType
        // Custom data, for sending productType for the API
        let forwardProductType: [String: String] = ["productType": productType]

        notificationCenter.post(name: notificationName,
                                object: button,
                                userInfo: forwardProductType)
        */
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func didTapAccessory(_ button: UIButton, productType: String) {
        let shopStoryboard = UIStoryboard(name: "Shop", bundle: nil)
        let vc = shopStoryboard.instantiateViewController(withIdentifier: "ShopMainViewController") as! ShopMainViewController
        vc.productType = productType

        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension TopPageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: TopPageMainCollectionReusableView.reuseIdentifier,
                                                                         for: indexPath)
            return header
        } else {
            return UICollectionReusableView()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let size = CGSize(width: view.frame.size.width, height: 263)
        return size
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PackageInfoViewController()
        let package = packages[indexPath.row]
        vc.package = package
        navigationController?.pushViewController(vc, animated: true)
    }
}
