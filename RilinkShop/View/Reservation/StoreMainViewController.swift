//
//  StoreMainViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/7/13.
//

import UIKit
import DropDown
import SnapKit

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
//    var types = [StoreType]()
    var stores = [Store]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    var filteredStores = [Store]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    let account = MyKeyChain.getAccount() ?? ""
    let password = MyKeyChain.getPassword() ?? ""
    let dropDown = DropDown()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        initUI()
    }
    
    func initUI() {
        navigationItems()
        configureCollectionView()
        loadStoreType()
        loadStoreList()
        updateSnapshot()
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
        HUD.showLoadingHUD(inView: self.view, text: "")
        StoreService.shared.getStoreType(id: account,
                                         pwd: password) { responseTypes in
            HUD.hideLoadingHUD(inView: self.view)
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
        StoreService.shared.getStoreList(id: account,
                                         pwd: password) { responseStores in
            HUD.hideLoadingHUD(inView: self.view)
            self.stores = responseStores
            
            self.filteredStores = self.stores.filter { store in
                store.storeType == self.types.first?.type.id
            }
            print(#function)
            print("stores:\(self.stores)")
            print("++++++++++++++++++++")
            print("filteredStores:\(self.filteredStores)")
            self.updateSnapshot()
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
        print(#function)
        print("typeModels:\(typeModels)")
        print("typeNames:\(typeNames)")
//        dropDown.dataSource = typeNames // types裡所有的name
        dropDown.dataSource = typeModelNames
        dropDown.anchorView = sender // drop down list會顯示在所設定的view下(這裡指button)
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) // 依據anchorView的bottom位置插入drop down list
        dropDown.show() // 設定完內容跟位置後要執行顯示
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
            guard let self = self else { return }
            sender.setTitle(item, for: .normal) // 點選對應的drop down list item要做什麼
            self.filteredStores.removeAll()
            for store in self.stores {
                if store.storeTypeName == item {
                    self.filteredStores.append(store)
                }
            }
            self.updateSnapshot()
        }
        
        //另一作法
//        typePicker.backgroundColor = .white
//        view.addSubview(typePicker)
//
//        toolBar.barStyle = .default
//        toolBar.isTranslucent = true
//        toolBar.tintColor = .black
//        toolBar.sizeToFit()
//
//        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped(_:)))
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        toolBar.setItems([spaceButton, doneButton], animated: false)
//        toolBar.isUserInteractionEnabled = true
//        view.addSubview(toolBar)
//
//        typePicker.snp.makeConstraints { make in
//            make.leading.trailing.bottom.equalTo(self.view)
//        }
//        toolBar.snp.makeConstraints { make in
//            make.leading.trailing.equalTo(typePicker)
//            make.bottom.equalTo(typePicker.snp.top)
//        }
//
//        var typePickerTopConstraint: Constraint?
//        var typePickerBottomConstraint: Constraint?
//        typePicker.snp.makeConstraints { make in
//            make.leading.trailing.equalTo(view)
//            typePickerTopConstraint = make.top.equalTo(view.snp.bottom).constraint
//            typePickerBottomConstraint = make.bottom.equalToSuperview().constraint
//            typePickerTopConstraint?.isActive = true
//            typePickerBottomConstraint?.isActive = false
//        }
//
//        self.view.layoutIfNeeded()
//        UIView.animate(withDuration: 0.25) {
//            typePickerTopConstraint?.isActive = false
//            typePickerBottomConstraint?.isActive = true
//            self.view.layoutIfNeeded()
//        }
        
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
    //dataSource
    func configureDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreCollectionViewCell.reuseIdentifier, for: indexPath) as! StoreCollectionViewCell
            
            cell.configure(with: itemIdentifier)
            
            return cell
        }
        return dataSource
    }
    //snapshot
    func updateSnapshot(animatingChange: Bool = false) {
        var snapshot = Snapshot()
        snapshot.appendSections([.all])
        snapshot.appendItems(filteredStores, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    //compositional layout
    func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(300.0))
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
        //點選對應type更改storeTypeButton UI
        let typeName = types[row].type.name
        storeTypeButton.setTitle(typeName, for: .normal)
        
        filteredStores.removeAll()
        for store in stores {
            if store.storeType == types[row].type.id {
                filteredStores.append(store)
            }
        }
        updateSnapshot()
    }
}
