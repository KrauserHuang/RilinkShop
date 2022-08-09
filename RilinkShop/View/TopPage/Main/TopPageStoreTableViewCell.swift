//
//  TopPageStoreTableViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/7/22.
//

import UIKit

class TopPageStoreTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!

    enum Section: String, CaseIterable {
        case all
    }

    var stores = [Store]()

    typealias StoreDataSource = UICollectionViewDiffableDataSource<Section, Store>
    typealias StoreSnapshot = NSDiffableDataSourceSnapshot<Section, Store>

    private lazy var storeDataSource = configureStoreDataSource()

    var account = MyKeyChain.getAccount() ?? ""
    var password = MyKeyChain.getPassword() ?? ""

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        loadStore()
        configureCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCollectionView() {
        let storeNib = UINib(nibName: TopPageStoreCollectionViewCell.reuseIdentifier, bundle: nil)
        collectionView.register(storeNib, forCellWithReuseIdentifier: TopPageStoreCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = storeDataSource
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
}

extension TopPageStoreTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("被點了")
    }
}
