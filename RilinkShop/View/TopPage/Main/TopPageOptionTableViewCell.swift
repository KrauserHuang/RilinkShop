//
//  TopPageOptionTableViewCell.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/7/22.
//

import UIKit

class TopPageOptionTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    enum Section: String, CaseIterable {
        case all
    }
    
    let optionImages = ["新車", "二手車", "維修保養", "機車租賃", "精品配件"]
    
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

extension TopPageOptionTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("點到我了")
    }
}
