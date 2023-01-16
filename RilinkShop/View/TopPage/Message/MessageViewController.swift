//
//  MessageViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/10/21.
//

import UIKit
import SnapKit

struct Message: Hashable {
    let title: String
    let description: String
    let date: String
}

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

    typealias DataSource = UITableViewDiffableDataSource<Section, Message>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Message>

    private lazy var dataSource = configureDataSource()

//    var messages: [Message] = [] {
//        didSet {
//            updateSnapshot()
//        }
//    }

//    var messages: [Message] = [
//        Message(title: "1", description: "String1", date: "123"),
//        Message(title: "2", description: "String2", date: "234"),
//        Message(title: "3", description: "String3", date: "345")
//    ]

    var messages: [Message] = [
        Message(title: "10月生日禮", description: "10月份壽星您好，祝福您天天愉快，贈送您十點點數", date: "2022-09-10 24:00"),
        Message(title: "信息標題", description: "信息內容", date: "發布時間"),
        Message(title: "信息標題1", description: "信息內容2", date: "發布時間3")
    ]
    
    var histories: [History] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        updateSnapshot()
    }
    
    private func fetchHistory() {
        NotificationService.shared.pushMsgGetHistory(id: Global.ACCOUNT, pwd: Global.ACCOUNT_PASSWORD) { success, response in
            guard success else {
                return
            }
            
            let histories = response as! [History]
            self.histories = histories
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
        snapshot.appendItems(messages, toSection: .all)

        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}

extension MessageViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
