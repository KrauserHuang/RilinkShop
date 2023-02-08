//
//  StoreMainViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/7/13.
//

import UIKit
import DropDown
import SnapKit

class StoreMainViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var storeTypeButton: UIButton!

    enum Section: String, CaseIterable {
        case all
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Store>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Store>
    private lazy var dataSource = configureDataSource()

    let typePicker = StorePicker()
    let toolBar = UIToolbar()
    var types = [StoreTypeCellModel]()
    var stores = [Store]()
    var sortedStores = [Store]() {
        didSet {
            updateSnapshot(on: sortedStores)
        }
    }
    var id = String()
    var filteredStores = [Store]() {
        didSet {
            updateSnapshot(on: filteredStores)
        }
    }

    let dropDown = DropDown()

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        HUD.showLoadingHUD(inView: view, text: "")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            HUD.hideLoadingHUD(inView: self.view)
            if self.id == "1" {
                self.sortedStores.removeAll()
                for store in self.stores {
                    if store.storeType == self.id {
                        self.sortedStores.append(store)
                        self.storeTypeButton.setTitle(store.storeTypeName, for: .normal)
                    }
                }
            } else {
                return
            }
        }
    }

    private func initUI() {
        configureCollectionView()
        loadStoreType()
        loadStore()
        configurStorePicker()
        configureSearchController()
    }

    private func configurStorePicker() {
        typePicker.toolBarDelegate = self
        typePicker.delegate = self
        typePicker.selectRow(0, inComponent: 0, animated: false)
    }

    private func configureCollectionView() {
        collectionView.register(StoreCollectionViewCell.nib, forCellWithReuseIdentifier: StoreCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.collectionViewLayout = createGridLayout()
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "請填入要搜尋的店家"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }

    private func loadStoreType() {
//        StoreService.shared.getStoreType(id: LocalStorageManager.shared.getData(String.self, forKey: .userIdKey)!,
//                                         pwd: LocalStorageManager.shared.getData(String.self, forKey: .userPasswordKey)!) { responseTypes in
        StoreService.shared.getStoreType(id: MyKeyChain.getAccount() ?? "",
                                         pwd: MyKeyChain.getPassword() ?? "") { responseTypes in
            var isFirstType = true
            let sortedTypes = responseTypes.sorted { $0.updateTime > $1.updateTime }
            self.types = sortedTypes.map {
                if isFirstType {
                    isFirstType = false
                    return StoreTypeCellModel(type: $0, isSelected: true)
                } else {
                    return StoreTypeCellModel(type: $0)
                }
            }
            if let firstType = self.types.first {
                self.storeTypeButton.setTitle(firstType.type.name, for: .normal)
            }
            self.loadStore()
        }
    }

    private func loadStore() {
//        StoreService.shared.getStoreList(id: LocalStorageManager.shared.getData(String.self, forKey: .userIdKey)!,
//                                         pwd: LocalStorageManager.shared.getData(String.self, forKey: .userPasswordKey)!) { responseStores in
        StoreService.shared.getStoreList(id: MyKeyChain.getAccount() ?? "",
                                         pwd: MyKeyChain.getPassword() ?? "") { responseStores in
            self.stores.removeAll()
            self.stores = responseStores
            self.sortedStores = self.stores.filter { store in
                store.storeType == self.types.first?.type.id
            }
        }
    }
    @IBAction func storeTypeButtonTapped(_ sender: UIButton) {
        var typeModels = [StoreTypeCellModel]()
        var typeModelNames = [String]()
        var typeNames = [String]()
        for type in types {
            typeModels.append(type)
            typeNames.append(type.type.name)
        }
        for typeModel in typeModels {
            typeModelNames.append(typeModel.type.name)
        }
        dropDown.dataSource = typeModelNames
        dropDown.anchorView = storeTypeButton // drop down list會顯示在所設定的view下(這裡指button)
        dropDown.bottomOffset = CGPoint(x: 0, y: storeTypeButton.frame.size.height) // 依據anchorView的bottom位置插入drop down list
        dropDown.show() // 設定完內容跟位置後要執行顯示
        dropDown.selectionAction = { [weak self] (_: Int, item: String) in // 8
            guard let self = self else { return }
            self.storeTypeButton.setTitle(item, for: .normal) // 點選對應的drop down list item要做什麼
            self.sortedStores.removeAll()
            for store in self.stores {
                if store.storeTypeName == item {
                    self.sortedStores.append(store)
                }
            }
        }
    }
    @objc func doneButtonTapped(_ sender: UIBarButtonItem) {
        typePicker.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.snp.bottom)
        }

        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.typePicker.removeFromSuperview()
            self.toolBar.removeFromSuperview()
        }
    }
}
// MARK: - DataSource/Snapshot/CompositionalLayout
extension StoreMainViewController {
    func configureDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreCollectionViewCell.reuseIdentifier, for: indexPath) as! StoreCollectionViewCell

            cell.configure(with: itemIdentifier)

            return cell
        }
        return dataSource
    }
    
    func updateSnapshot(on stores: [Store], animated: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.all])
        snapshot.appendItems(stores, toSection: .all)

        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(280.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)

        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
// MARK: - UICollectionViewDelegate
extension StoreMainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let store = dataSource.itemIdentifier(for: indexPath) else { return }
//        let vc = HostelDetailViewController(account: LocalStorageManager.shared.getData(String.self, forKey: .userIdKey)!,
//                                            password: LocalStorageManager.shared.getData(String.self, forKey: .userPasswordKey)!)
        let vc = HostelDetailViewController()
        vc.store = store
        vc.fixmotor = store.fixmotor
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension StoreMainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text?.lowercased(), !filter.isEmpty else {
            updateSnapshot(on: sortedStores, animated: true)
            return
        }
        
        filteredStores = sortedStores.filter { $0.storeName.lowercased().contains(filter) }
    }
}
// MARK: - StorePickerDelegate本身(調用done的動作，點下去要做下收的動畫)
extension StoreMainViewController: StorePickerDelegate {
    func didTapDone(_ picker: StorePicker) {
        picker.snp.remakeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.top.equalTo(view.snp.bottom)
        }

        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            picker.removeFromSuperview()
        }
    }
}
// MARK: - UIPickerViewDelegate/DataSource
extension StoreMainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return types[row].type.name
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 點選對應type更改storeTypeButton UI
        let typeName = types[row].type.name
        storeTypeButton.setTitle(typeName, for: .normal)

        sortedStores.removeAll()
        for store in stores {
            if store.storeType == types[row].type.id {
                sortedStores.append(store)
            }
        }
    }
}
