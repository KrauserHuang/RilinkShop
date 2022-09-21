//
//  TopPagePackageTableViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/7/22.
//

import UIKit

protocol TopPagePackageTableViewCellDelegate: AnyObject {
    func didTapPackage(_ cell: TopPagePackageTableViewCell, package: Package)
}

class TopPagePackageTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: DynamicHeightCollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!

    enum Section: String, CaseIterable {
        case all
    }

    weak var delegate: TopPagePackageTableViewCellDelegate?
    var packages = [Package]()

    var collectionViewObserver: NSKeyValueObservation?

    typealias PackageDataSource = UICollectionViewDiffableDataSource<Section, Package>
    typealias PackageSnapshot = NSDiffableDataSourceSnapshot<Section, Package>

    private lazy var packageDataSource = configurePackageDataSource()

    var account = MyKeyChain.getAccount() ?? ""
    var password = MyKeyChain.getPassword() ?? ""

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        loadPackage()
        configureCollectionView()
//        collectionView.isScrollEnabled = false
//        addObserver()
//        layoutIfNeeded()
//        updatePackageSnapshot()
//        collectionViewHeightConstraint.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
//        print(#function)
//        print("collectionView.frame.height:\(collectionView.frame.height)")
        print("collectionView.contentSize.height = \(collectionView.contentSize.height)")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

//    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
////        self.contentView.frame = self.bounds
//
//        self.contentView.layoutIfNeeded()
////        return collectionView.contentSize
//        return collectionView.frame.size
//    }

    func configureCollectionView() {
        let packageNib = UINib(nibName: TopPagePackageCollectionViewCell.reuseIdentifier, bundle: nil)
        collectionView.register(packageNib, forCellWithReuseIdentifier: TopPagePackageCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = packageDataSource
        collectionView.delegate = self
        collectionView.collectionViewLayout = createGridLayout()
//        collectionView.isScrollEnabled = false
    }

    func loadPackage() {
        ProductService.shared.loadPackageList(id: account,
                                              pwd: password) { packagesResponse in
            let wholePackages = packagesResponse
            self.packages = wholePackages
            self.updatePackageSnapshot()
        }
    }

//    func addObserver() {
//        collectionViewObserver = collectionView.observe(\.contentSize,
//                                                        changeHandler: { [weak self] (collectionView, _) in
//            print("collectionView.contentSize.height = \(collectionView.contentSize.height)")
//            self?.collectionView.invalidateIntrinsicContentSize()
//            self?.collectionViewHeightConstraint.constant = collectionView.contentSize.height
//            self?.layoutIfNeeded()
//        })
//    }
//
//    deinit {
//        collectionViewObserver = nil
//    }
}

extension TopPagePackageTableViewCell {
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

        packageDataSource.apply(snapshot, animatingDifferences: animatingChange)
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

extension TopPagePackageTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let package = packages[indexPath.item]
        delegate?.didTapPackage(self, package: package)
    }
//    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
//        self.contentView.frame = self.bounds
//        collectionViewHeightConstraint.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
//        self.contentView.layoutIfNeeded()
//        return collectionView.contentSize
//    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: (UIScreen.main.bounds.width/2)-20, height: 260)
//    }
}

// extension TopPagePackageTableViewCell: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        return CGSize(width: collectionView.frame.size.width/3.5, height: collectionView.frame.size.height/4)
//        return CGSize(width: collectionView.frame.size.width/2, height: 260)
//    }
// }
