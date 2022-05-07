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

    @IBOutlet weak var shoppingcartButton: UIButton!
    @IBOutlet weak var anotherCartButton: UIBarButtonItem!
    @IBOutlet weak var anouncementLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBAction func instructAvtion(_ sender: UIButton) {
    }
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
    @IBOutlet weak var ticketCollectionView: UICollectionView!
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Package>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Package>
    
    private var nftImages = (1...10).map { "DoodleIcons-\($0)" }
    
    private lazy var dataSource = configureDataSource()
    let badgeSize: CGFloat = 15
    let badgeTag = 123456
    var packages = [Package]() {
        didSet {
            DispatchQueue.main.async {
                self.ticketCollectionView.reloadData()
            }
        }
    }
    
    // 購物車按鈕
    lazy var cartButton: UIButton =  {
        var button = UIButton()
//        button.backgroundColor = .systemBlue
//        button.tintColor  = .white
//        button.setImage(UIImage(systemName: "cart"), for: .normal)
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
        
        promotionsBottomView.backgroundColor = .clear
        
        image1.layer.cornerRadius = 20
        image2.layer.cornerRadius = 20
        image3.layer.cornerRadius = 20
        
        makeViewRoundEdgeAndAddShadow(obj: activity1BV)
        makeViewRoundEdgeAndAddShadow(obj: activity2BV)
        makeViewRoundEdgeAndAddShadow(obj: activity3BV)

        hostelScrollView.isPagingEnabled = true
        hostelScrollView.showsHorizontalScrollIndicator = false
        // setup all collectionView
        ticketCollectionView.register(UINib(nibName: TopPageShopCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: TopPageShopCollectionViewCell.reuseIdentifier)
        ticketCollectionView.dataSource = dataSource
        ticketCollectionView.delegate = self
        ticketCollectionView.collectionViewLayout = createGridLayout()
        loadPackage()
//        updateSnapshot()
        
//        addShoppingCart()
//        NSLayoutConstraint.activate([
//            shoppingcartButton.widthAnchor.constraint(equalToConstant: 44),
//            shoppingcartButton.heightAnchor.constraint(equalToConstant: 44)
//        ])
        
        // Badge method1
//        showBadge(withCount: 5)
        // Badge method2
//        anotherCartButton.addBadge(number: 5)
        anotherCartButton.setBadge()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        labelUI()
        self.tabBarController?.hidesBottomBarWhenPushed = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func addShoppingCart() {
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "cart"), style: .plain, target: self, action: #selector(toCartTVC))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cartButton)
        //添加购物车
        cartButton.addSubview(amountLabel)
        navigationController?.navigationBar.addSubview(amountLabel)
        navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    func labelUI() {
        amountLabel.frame = CGRect(x: 0, y: 0, width: 40, height: 20)
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12),
            amountLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10.5)
        ])
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
    
    func loadPackage() {
        ProductService.shared.loadPackageList(id: "0910619306", pwd: "a12345678") { packagesResponse in
            self.packages = packagesResponse
            self.updateSnapshot()
        }
    }
    
    @IBAction func toHostelPage(_ sender: Any) {
        print("進入商店頁面")
        let controller = HostelDetailViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Badge method1
//    func badgeLabel(withCount count: Int) -> UILabel {
//        let badgeCount = UILabel(frame: CGRect(x: 0, y: 0, width: badgeSize, height: badgeSize))
//        badgeCount.translatesAutoresizingMaskIntoConstraints = false
//        badgeCount.tag = badgeTag
//        badgeCount.layer.cornerRadius = badgeCount.bounds.size.width / 2
//        badgeCount.textAlignment = .center
//        badgeCount.layer.masksToBounds = true
//        badgeCount.textColor = .white
//        badgeCount.font = badgeCount.font.withSize(12)
//        badgeCount.backgroundColor = .systemRed
//        badgeCount.text = String(count)
//        return badgeCount
//    }
//
//    func showBadge(withCount count: Int) {
//        let badge = badgeLabel(withCount: count)
//        shoppingcartButton.addSubview(badge)
//
//        NSLayoutConstraint.activate([
//            badge.leftAnchor.constraint(equalTo: shoppingcartButton.leftAnchor, constant: 30),
//            badge.topAnchor.constraint(equalTo: shoppingcartButton.topAnchor, constant: 4),
//            badge.widthAnchor.constraint(equalToConstant: badgeSize),
//            badge.heightAnchor.constraint(equalToConstant: badgeSize)
//        ])
//    }
//
//    func removeBadge() {
//        if let badge = shoppingcartButton.viewWithTag(badgeTag) {
//            badge.removeFromSuperview()
//        }
//    }
    
//    @IBAction func toCartVC(_ sender: UIButton) {
//        let cartVC = CartViewController()
//        navigationController?.pushViewController(cartVC, animated: true)
//    }
    // MARK: - Badge method2
    @IBAction func toCartVC(_ sender: UIBarButtonItem) {
        let cartVC = CartViewController()
        navigationController?.pushViewController(cartVC, animated: true)
    }
}
// MARK: - UICollectionViewDelegate
extension TopPageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
//        let controller = ShopViewController()
//        let controller = ShopLocationTableViewController()
        let controller = ProductDetailViewController()
        navigationController?.pushViewController(controller, animated: true)
//        let package = packages[indexPath.item]
//        let packageDetailVC = PackageDetailViewController()
//        packageDetailVC.package = package
//        navigationController?.pushViewController(packageDetailVC, animated: true)
    }
}
// MARK: - DataSource/Snapshot/CompositionalLayout
extension TopPageViewController {
    // data source
    func configureDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: ticketCollectionView) { collectionView, indexPath, package -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopPageShopCollectionViewCell.reuseIdentifier, for: indexPath) as! TopPageShopCollectionViewCell
            cell.configure(with: package)
//            cell.imageView.image = UIImage(named: imageName)
            
            return cell
        }
        return dataSource
    }
    // snapshot
    func updateSnapshot(animatingChange: Bool = false) {
        var snapshot = Snapshot()
        snapshot.appendSections([.all])
        snapshot.appendItems(packages, toSection: .all)
        
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

//extension TopPageViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let sideSize = (traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular) ? 80.0 : 128.0
//        return CGSize(width: sideSize, height: sideSize)
//    }
//}
