//
//  NewOrderDetailViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2023/2/28.
//

import UIKit

class NewOrderDetailViewController: UIViewController {
    
    enum Section {
        case status
        case info
    }
    
    typealias DataSource = UITableViewDiffableDataSource<Section, List>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, List>
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(NewOrderStatusCell.self, forCellReuseIdentifier: NewOrderStatusCell.reuseIdentifier)
        tv.register(NewOrderInfoCell.self, forCellReuseIdentifier: NewOrderInfoCell.reuseIdentifier)
        tv.register(NewOrderDetailFooterView.self, forHeaderFooterViewReuseIdentifier: NewOrderDetailFooterView.reuseIdentifier)
        tv.allowsSelection = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
}

extension NewOrderDetailViewController {
    private func configureDataSource() -> DataSource {
        let dataSource = DataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: NewOrderInfoCell.reuseIdentifier, for: indexPath) as! NewOrderInfoCell
            
            cell.set(with: itemIdentifier)
            
            return cell
        }
        return dataSource
    }
    
    private func updateSnapshot() {
        
    }
}
