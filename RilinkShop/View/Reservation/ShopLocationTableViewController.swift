//
//  ShopLocationTableViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/26.
//

import UIKit

class ShopLocationTableViewController: UITableViewController {

    @IBOutlet weak var cartButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.register(UINib(nibName: ShopTypeTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ShopTypeTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: ShopTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ShopTableViewCell.reuseIdentifier)
//        cartButton.setBadge()
    }
    
    @IBAction func toCartVC(_ sender: UIBarButtonItem) {
        let cartVC = CartViewController()
        navigationController?.pushViewController(cartVC, animated: true)
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        if section == 0 {
//            return 1
//        } else {
//            return 2
//        }
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ShopTypeTableViewCell.reuseIdentifier, for: indexPath) as! ShopTypeTableViewCell
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: ShopTableViewCell.reuseIdentifier, for: indexPath) as! ShopTableViewCell

            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = HostelDetailViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
