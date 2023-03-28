//
//  UsedTicketViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/10.
//

import UIKit

class UsedTicketViewController: UIViewController {

    @IBOutlet weak var tableViiew: UITableView!
    @IBOutlet weak var emptyView: UIView!

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
        tableViiew.register(UsedTableViewCell.nib, forCellReuseIdentifier: UsedTableViewCell.reuseIdentifier)
        tableViiew.delegate = self
        tableViiew.dataSource = self
        tableViiew.allowsSelection = false
        tableViiew.separatorStyle = .none
        tableViiew.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
    }
    @objc func refreshList() {
        getTicket()
    }
    
    private func getTicket() {
        refreshControl.beginRefreshing()
        QRCodeService.shared.getQRConfirmList(type: .product) { productResponse in
            QRCodeService.shared.getQRConfirmList(type: .package) { packageResponse in
                CouponService.shared.getNewMemberCoupon(type: .redeemed) { success, response in
                    var allTickets: [AnyObject] = []
                    guard success else {
                        let errorMsg = response as! String
                        Alert.showMessage(title: "系統訊息", msg: errorMsg, vc: self)
                        return
                    }
                    //                let packageWithoutQRConfirm = packageResponse.filter { package in
                    //                    package.product?.allSatisfy({ $0.qrconfirm == nil })
                    //                    return true
                    //                }
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

extension UsedTicketViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTickets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UsedTableViewCell.reuseIdentifier) as! UsedTableViewCell

        let ticket = allTickets[indexPath.row]
        cell.configure(with: ticket)

        return cell
    }
}
