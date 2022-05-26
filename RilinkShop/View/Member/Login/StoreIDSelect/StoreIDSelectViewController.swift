//
//  StoreIDSelectViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/21.
//

import UIKit

protocol StoreIDSelectViewControllerDelegate: AnyObject {
    func didDismissAndPassStoreID(_ viewController: StoreIDSelectViewController, storeIDInfo: StoreIDInfo)
}

class StoreIDSelectViewController: UIViewController {
    
    @IBOutlet weak var storeIDTableView: UITableView!
    
    weak var delegate: StoreIDSelectViewControllerDelegate?
    var storeID = [StoreIDInfo]() {
        didSet {
            DispatchQueue.main.async {
                self.storeIDTableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        getStoreID()
    }
    
    func getStoreID() {
        let storeAcc = "99999"
        let storePwd = "99999"
        HUD.showLoadingHUD(inView: self.view, text: "取得店家資訊中")
        UserService.shared.getStoreIDList(storeAcc: storeAcc, storePwd: storePwd) { success, response in
            DispatchQueue.global(qos: .userInitiated).async {
                URLCache.shared.removeAllCachedResponses()
                DispatchQueue.main.async {
                    HUD.hideLoadingHUD(inView: self.view)
                    
                    guard success else {
                        return
                    }
                    
                    guard let storeIDInfo = response as? [StoreIDInfo] else {
                        print("response downcast fail")
                        return
                    }
                    self.storeID = storeIDInfo
                }
            }
        }
    }
    
    func configureTableView() {
        let nib = UINib(nibName: StoreIDSelectTableViewCell.reuseIdentifier, bundle: nil)
        storeIDTableView.register(nib, forCellReuseIdentifier: StoreIDSelectTableViewCell.reuseIdentifier)
        storeIDTableView.delegate = self
        storeIDTableView.dataSource = self
    }
}

extension StoreIDSelectViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeID.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoreIDSelectTableViewCell.reuseIdentifier, for: indexPath) as! StoreIDSelectTableViewCell
        
        let info = storeID[indexPath.row]
        cell.storeIDInfo = info
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let info = storeID[indexPath.row]
        dismiss(animated: true) {
            self.delegate?.didDismissAndPassStoreID(self, storeIDInfo: info)
        }
    }
}
