//
//  TopPageMainCollectionReusableView.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/9/27.
//

import UIKit

protocol TopPageMainCollectionReusableViewDelegate: AnyObject {
    func didTapNewCar(_ button: UIButton, option: String)
    func didTapSecondhandCar(_ button: UIButton, option: String)
    func didTapRepair(_ button: UIButton)
    func didTapRent(_ button: UIButton, productType: String)
    func didTapAccessory(_ button: UIButton, productType: String)

    func didTapBanner(_ cell: TopPageMainCollectionReusableView, banner: Banner)
}

class TopPageMainCollectionReusableView: UICollectionReusableView {

    enum Section: String, CaseIterable {
        case all
    }

    static let reuseIdentifier = "TopPageMainCollectionReusableView"

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bannerPageControl: UIPageControl!

    weak var delegate: TopPageMainCollectionReusableViewDelegate?
    var bannerList = [Banner]() {
        didSet {
            updateBannerSnapshot()
            bannerPageControl.numberOfPages = bannerList.count
        }
    }
    typealias BannerDataSource = UICollectionViewDiffableDataSource<Section, Banner>
    typealias BannerSnapshot = NSDiffableDataSourceSnapshot<Section, Banner>
    private lazy var bannerDataSource = configureBannerDataSource()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Timer.scheduledTimer(timeInterval: 5,
                             target: self,
                             selector: #selector(scrollBanner),
                             userInfo: nil,
                             repeats: true)
        bannerPageControl.hidesForSinglePage = true
        loadBannerList()
        configureCollectionView()
    }
    @objc func scrollBanner() {
        if bannerPageControl.currentPage == bannerPageControl.numberOfPages - 1 {
            bannerPageControl.currentPage = 0
        } else {
            bannerPageControl.currentPage += 1
        }
        bannerPageControlDidChanged(bannerPageControl)
    }

    func configureCollectionView() {
        let nib = UINib(nibName: String(describing: TopPageStoreCollectionViewCell.self), bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: TopPageStoreCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = bannerDataSource
        collectionView.delegate = self
        collectionView.collectionViewLayout = createStoreScrollLayout()
    }

    func loadBannerList() {
        BannerService.shared.getBannerList(id: MyKeyChain.getAccount() ?? "",
                                           pwd: MyKeyChain.getPassword() ?? "") { success, response in
            guard success else {
                let errorMsg = response as! String
//                Alert.showMessage(title: "", msg: errorMsg, vc: self)
                print("errorMsg:\(errorMsg)")
                return
            }

            let bannerList = response as! [Banner]
            self.bannerList = bannerList
            print("banner:\(self.bannerList)")
        }
    }

    @IBAction func bannerPageControlDidChanged(_ sender: UIPageControl) {
        let indexPath: IndexPath = IndexPath(item: sender.currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath,
                                    at: .centeredHorizontally,
                                    animated: true)
    }

    @IBAction func newCarButtonTapped(_ sender: UIButton) {
        delegate?.didTapNewCar(sender, option: "https://www.hsinhungchia.com/brand-type/")
    }

    @IBAction func secondhandCarButtonTapped(_ sender: UIButton) {
        delegate?.didTapSecondhandCar(sender, option: "https://rilink.shopstore.tw/category/%E4%B8%AD%E5%8F%A4%E8%BB%8A")
    }

    @IBAction func repairButtonTapped(_ sender: UIButton) {
        delegate?.didTapRepair(sender)
    }

    @IBAction func rentButtonTapped(_ sender: UIButton) {
        // 03 -> i租車
//        delegate?.didTapRent(sender, productType: "03")
        delegate?.didTapRent(sender, productType: "Rent")
    }

    @IBAction func accessoryButtonTapped(_ sender: UIButton) {
        // 02 -> 改裝精品配件
//        delegate?.didTapAccessory(sender, productType: "02")
        delegate?.didTapRent(sender, productType: "SC001")
    }
}

extension TopPageMainCollectionReusableView {
    // MARK: - Store DiffableDataSource/Snapshot/Compositional Layout
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
        // 讓CollectionView滑動時同時更新UIPageControl
        section.visibleItemsInvalidationHandler = { [weak self] (_, offset, _) -> Void in
            guard let self = self else { return }
            let page = round(offset.x / self.collectionView.bounds.width)
            // update your paging indicator with the `page` value
            self.bannerPageControl.currentPage = Int(page)
        }

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension TopPageMainCollectionReusableView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let banner = bannerList[indexPath.item]
        delegate?.didTapBanner(self, banner: banner)
    }
}
