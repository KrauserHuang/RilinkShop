//
//  PackageDetailViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/7.
//

import UIKit
import Kingfisher

class PackageDetailViewController: UIViewController {

    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var headerView: PackageDetailHeaderView!
    
    var package = Package()
    var products = [Product]()
    var account = Global.ACCOUNT
    var password = Global.ACCOUNT_PASSWORD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        configureTableView()
//        loadPackageInfo()
        configureTableView()
    }
    
    func loadPackageInfo() {
        ProductService.shared.loadPackageInfo(id: account, pwd: password, no: package.packageNo) { packagesResponse in
//            self.products = packagesResponse
            
            self.headerView.headerImageView.setImage(imageURL: TEST_ROOT_URL + self.package.productPicture)
            
        }
    }
    
    func configureTableView() {
        infoTableView.delegate = self
        infoTableView.dataSource = self
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
//            if let product = products.first {
//                cell.configure(with: product)
//            }
            cell.configure(with: package)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: PackageDetailCostCell.reuseIdentifier, for: indexPath) as! PackageDetailCostCell
//            if let product = products.first {
//                cell.configure(with: product)
//            }
            cell.configure(with: package)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: PackageDetailStepperCell.reuseIdentifier, for: indexPath) as! PackageDetailStepperCell
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: PackageDetailDescriptionCell.reuseIdentifier, for: indexPath) as! PackageDetailDescriptionCell
            if let product = products.first {
                cell.configure(with: product)
            }
            return cell
        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
        }
    }
}
