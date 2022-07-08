//
//  TopPageViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/6.
//

import UIKit

class TopPageViewController: UIViewController {
    
    enum Section: String, CaseIterable {
        case all
    }
    
    @IBOutlet weak var shoppingcartButton: BadgeBarButtonItem!
    @IBAction func moreActivity(_ sender: UIButton) {
    }
    @IBAction func moreProduct(_ sender: UIButton) {
    }
    @IBOutlet weak var promotionsBottomView: UIView!
    @IBOutlet weak var activity1BV: UIView!
    @IBOutlet weak var activity2BV: UIView!
    @IBOutlet weak var activity3BV: UIView!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    
    @IBOutlet weak var hostelScrollView: UIScrollView!
    @IBOutlet weak var hostelCollectionView: UICollectionView!
    @IBOutlet weak var ticketCollectionView: UICollectionView!
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Package>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Package>
    //items取代packages將package資料傳到商城的詳細頁面
//    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
//    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    private lazy var dataSource = configureDataSource()
    let badgeSize: CGFloat = 15
    let badgeTag = 123456
    let account = MyKeyChain.getAccount() ?? ""
    let password = MyKeyChain.getPassword() ?? ""
    var currentIndex = 1
    var timer: Timer?
    var packages = [Package]() {
        didSet {
            DispatchQueue.main.async {
                self.ticketCollectionView.reloadData()
            }
        }
    }
    //items取代packages將package資料傳到商城的詳細頁面
//    var items = [Item]() {
//        didSet {
//            DispatchQueue.main.async {
//                self.ticketCollectionView.reloadData()
//            }
//        }
//    }
    var stores = [Store]() {
        didSet {
            DispatchQueue.main.async {
                self.hostelCollectionView.reloadData()
            }
        }
    }
    var sortedStores = [Store]() {
        didSet {
            DispatchQueue.main.async {
                self.hostelCollectionView.reloadData()
            }
        }
    }
    
    // 購物車按鈕
    lazy var cartButton: UIButton =  {
        var button = UIButton()
        button.setImage(UIImage(named: "button_cart"), for: .normal)
        button.addTarget(self, action: #selector(toCartTVC), for: .touchUpInside)
        button.sizeToFit()
        return button
    }()
    
    lazy var amountLabel: UILabel = {
        var label = UILabel()
        label.textColor = UIColor.red
        label.backgroundColor = UIColor.white
        label.text = "1"
        label.font = UIFont.systemFont(ofSize: 11)
        // label外圍形狀(紅色圓圈)
        label.textAlignment = .center
        label.layer.cornerRadius = 7.5
        label.layer.masksToBounds = true
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.red.cgColor
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backButtonTitle = ""
        
        configureCollectionView()
        loadStore()
        loadPackage()
        updateSnapshot()
//        anotherCartButton.setBadge()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureCollectionView()
        loadStore()
        loadPackage()
        updateSnapshot()
        
        self.tabBarController?.hidesBottomBarWhenPushed = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // 取消自動輪播，並將index回歸0
        timer?.invalidate()
        currentIndex = 0
    }
    
    func addShoppingCart() {
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "cart"), style: .plain, target: self, action: #selector(toCartTVC))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cartButton)
        //添加购物车
        cartButton.addSubview(amountLabel)
        navigationController?.navigationBar.addSubview(amountLabel)
        navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    @objc func toCartTVC() {
        let cartVC = CartViewController()
        navigationController?.pushViewController(cartVC, animated: true)
    }
    
    func makeViewRoundEdgeAndAddShadow( obj: UIView){
        obj.layer.shadowRadius = 20
        obj.layer.shadowColor = UIColor.black.cgColor
        obj.layer.borderColor = UIColor.clear.cgColor
        obj.layer.borderWidth = 1
        obj.layer.cornerRadius = 20
        obj.layer.shadowOpacity = 0.15
        obj.backgroundColor = .white
    }
    
    func configureCollectionView() {
        // setup all collectionView
        ticketCollectionView.register(UINib(nibName: TopPageShopCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: TopPageShopCollectionViewCell.reuseIdentifier)
        ticketCollectionView.dataSource = dataSource
        ticketCollectionView.delegate = self
        ticketCollectionView.collectionViewLayout = createGridLayout()
        
        let nib = UINib(nibName: HostelCollectionViewCell.reuseIdentifier, bundle: nil)
        hostelCollectionView.register(nib, forCellWithReuseIdentifier: HostelCollectionViewCell.reuseIdentifier)
        hostelCollectionView.delegate = self
        hostelCollectionView.dataSource = self
        hostelCollectionView.isPagingEnabled = true
        
        if let layout = hostelCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.scrollDirection = .horizontal
//            let width = UIScreen.main.bounds.width - 32
//            let width = UIScreen.main.bounds.width
            let width = hostelCollectionView.frame.size.width
            print("---------------")
            print("width:\(width)")
            layout.itemSize = CGSize(width: width, height: 263)
            print("itemSize:\(layout.itemSize)")
        }
        /*
         取出第一個與最後一個store，並將其放入另一個array
         sortedStores = lastStore + stores + firstStore
         */
        guard let firstStore = stores.first,
              let lastStore = stores.last else { return }
//        sortedStores.append(lastStore)
        sortedStores += stores
        sortedStores.append(firstStore)
        
        print(#function)
        print("stores:\(stores.count)")
        print("sorted:\(sortedStores.count)")
        hostelCollectionView.reloadData()
        hostelCollectionView.layoutIfNeeded()
//        hostelCollectionView.setContentOffset(CGPoint(x: CGFloat(UIScreen.main.bounds.width - 32),
//                                                      y: 0), animated: true)
        timer = Timer.scheduledTimer(timeInterval: 2.0,
                                     target: self,
                                     selector: #selector(hostelCollectionViewDidScroll),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func loadPackage() {
        ProductService.shared.loadPackageList(id: MyKeyChain.getAccount() ?? "", pwd: MyKeyChain.getPassword() ?? "") { packagesResponse in
            let wholePackages = packagesResponse
            self.packages = wholePackages
//            for package in self.packages {
//                self.items.append(Item.package(package: package))
//            }
//            print(#function)
//            print("item:\(self.items)")
            self.updateSnapshot()
        }
    }
    func loadStore() {
        StoreService.shared.getStoreList(id: MyKeyChain.getAccount() ?? "", pwd: MyKeyChain.getPassword() ?? "") { storesResponse in
            self.stores = storesResponse
            self.hostelCollectionView.reloadData()
        }
    }
    
    @IBAction func toHostelPage(_ sender: Any) {
        print("進入商店頁面")
        let controller = HostelDetailViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    // MARK: - Badge method2
    @IBAction func toCartVC(_ sender: BadgeBarButtonItem) {
        let cartVC = CartViewController()
        navigationController?.pushViewController(cartVC, animated: true)
    }
    
    // MARK: - 計時器到就執行，更新 hostelCollectionView 的 contentOffset(移到下一個x座標)
    @objc private func hostelCollectionViewDidScroll() {
        var indexPath: IndexPath = IndexPath(item: currentIndex, section: 0)
        if currentIndex < sortedStores.count {
            hostelCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            currentIndex += 1
        } else if currentIndex == sortedStores.count {
            currentIndex = 0
            indexPath = IndexPath(item: currentIndex, section: 0)
            hostelCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
//            hostelCollectionViewDidScroll()
        }
    }
}
// MARK: - UICollectionViewDelegate, Hostel & Ticket
extension TopPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        case hostelCollectionView:
            let store = sortedStores[indexPath.item]
            
//            guard let tabBarController = self.tabBarController else { return }
//            tabBarController.selectedIndex = 2
            
//            let reservationNavigationController = tabBarController.viewControllers?.filter { $0 is ReservationNavigationViewController }.first as? ReservationNavigationViewController
//            reservationNavigationController?.popToRootViewController(animated: false)
            
//            DispatchQueue.main.async {
//                print("--------------------------")
//                print(reservationNavigationController?.viewControllers.count)
//                let hostelDetailViewController = reservationNavigationController?.viewControllers.filter { $0 is HostelDetailViewController }.first as? HostelDetailViewController
//                hostelDetailViewController?.store = store
//                reservationNavigationController?.pushViewController(hostelDetailViewController!, animated: true)
//            }
            
//            if let hostelDetailVC = reservationNavigationController?.viewControllers.compactMap { $0 is HostelDetailViewController }.first as? HostelDetailViewController {
//                hostelDetailVC.store = store
//                reservationNavigationController?.pushViewController(hostelDetailVC, animated: true)
//            }
            let hostelDetailVC = HostelDetailViewController()
            hostelDetailVC.store = store
            hostelDetailVC.fixmotor = store.fixmotor
            navigationController?.pushViewController(hostelDetailVC, animated: true)
        case ticketCollectionView:
            let package = packages[indexPath.item]
            let packageInfoVC = PackageInfoViewController()
//            let packa
            packageInfoVC.package = package
            navigationController?.pushViewController(packageInfoVC, animated: true)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedStores.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HostelCollectionViewCell.reuseIdentifier, for: indexPath) as! HostelCollectionViewCell
        let store = sortedStores[indexPath.item]
        cell.configure(with: store)
        return cell
    }
}
// MARK: - DataSource/Snapshot/CompositionalLayout
extension TopPageViewController {
    // data source
    func configureDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: ticketCollectionView) { collectionView, indexPath, package -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopPageShopCollectionViewCell.reuseIdentifier, for: indexPath) as! TopPageShopCollectionViewCell
            cell.configure(with: package)
//            cell.configure(with: item)
            
            return cell
        }
        return dataSource
    }
    // snapshot
    func updateSnapshot(animatingChange: Bool = false) {
        var snapshot = Snapshot()
        snapshot.appendSections([.all])
        snapshot.appendItems(packages, toSection: .all)
//        snapshot.appendItems(items, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    // compositional layout
    func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(150.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}
