//
//  MyOrderTableViewController.swift
//  Rilink
//
//  Created by 王璽權 on 2022/1/11.
//

import UIKit

class MyOrderTableViewController: UITableViewController {
    
    var orders = [Order]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getOrder()
    }

    private func getOrder() {
        OrderService.shared.getECOrderList { ordersResponse in
            self.orders = ordersResponse
        }
    }
    
    private func configureUI() {
        tableView.register(MyOrderTableViewCell.nib, forCellReuseIdentifier: MyOrderTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyOrderTableViewCell.reuseIdentifier) as! MyOrderTableViewCell

        let order = orders[indexPath.row]
        cell.set(with: order)
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

extension MyOrderTableViewController: MyOrderTableViewCellDelegate {
    func didTapDetailButton(_ cell: MyOrderTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let order = orders[indexPath.row]
        let controller = OrderDetailViewController()
        controller.order = order
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func payImmediate(_ cell: MyOrderTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let orderNo = orders[indexPath.row].orderNo
        let controller = WKWebViewController()
        controller.delegate = self
        controller.title = "行動支付"
        controller.urlStr = PAYMENT_API_URL + orderNo
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension MyOrderTableViewController: WKWebViewControllerDelegate {
    func backAction(_ viewController: WKWebViewController) {
        navigationController?.popToRootViewController(animated: true)
    }
}
