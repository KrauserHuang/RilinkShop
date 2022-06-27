//
//  OrderDetailViewController.swift
//  Rilink
//
//  Created by 王璽權 on 2022/1/11.
//

import UIKit

class OrderDetailViewController: UIViewController {
    
    @IBOutlet weak var orderDetailTableView: UITableView!
    @IBOutlet weak var footerView: OrderDetailFooterView!
    
    let account = Global.ACCOUNT
    let password = Global.ACCOUNT_PASSWORD
    var order = Order()
    var orderInfos = [OrderInfo]()
    var orderNo: String?
    var products = [List]() {
        didSet {
            DispatchQueue.main.async {
                self.orderDetailTableView.reloadData()
            }
        }
    }
    var products1 = [ProductList]() {
        didSet {
            DispatchQueue.main.async {
                self.orderDetailTableView.reloadData()
            }
        }
    }

    var products2 = [PackageList]() {
        didSet {
            DispatchQueue.main.async {
                self.orderDetailTableView.reloadData()
            }
        }
    }
//    var products = [Product]() {
//        didSet {
//            DispatchQueue.main.async {
//                self.orderDetailTableView.reloadData()
//            }
//        }
//    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderDetailTableView.alwaysBounceVertical = false
        orderDetailTableView.isUserInteractionEnabled = false
        getList()
        configureTableView()
        configureFooterView()
//        print("--------------------")
//        print("orderNo:\(orderNo)")
    }
    
    func getList() {
        OrderService.shared.getECOrderInfo(id: account, pwd: password, no: order.orderNo) { listResponse in
            
            
            if let products = listResponse.first?.productList,
               let packages = listResponse.first?.packageList {
                self.products = products + packages
            }
            self.orderInfos = listResponse
            print("=====測試======")
            print("orderInfos:\(self.orderInfos)")
        }
    }
    
    func configureTableView() {
        orderDetailTableView.delegate = self
        orderDetailTableView.dataSource = self
        let nibStatus = UINib(nibName: OrderStatusCell.reuseIdentifier, bundle: nil)
        let nibInfo = UINib(nibName: ProductInfoCell.reuseIdentifier, bundle: nil)
        orderDetailTableView.register(nibStatus, forCellReuseIdentifier: OrderStatusCell.reuseIdentifier)
        orderDetailTableView.register(nibInfo, forCellReuseIdentifier: ProductInfoCell.reuseIdentifier)
    }
    
    func configureFooterView() {
        footerView.orderAmountLabel.text = order.orderAmount
        footerView.discountAmountLabel.text = order.discountAmount
        footerView.orderPayLabel.text = order.orderPay
    }
}

extension OrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return products.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderStatusCell.reuseIdentifier, for: indexPath) as! OrderStatusCell
            
            guard let orderInfo = orderInfos.first else { return UITableViewCell() }
            cell.configure(with: orderInfo)
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductInfoCell.reuseIdentifier, for: indexPath) as! ProductInfoCell
            
            let product = products[indexPath.row]
            cell.configure(with: product)
            
            return cell
        default:
            return UITableViewCell()
        }
    }
}
