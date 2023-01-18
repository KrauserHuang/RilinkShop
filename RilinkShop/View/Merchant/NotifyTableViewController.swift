//
//  NotifyTableViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2023/1/9.
//

import UIKit

class NotifyTableViewController: UITableViewController {
    
    var messages = [AdminHistory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("messages:\(messages)")
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
