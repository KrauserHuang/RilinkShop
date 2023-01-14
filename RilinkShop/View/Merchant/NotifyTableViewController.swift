//
//  NotifyTableViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2023/1/9.
//

import UIKit

class NotifyTableViewController: UITableViewController {
    
    var messages = [NotifyViewModel]()
    private var adminAccount: String!
    private var adminPassword: String!
    private var storeID: String!
    
    init(adminAccount: String, adminPassword: String, storeID: String) {
        super.init(nibName: nil, bundle: nil)
        self.adminAccount = adminAccount
        self.adminPassword = adminPassword
        self.storeID = storeID
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: NotifyTableViewCell.reuseIdentifier, for: indexPath) as! NotifyTableViewCell
        
        cell.set(with: message)

        return cell
    }
}
