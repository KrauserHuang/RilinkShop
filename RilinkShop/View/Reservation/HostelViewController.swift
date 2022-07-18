//
//  HostelViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/9.
//

import UIKit

struct StoreTypeCellModel: Hashable {
    let type: StoreType
    var isSelected: Bool = false
}

class HostelViewController: UIViewController {

    @IBOutlet weak var hostelCollectionView: UICollectionView!
    @IBOutlet weak var hostelTableView: UITableView!
    
    var types = [StoreTypeCellModel]() {
        didSet {
            DispatchQueue.main.async {
                self.hostelCollectionView.reloadData()
            }
        }
    }
    var stores = [Store]()
    var filteredStores = [Store]() {
        didSet {
            DispatchQueue.main.async {
                self.hostelTableView.reloadData()
            }
        }
    }
    var fixmotor: String?
    
    let account = MyKeyChain.getAccount() ?? ""
    let password = MyKeyChain.getPassword() ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backButtonTitle = ""
        loadProductType()
        configureCollectionView()
        configureTableView()
    }
    
    func loadProductType() {
        StoreService.shared.getStoreType(id: MyKeyChain.getAccount() ?? "", pwd: MyKeyChain.getPassword() ?? "") { responseTypes in
            var isFirstType = true
            let sortedTypes = responseTypes.sorted { $0.updateTime > $1.updateTime }
            print("sortedTypes:\(sortedTypes)")
            self.types = sortedTypes.map {
                if isFirstType {
                    isFirstType = false
                    return StoreTypeCellModel(type: $0, isSelected: true)
                } else {
                    return StoreTypeCellModel(type: $0)
                }
            }
            print(#function)
            print("responseTypes:\(responseTypes)")
            print("types:\(self.types)")
            StoreService.shared.getStoreList(id: MyKeyChain.getAccount() ?? "", pwd: MyKeyChain.getPassword() ?? "") { responseStores in
                self.stores = responseStores
                self.filteredStores = self.stores.filter { store in
                    store.storeType == self.types.first?.type.id
                }
            }
        }
    }
    
    func configureCollectionView() {
        hostelCollectionView.delegate = self
        hostelCollectionView.dataSource = self
        let nib = UINib(nibName: HostelTypeCollectionViewCell.reuseIdentifier, bundle: nil)
        hostelCollectionView.register(nib, forCellWithReuseIdentifier: HostelTypeCollectionViewCell.reuseIdentifier)
        if let layout = hostelCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }
    
    func configureTableView() {
        hostelTableView.delegate = self
        hostelTableView.dataSource = self
        let nib = UINib(nibName: HostelTableViewCell.reuseIdentifier, bundle: nil)
        hostelTableView.register(nib, forCellReuseIdentifier: HostelTableViewCell.reuseIdentifier)
        hostelTableView.separatorStyle = .none
    }
}
// MARK: - UICollectionViewDelegate/DataSource
extension HostelViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return types.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: HostelTypeCollectionViewCell.reuseIdentifier, for: indexPath) as! HostelTypeCollectionViewCell
        
        let type = types[indexPath.item]
        item.configure(with: type)
        item.isItemSelected = type.isSelected
        
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for (index, _) in types.enumerated() {
            types[index].isSelected = index == indexPath.item
        }
        // filteredStores update
        filteredStores.removeAll()
        for store in stores {
            if store.storeType == types[indexPath.item].type.id {
                filteredStores.append(store)
            }
        }
    }
}
// MARK: - UITableViewDelegate/DataSource
extension HostelViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredStores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HostelTableViewCell.reuseIdentifier, for: indexPath) as! HostelTableViewCell
        
        let store = filteredStores[indexPath.row]
        cell.configure(with: store)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = StoreDetailViewController()
//        let controller = HostelDetailViewController()
        let store = filteredStores[indexPath.row]
        controller.store = store
        controller.fixmotor = store.fixmotor
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
