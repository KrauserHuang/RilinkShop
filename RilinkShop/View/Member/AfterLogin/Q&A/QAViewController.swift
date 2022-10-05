//
//  QAViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/9/22.
//

import UIKit

struct QA {
    let title: String
    let content: String
}

class QAViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let qaContents = [
        QA(title: "一.退貨款事宜",
           content: "1.如購買的商品為套票，不接受單退款套票中的某樣商品。\n2.如欲辦理退款，請提供以下資料給客服人員：會員手機號碼/姓名/在\"我的票券\"中，欲辦理退款的\"商品名稱\"與\"訂單編號\"。\n3.辦理退款的前提為，商品QR尚未被核銷，仍留存在票券的\"可使用\"處。\n4.購買商品時，若有使用點數折抵，辦理退款後，恕無法同步退還點數給您。\n5.可接受辦理退款的日期為\"購買日期\"後的7天內提出(不含假日)。"),
        QA(title: "二.誤將QR核銷掉",
           content: "1.請描述原因與提供以下資料給客服人員查詢(會員電話與\"我的訂單\"中的\"訂單編號/日期/金額\")，使人員重新派發商品給您。"),
        QA(title: "三.使用Rilink商城APP的注意事項",
           content: "1.於該平台購買的商品，不會寄出商品給顧客，須請您至該商品對應之門市核銷QR後，才能獲得此商品。\n2.Rilink i機車總共有兩種APP，分別為Rilink(機車租賃平台)與Rilink Shop(商城、預約維修平台..)，兩款APP的會員資料是相通的，點數也可以同步於兩平台中折抵使用。")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
}
extension QAViewController {
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.register(QATableViewCell.self, forCellReuseIdentifier: QATableViewCell.cellIdentifier())
        tableView.register(UINib(nibName: QATableViewCell.cellIdentifier(), bundle: nil),
                           forCellReuseIdentifier: QATableViewCell.cellIdentifier())
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
}
// MARK: - TableView Delegate/DataSource
extension QAViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return qaContents.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(QATableViewCell.self)", for: indexPath) as? QATableViewCell else { return UITableViewCell() }

        let content = qaContents[indexPath.section]
        cell.configure(with: content)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = qaContents[section].title
        return title
    }
}

// class QATableViewCell: UITableViewCell {
//
//    let titleLabel = UILabel()
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        backgroundColor = .clear
//        selectionStyle = .none
//        titleLabel.font = .systemFont(ofSize: 12, weight: .regular)
//        titleLabel.textAlignment = .left
//        titleLabel.textColor = .black
//        titleLabel.numberOfLines = 0
//
//        addSubview(titleLabel)
//
//        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
//            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
//            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
//        ])
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
// }
