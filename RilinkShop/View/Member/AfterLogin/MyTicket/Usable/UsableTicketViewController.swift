//
//  UsableTicketViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/10.
//

import UIKit

class UsableTicketViewController: UIViewController {

    @IBOutlet weak var tableViiew: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    var tickets = [QRCode]() {
        didSet {
            DispatchQueue.main.async {
                self.tableViiew.reloadData()
            }
        }
    }
    var sortedTickets = [QRCode]() {
        didSet {
            DispatchQueue.main.async {
                self.tableViiew.reloadData()
            }
        }
    }
    let account = MyKeyChain.getAccount() ?? ""
    let password = MyKeyChain.getPassword() ?? ""
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViiew.rowHeight = 124
        tableViiew.register(UINib(nibName: "UsableTableViewCell", bundle: nil), forCellReuseIdentifier: "UsableTableViewCell")
        tableViiew.delegate = self
        tableViiew.dataSource = self
//        tableViiew.allowsSelection = false
        
        tableViiew.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        
        getTicket()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTicket()
    }
    
    func getTicket() {
        QRCodeService.shared.unconfirmList(id: MyKeyChain.getAccount() ?? "", pwd: MyKeyChain.getPassword() ?? "", ispackage: "0") { productResponse in
            QRCodeService.shared.unconfirmList(id: MyKeyChain.getAccount() ?? "", pwd: MyKeyChain.getPassword() ?? "", ispackage: "1") { packageResponse in
//                let wholeProducts = productResponse
//                let wholePackages = packageResponse
//                for package in wholePackages {
//                    print(#function)
//                    print(package)
//                    pack
//                }
                
                self.tickets = productResponse + packageResponse
                self.sortedTickets = self.tickets.sorted(by: { ticket1, ticket2 in
                    ticket1.orderDate > ticket2.orderDate
                })
//                print(#function)
//                print("----------------------")
//                print("ticket:\(self.tickets)")
//                print("----------------------")
//                print("sortedticket:\(self.sortedTickets)")
//                print("----------------------")
//                self.emptyView.isHidden = self.tickets.count != 0
                self.emptyView.isHidden = self.sortedTickets.count != 0
            }
        }
    }
    
    @objc func refreshList() {
        self.refreshControl.beginRefreshing()
        QRCodeService.shared.unconfirmList(id: account, pwd: password, ispackage: "0") { productResponse in
            QRCodeService.shared.unconfirmList(id: self.account, pwd: self.password, ispackage: "1") { packageResponse in
                self.tickets = productResponse + packageResponse
                self.sortedTickets = self.tickets.sorted(by: { ticket1, ticket2 in
                    ticket1.orderDate > ticket2.orderDate
                })
                if self.sortedTickets.count != 0 {
                    self.refreshControl.endRefreshing()
                    self.tableViiew.reloadData()
                } else {
                    self.refreshControl.endRefreshing()
                    self.tableViiew.reloadData()
                }
            }
        }
    }
}

extension UsableTicketViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedTickets.count
//        return tickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsableTableViewCell",for: indexPath) as! UsableTableViewCell
        
//        let ticket = tickets[indexPath.row]
        let ticket = sortedTickets[indexPath.row]
        cell.configure(with: ticket)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
//        let ticket = tickets[indexPath.row]
        let ticket = sortedTickets[indexPath.row]
        if ticket.storeID != nil {
            // 如果有storeID則已經是商品，可直接進去可核銷QRCode頁面
            let controller = TicketDetailViewController()
//            let ticketWithQR = ticket.product?.filter({ $0.qrconfirm != nil })
//            controller.ticket = ticketWithQR
            controller.ticket = ticket
            navigationController?.pushViewController(controller, animated: true)
        } else {
            // 如果沒有storeID代表他是套票，應該先跳轉套票所涵蓋商品內容
            let controller = PackageProductDetailTableViewController()
            controller.ticket = ticket
            if let ticketProduct = ticket.product {
                let ticketProductWithQR = ticketProduct.filter { $0.qrconfirm != nil }
                print(#function)
                print(ticket)
                print("====================")
                print(ticketProduct)
                print("====================")
                print(ticketProductWithQR)
                controller.products = ticketProductWithQR
            } else {
                print("ticket.product is nil!")
            }
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
