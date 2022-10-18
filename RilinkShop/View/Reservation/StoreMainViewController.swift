//
//  StoreMainViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/7/13.
//

import UIKit
import DropDown
import SnapKit

struct StoreTypeCellModel: Hashable {
    let type: StoreType
    var isSelected: Bool = false
}

class StoreMainViewController: UIViewController {

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
    var filteredStores = [Store]() {
        didSet {
            updateSnapshot()
        }
    }
    var id = String()
//    var account = MyKeyChain.getAccount() ?? ""
//    var password = MyKeyChain.getPassword() ?? ""
//    let account = Global.ACCOUNT
//    let password = Global.ACCOUNT_PASSWORD
//    let account = UserService.shared.id
//    let password = UserService.shared.pwd

    let dropDown = DropDown()

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
//        print("stores:\(stores)")
//        print("StoreMainViewController " + #function)
//        print("GlobalAccount:\(Global.ACCOUNT)")
//        print("GlobalPassword:\(Global.ACCOUNT_PASSWORD)")
//        print("-----------------------------------")
//        print("KeyChainAccount:\(MyKeyChain.getAccount())")
//        print("KeyChainPassword:\(MyKeyChain.getPassword())")
//        print("-----------------------------------")
//        print("UserServiceAccount:\(UserService.shared.id)")
//        print("UserServicePassword:\(UserService.shared.pwd)")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        HUD.showLoadingHUD(inView: view, text: "")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            HUD.hideLoadingHUD(inView: self.view)
            if self.id == "1" {
                self.filteredStores.removeAll()
                for store in self.stores {
                    if store.storeType == self.id {
                        self.filteredStores.append(store)
                        self.storeTypeButton.setTitle(store.storeTypeName, for: .normal)
                    }
                }
            } else {
                return
            }
        }
    }

    func initUI() {
        navigationItems()
        configureCollectionView()
        loadStoreType()
        loadStoreList()
        configurStorePicker()
    }

    func navigationItems() {
        let shoppingcartButton = UIBarButtonItem(image: UIImage(systemName: "cart"),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(toCartViewController))
        navigationItem.rightBarButtonItem = shoppingcartButton
    }
    @objc private func toCartViewController() {
        let vc = CartViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    func configurStorePicker() {
        typePicker.toolBarDelegate = self
        typePicker.delegate = self
        typePicker.selectRow(0, inComponent: 0, animated: false)
    }

    func configureCollectionView() {
        let nib = UINib(nibName: StoreCollectionViewCell.reuseIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: StoreCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.collectionViewLayout = createGridLayout()
    }

    func loadStoreType() {
        StoreService.shared.getStoreType(id: MyKeyChain.getAccount() ?? UserService.shared.id,
                                         pwd: MyKeyChain.getPassword() ?? UserService.shared.pwd) { responseTypes in
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
            self.loadStoreList()
        }
    }

    func loadStoreList() {
        HUD.showLoadingHUD(inView: self.view, text: "載入店家中")
        StoreService.shared.getStoreList(id: MyKeyChain.getAccount() ?? UserService.shared.id,
                                         pwd: MyKeyChain.getPassword() ?? UserService.shared.pwd) { responseStores in
            HUD.hideLoadingHUD(inView: self.view)
            self.stores.removeAll()
            self.stores = responseStores
            print("stores:\(self.stores)")
            self.filteredStores = self.stores.filter { store in
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
//        print(#function)
//        print("typeModels:\(typeModels)")
//        print("typeNames:\(typeNames)")
//        dropDown.dataSource = typeNames // types裡所有的name
        dropDown.dataSource = typeModelNames
        dropDown.anchorView = storeTypeButton // drop down list會顯示在所設定的view下(這裡指button)
        dropDown.bottomOffset = CGPoint(x: 0, y: storeTypeButton.frame.size.height) // 依據anchorView的bottom位置插入drop down list
        dropDown.show() // 設定完內容跟位置後要執行顯示
        dropDown.selectionAction = { [weak self] (_: Int, item: String) in // 8
            guard let self = self else { return }
            self.storeTypeButton.setTitle(item, for: .normal) // 點選對應的drop down list item要做什麼
            self.filteredStores.removeAll()
            for store in self.stores {
                if store.storeTypeName == item {
                    self.filteredStores.append(store)
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
    // dataSource
    func configureDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreCollectionViewCell.reuseIdentifier, for: indexPath) as! StoreCollectionViewCell

            cell.configure(with: itemIdentifier)

            return cell
        }
        return dataSource
    }
    // snapshot
    func updateSnapshot(animatingChange: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.all])
        snapshot.appendItems(filteredStores, toSection: .all)

        dataSource.apply(snapshot, animatingDifferences: animatingChange)
    }
    // compositional layout
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
        let store = filteredStores[indexPath.item]
        let vc = HostelDetailViewController()
        vc.store = store
        vc.fixmotor = store.fixmotor
        navigationController?.pushViewController(vc, animated: true)
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

        filteredStores.removeAll()
        for store in stores {
            if store.storeType == types[row].type.id {
                filteredStores.append(store)
            }
        }
//        updateSnapshot()
    }
}
