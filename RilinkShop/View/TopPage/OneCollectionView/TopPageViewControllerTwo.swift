//
//  TopPageViewControllerTwo.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/7/21.
//

import UIKit

class TopPageViewControllerTwo: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var collectionViewControllers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureTableView()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let storeNib = UINib(nibName: String(describing: TopPageStoreTableViewCell.self), bundle: nil)
        tableView.register(storeNib, forCellReuseIdentifier: String(describing: TopPageStoreTableViewCell.self))
        
        let optionNib = UINib(nibName: String(describing: TopPageOptionTableViewCell.self), bundle: nil)
        tableView.register(optionNib, forCellReuseIdentifier: String(describing: TopPageOptionTableViewCell.self))
        
        let packageNib = UINib(nibName: String(describing: TopPagePackageTableViewCell.self), bundle: nil)
        tableView.register(packageNib, forCellReuseIdentifier: String(describing: TopPagePackageTableViewCell.self))
    }
}

extension TopPageViewControllerTwo: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TopPageStoreTableViewCell.cellIdentifier()), for: indexPath) as! TopPageStoreTableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TopPageOptionTableViewCell.cellIdentifier()), for: indexPath) as! TopPageOptionTableViewCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TopPagePackageTableViewCell.cellIdentifier()), for: indexPath) as! TopPagePackageTableViewCell
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 263
        case 1:
            return 100
        case 2:
            return UITableView.automaticDimension
//            return 400
        default:
            return 0
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        switch section {
//        case 0:
//            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
//
//            let label = UILabel()
//            label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
//            label.text = "活動資訊"
//            label.font = .systemFont(ofSize: 16)
//            label.textColor = .darkGray
//
//            headerView.addSubview(label)
//
//            return headerView
//        case 1:
//            return nil
//        case 2:
//            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
//
//            let label = UILabel()
//            label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
//            label.text = "優惠方案"
//            label.font = .systemFont(ofSize: 16)
//            label.textColor = .darkGray
//
//            headerView.addSubview(label)
//
//            return headerView
//        default:
//            return nil
//        }
//    }
}
