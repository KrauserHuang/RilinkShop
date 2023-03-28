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
    
    enum Section {
        case main
    }
    
    private lazy var atableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        return tv
    }()
    
    var tickets = [QRCode]() {
        didSet {
            DispatchQueue.main.async {
                self.tableViiew.reloadData()
            }
        }
    }
    
    var coupons: [Coupon] = []
    var allTickets: [AnyObject] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableViiew.reloadData()
            }
        }
    }
    
    var refreshControl = UIRefreshControl()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTicket()
    }
    
    private func configureViewController() {
        tableViiew.rowHeight = 140
        tableViiew.register(UsableTableViewCell.nib, forCellReuseIdentifier: UsableTableViewCell.reuseIdentifier)
        tableViiew.delegate = self
        tableViiew.dataSource = self
        tableViiew.separatorStyle = .none
        tableViiew.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
    }
    @objc func refreshList() {
        getTicket()
    }
    
    private func getTicket() {
        refreshControl.beginRefreshing()
        QRCodeService.shared.getQRUnconfirmList(type: .product) { productResponse in
            QRCodeService.shared.getQRUnconfirmList(type: .package) { packageResponse in
                CouponService.shared.getNewMemberCoupon(type: .unredeemed) { success, response in
                    var allTickets: [AnyObject] = []
                    guard success else {
                        let errorMsg = response as! String
                        Alert.showMessage(title: "系統訊息", msg: errorMsg, vc: self)
                        return
                    }
                    
                    self.tickets = productResponse + packageResponse
                    self.coupons = response as! [Coupon]
                    allTickets.append(contentsOf: self.tickets as [AnyObject])
                    allTickets.append(contentsOf: self.coupons as [AnyObject])
                    self.allTickets = allTickets.sorted { ticket1, ticket2 in
                        let timeString1: String
                        if let ticket1 = ticket1 as? QRCode {
                            timeString1 = ticket1.orderDate
                        } else if let ticket1 = ticket1 as? Coupon {
                            timeString1 = ticket1.couponEnddate
                        } else {
                            return true
                        }
                        
                        let timeString2: String
                        if let ticket2 = ticket2 as? QRCode {
                            timeString2 = ticket2.orderDate
                        } else if let ticket2 = ticket2 as? Coupon {
                            timeString2 = ticket2.couponEnddate
                        } else {
                            return true
                        }
                        guard let time1 = self.dateFormatter.date(from: timeString1)?.timeIntervalSince1970,
                              let time2 = self.dateFormatter.date(from: timeString2)?.timeIntervalSince1970 else { return true }
                        return time1 > time2
                    }
                    
                    self.emptyView.isHidden = self.allTickets.count != 0
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
}

extension UsableTicketViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UsableTableViewCell.reuseIdentifier, for: indexPath) as! UsableTableViewCell
        
        let ticket = allTickets[indexPath.row]
        cell.configure(with: ticket)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let ticket = allTickets[indexPath.row]
        if let ticket = ticket as? QRCode {
            if ticket.storeID != nil { // 如果有storeID則已經是商品，可直接進去可核銷QRCode頁面
                let controller = TicketDetailViewController(ticket: ticket) // 這裡的ticket變成商品資訊
                navigationController?.pushViewController(controller, animated: true)
            } else {
                // 如果沒有storeID代表他是套票，應該先跳轉套票所涵蓋商品內容
                let controller = PackageProductDetailTableViewController()
                controller.ticket = ticket
                if let ticketProduct = ticket.product {
                    let ticketProductWithQR = ticketProduct.filter { $0.qrconfirm != nil }
                    controller.products = ticketProductWithQR
                } else {
                    print("ticket.product is nil!")
                }
                navigationController?.pushViewController(controller, animated: true)
            }
        } else if let ticket = ticket as? Coupon {
            let controller = CouponDetailViewController(model: ticket)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
