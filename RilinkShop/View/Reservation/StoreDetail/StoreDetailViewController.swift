//
//  StoreDetailViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/7/13.
//

import UIKit

class StoreDetailViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: StoreDetailHeaderView!
    
    var store = Store()
    var fixmotor: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension StoreDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreDetailMainTextCell.reuseIdentifier, for: indexPath) as? StoreDetailMainTextCell else {
                return UITableViewCell()
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreDetailOpenTimeTextCell.reuseIdentifier, for: indexPath) as? StoreDetailOpenTimeTextCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: store)
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreDetailDescriptTextCell.reuseIdentifier, for: indexPath) as? StoreDetailDescriptTextCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: store)
            
            return cell
        default:
            fatalError("Failed to instantiate the table view cell for store detail view controller")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}
