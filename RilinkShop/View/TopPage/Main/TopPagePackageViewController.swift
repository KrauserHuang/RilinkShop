//
//  TopPagePackageViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/7/22.
//

import UIKit

class TopPagePackageViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    enum Section: String, CaseIterable {
        case all
    }
    
    var packages = [Package]()
    
    typealias PackageDataSource = UICollectionViewDiffableDataSource<Section, Package>
    typealias PackageSnapshot = NSDiffableDataSourceSnapshot<Section, Package>
    
    private lazy var packageDataSource = configurePackageDataSource()
    
    var account = MyKeyChain.getAccount() ?? ""
    var password = MyKeyChain.getPassword() ?? ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadPackage()
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCollectionView() {
        let packageNib = UINib(nibName: TopPagePackageCollectionViewCell.reuseIdentifier, bundle: nil)
        collectionView.register(packageNib, forCellWithReuseIdentifier: TopPagePackageCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = packageDataSource
        collectionView.delegate = self
        collectionView.collectionViewLayout = createGridLayout()
        
        view.addSubview(collectionView)
    }
    
    func loadPackage() {
        ProductService.shared.loadPackageList(id: account,
                                              pwd: password) { packagesResponse in
            let wholePackages = packagesResponse
            self.packages = wholePackages
            self.updatePackageSnapshot()
        }
    }
}

extension TopPagePackageViewController {
    // MARK: - Package DiffableDataSource/Snapshot
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

extension TopPagePackageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Alert.showMessage(title: "", msg: "我被點了！", vc: self, handler: nil)
    }
}
