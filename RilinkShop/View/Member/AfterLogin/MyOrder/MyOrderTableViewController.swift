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
    let account = Global.ACCOUNT
    let password = Global.ACCOUNT_PASSWORD

    override func viewDidLoad() {
        super.viewDidLoad()

        getOrder()

        tableView.rowHeight = 130

        tableView.register(UINib(nibName: "MyOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "myOrderTableViewCell")
    }

    func getOrder() {
        OrderService.shared.getECOrderList(id: account, pwd: password) { ordersResponse in
            self.orders = ordersResponse
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "myOrderTableViewCell") as! MyOrderTableViewCell

        cell.delegate = self

        let order = orders[indexPath.row]
        cell.set(with: order)

        cell.closure = {
            let orderDetailVC = OrderDetailViewController()
            orderDetailVC.order = order
            orderDetailVC.orderNo = order.orderNo
            self.navigationController?.pushViewController(orderDetailVC, animated: true)
        }
        return cell
    }
}

extension MyOrderTableViewController: MyOrderTableViewCellDelegate {
    func payImmediate(_ cell: MyOrderTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let orderNo = self.orders[indexPath.row].orderNo
        let controller = WKWebViewController()
        controller.delegate = self
        controller.title = "行動支付"
        controller.urlStr = PAYMENT_API_URL + "\(orderNo)"
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension MyOrderTableViewController: WKWebViewControllerDelegate {
    func backAction(_ viewController: WKWebViewController) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
