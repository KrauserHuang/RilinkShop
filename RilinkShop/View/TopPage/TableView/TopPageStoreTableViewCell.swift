//
//  TopPageStoreTableViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/7/22.
//

import UIKit

protocol TopPageStoreTableViewCellDelegate: AnyObject {
    func didTapStore(_ cell: TopPageStoreTableViewCell, store: Store)
    func didTapBanner(_ cell: TopPageStoreTableViewCell, banner: Banner)
}

class TopPageStoreTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!

    enum Section: String, CaseIterable {
        case all
    }

    weak var delegate: TopPageStoreTableViewCellDelegate?
    var stores = [Store]()
    var bannerList = [Banner]()

    typealias StoreDataSource = UICollectionViewDiffableDataSource<Section, Store>
    typealias StoreSnapshot = NSDiffableDataSourceSnapshot<Section, Store>
    typealias BannerDataSource = UICollectionViewDiffableDataSource<Section, Banner>
    typealias BannerSnapshot = NSDiffableDataSourceSnapshot<Section, Banner>

    private lazy var storeDataSource = configureStoreDataSource()
    private lazy var bannerDataSource = configureBannerDataSource()

    var account = MyKeyChain.getAccount() ?? ""
    var password = MyKeyChain.getPassword() ?? ""

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        loadStore()

        loadBannerList()
        configureCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCollectionView() {
        let storeNib = UINib(nibName: TopPageStoreCollectionViewCell.reuseIdentifier, bundle: nil)
        collectionView.register(storeNib, forCellWithReuseIdentifier: TopPageStoreCollectionViewCell.reuseIdentifier)
//        collectionView.dataSource = storeDataSource
        collectionView.dataSource = bannerDataSource
        collectionView.delegate = self
        collectionView.collectionViewLayout = createStoreScrollLayout()
    }

    func loadStore() {
        StoreService.shared.getStoreList(id: account,
                                         pwd: password) { storesResponse in
            let wholeStores = storesResponse
            self.stores = wholeStores
            self.updateStoreSnapshot()
        }
    }

    func loadBannerList() {
        BannerService.shared.getBannerList(id: account,
                                           pwd: password) { success, response in
            guard success else {
                let errorMsg = response as! String
//                Alert.showMessage(title: "", msg: errorMsg, vc: self)
                print("error:\(errorMsg)")
                return
            }

            let bannerList = response as! [Banner]
            self.bannerList = bannerList
            self.updateBannerSnapshot()
        }
    }
}

extension TopPageStoreTableViewCell {
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

        storeDataSource.apply(snapshot, animatingDifferences: animatingChange)
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

    private func configureBannerDataSource() -> BannerDataSource {
        let dataSource = BannerDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let item = collectionView.dequeueReusableCell(withReuseIdentifier: TopPageStoreCollectionViewCell.reuseIdentifier, for: indexPath) as! TopPageStoreCollectionViewCell

            item.configure(with: itemIdentifier)

            return item
        }
        return dataSource
    }

    private func updateBannerSnapshot(animatingChange: Bool = false) {
        var snapshot = BannerSnapshot()
        snapshot.appendSections([.all])
        snapshot.appendItems(bannerList, toSection: .all)

        bannerDataSource.apply(snapshot, animatingDifferences: animatingChange)
    }
}

extension TopPageStoreTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let store = stores[indexPath.item]
//        delegate?.didTapStore(self, store: store)

        let banner = bannerList[indexPath.item]
        delegate?.didTapBanner(self, banner: banner)
    }
}
