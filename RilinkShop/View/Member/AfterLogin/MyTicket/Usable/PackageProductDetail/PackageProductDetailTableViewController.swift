//
//  PackageProductDetailTableViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/16.
//

import UIKit

class PackageProductDetailTableViewController: UITableViewController {
    
    var products = [PackageProduct]() //為了取用商品資訊(商品名稱、qrCode字串)
    var ticket = QRCode() //為了顯示部分套票的資訊(購買日期、訂單號碼)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: PackageProductDetailTableViewCell.reuseIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: PackageProductDetailTableViewCell.reuseIdentifier)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PackageProductDetailTableViewCell.reuseIdentifier, for: indexPath) as! PackageProductDetailTableViewCell
        
        let product = products[indexPath.row]
        cell.configure(with: product)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let product = products[indexPath.row]
        let controller = TicketDetailViewController()
        controller.product = product //傳商品資訊
        controller.ticket = ticket //傳套票資訊
        navigationController?.pushViewController(controller, animated: true)
    }
}
