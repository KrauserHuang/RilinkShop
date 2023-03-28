//
//  OrderDetailViewController.swift
//  Rilink
//
//  Created by 王璽權 on 2022/1/11.
//

import UIKit

class OrderDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var order: Order!
    var orderInfos = [OrderInfo]()
    var products = [List]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getList()
    }

    private func getList() {
        OrderService.shared.getECOrderInfo(no: order.orderNo) { listResponse in

            if let products = listResponse.first?.productList,
               let packages = listResponse.first?.packageList {
                self.products = products + packages
            }
            self.orderInfos = listResponse
            
            print("listResponse:\(listResponse)")
        }
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(NewOrderStatusCell.self, forCellReuseIdentifier: NewOrderStatusCell.reuseIdentifier)
        tableView.register(OrderInvoiceStatusCell.self, forCellReuseIdentifier: OrderInvoiceStatusCell.reuseIdentifier)
        tableView.register(NewOrderInfoCell.self, forCellReuseIdentifier: NewOrderInfoCell.reuseIdentifier)
        tableView.register(NewOrderDetailFooterView.self, forHeaderFooterViewReuseIdentifier: NewOrderDetailFooterView.reuseIdentifier)
    }
}

extension OrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return products.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewOrderStatusCell.reuseIdentifier, for: indexPath) as! NewOrderStatusCell

            guard let orderInfo = orderInfos.first else { return UITableViewCell() }
            cell.configure(with: orderInfo)

            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderInvoiceStatusCell.reuseIdentifier, for: indexPath) as? OrderInvoiceStatusCell else { return UITableViewCell() }
            
            guard let orderInfo = orderInfos.first else { return UITableViewCell() }
            cell.set(with: orderInfo)
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewOrderInfoCell.reuseIdentifier, for: indexPath) as! NewOrderInfoCell

            let product = products[indexPath.row]
            cell.configure(with: product)

            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "購買記錄"
        case 1:
            return "發票資訊"
        case 2:
            return "訂單明細"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 2:
            let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: NewOrderDetailFooterView.reuseIdentifier) as! NewOrderDetailFooterView
            
            footerView.set(with: order)
            
            return footerView
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 2:
            return 100
        default:
            return 0
        }
    }
}
