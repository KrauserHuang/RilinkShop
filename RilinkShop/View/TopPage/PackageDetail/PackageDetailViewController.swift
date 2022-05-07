//
//  PackageDetailViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/7.
//

import UIKit

class PackageDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var package = Package()
    var products = [Product]()
    var id = UserService.shared.id
    var pwd = UserService.shared.pwd
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        configureTableView()
    }
    
    func loadPackageInfo() {
        ProductService.shared.loadPackageInfo(id: id, pwd: pwd, no: package.packageNo) { packagesResponse in
            self.products = packagesResponse
        }
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
}

extension PackageDetailViewController: UITableViewDelegate {
    
}

extension PackageDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: PackageDetailNameCell.reuseIdentifier, for: indexPath) as! PackageDetailNameCell
            if let product = products.first {
                cell.configure(with: product)
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: PackageDetailCostCell.reuseIdentifier, for: indexPath) as! PackageDetailCostCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: PackageDetailStepperCell.reuseIdentifier, for: indexPath) as! PackageDetailStepperCell
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: PackageDetailDescriptionCell.reuseIdentifier, for: indexPath) as! PackageDetailDescriptionCell
            return cell
        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
        }
        let cell = UITableViewCell()
        return cell
    }
    
    
}
