//
//  MessageViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/10/21.
//

import UIKit
import SnapKit

class MessageViewController: UIViewController {

    enum Section {
        case all
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MessageTableViewCell.nib, forCellReuseIdentifier: MessageTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    typealias DataSource = UITableViewDiffableDataSource<Section, History>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, History>

    private lazy var dataSource = configureDataSource()
    
    var histories: [History] = [] {
        didSet {
            updateSnapshot()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchHistory()
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.allowsSelection = false
    }
    
    private func fetchHistory() {
        NotificationService.shared.pushMsgGetHistory { success, response in
            guard success else {
                return
            }
            
            let histories = response as! [History]
            let sortedHistories = histories.sorted { $0.push_datetime > $1.push_datetime}
            self.histories = sortedHistories
            
            if histories.isEmpty {
                DispatchQueue.main.async {
                    self.showEmptyStateView(with: "沒有任何訊息", in: self.view)
                }
            }
        }
    }
}

extension MessageViewController {
    private func configureDataSource() -> DataSource {
        let dataSource = DataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.reuseIdentifier, for: indexPath) as! MessageTableViewCell

            cell.configure(with: itemIdentifier)

            return cell
        }
        return dataSource
    }

    private func updateSnapshot(animated: Bool = false) {
        var snapshot = Snapshot()
        snapshot.appendSections([.all])
        snapshot.appendItems(histories, toSection: .all)

        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}

extension MessageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
