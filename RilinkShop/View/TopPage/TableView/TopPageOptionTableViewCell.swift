//
//  TopPageOptionTableViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/7/22.
//

import UIKit

protocol TopPageOptionTableViewCellDelegate: AnyObject {
    func didTapOption(_ cell: TopPageOptionTableViewCell, option: String)
    func toRepairReservation(_ cell: TopPageOptionTableViewCell)
    func toShop(_ cell: TopPageOptionTableViewCell, producttypeName: String)
}

enum Options: Int, CaseIterable {
    case newCar = 0
    case secondhandCar = 1
    case repair = 2
    case rent = 3
    case accessory = 4
}

extension Options {
    var urlString: String {
        switch self {
        case .newCar:
            return "https://www.hsinhungchia.com/brand-type/"
        case .secondhandCar:
            return "https://rilink.shopstore.tw/category/%E4%B8%AD%E5%8F%A4%E8%BB%8A"
        case .repair:
            return "https://www.hsinhungchia.com/brand-place/"
        case .rent:
            return "https://rilink.shopstore.tw/category/%E7%A7%9F%E8%BB%8A%E6%9C%8D%E5%8B%99"
        case .accessory:
            return "https://rilink.shopstore.tw/"
        }
    }
}

class TopPageOptionTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!

    enum Section: String, CaseIterable {
        case all
    }

    weak var delegate: TopPageOptionTableViewCellDelegate?
    let optionImages = ["新車", "二手車", "維修保養", "機車租賃", "精品配件"]
    var optionDidPicked = Options.newCar

    typealias OptionDataSource = UICollectionViewDiffableDataSource<Section, String>
    typealias OptionSnapshot = NSDiffableDataSourceSnapshot<Section, String>

    private lazy var optionDataSource = configureOptionDataSource()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCollectionView() {
        let optionNib = UINib(nibName: TopPageOptionCollectionViewCell.reuseIdentifier, bundle: nil)
        collectionView.register(optionNib, forCellWithReuseIdentifier: TopPageOptionCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = optionDataSource
        collectionView.delegate = self
        collectionView.collectionViewLayout = createOptionImagesLayout()
        collectionView.isScrollEnabled = false
        updateOptionSnapshot()
    }

}
extension TopPageOptionTableViewCell {
    // MARK: - Option DiffableDataSource/Snapshot/Compositional Layout
    func configureOptionDataSource() -> OptionDataSource {
        let dataSource = OptionDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopPageOptionCollectionViewCell.reuseIdentifier, for: indexPath) as! TopPageOptionCollectionViewCell

//            cell.imageView.image = UIImage(named: itemIdentifier)
//            cell.optionLabel.text = itemIdentifier
            cell.configure(with: itemIdentifier)

            return cell
        }
        return dataSource
    }
    func updateOptionSnapshot(animatingChange: Bool = false) {
        var snapshot = OptionSnapshot()
        snapshot.appendSections([.all])
        snapshot.appendItems(optionImages, toSection: .all)

        optionDataSource.apply(snapshot, animatingDifferences: animatingChange)
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

extension TopPageOptionTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var urlString = ""
        switch indexPath.row {
        case 0:
            optionDidPicked = .newCar
            urlString = optionDidPicked.urlString
            delegate?.didTapOption(self, option: urlString)
        case 1:
            optionDidPicked = .secondhandCar
            urlString = optionDidPicked.urlString
            delegate?.didTapOption(self, option: urlString)
        case 2:
            optionDidPicked = .repair
            delegate?.toRepairReservation(self)
        case 3:
            optionDidPicked = .rent
            delegate?.toShop(self, producttypeName: "i租車")
        default:
            optionDidPicked = .accessory
            delegate?.toShop(self, producttypeName: "改裝精品配件")
        }
//        urlString = optionDidPicked.urlString
//        delegate?.didTapOption(self, option: urlString)
    }
}
