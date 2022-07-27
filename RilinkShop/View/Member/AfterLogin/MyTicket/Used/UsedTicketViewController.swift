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
    var sortedTickets = [QRCode]() {
        didSet {
            DispatchQueue.main.async {
                self.tableViiew.reloadData()
            }
        }
    }
    var account = MyKeyChain.getAccount() ?? ""
    var password = MyKeyChain.getPassword() ?? ""
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViiew.rowHeight = 120
        tableViiew.register(UINib(nibName: "UsedTableViewCell", bundle: nil), forCellReuseIdentifier: "UsedTableViewCell")
        tableViiew.delegate = self
        tableViiew.dataSource = self
        tableViiew.allowsSelection = false
        
        tableViiew.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        
        getTicket()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTicket()
    }

    func getTicket() {
        QRCodeService.shared.confirmList(id: MyKeyChain.getAccount() ?? "", pwd: MyKeyChain.getPassword() ?? "", ispackage: "0") { productResponse in
            QRCodeService.shared.confirmList(id: MyKeyChain.getAccount() ?? "", pwd: MyKeyChain.getPassword() ?? "", ispackage: "1") { packageResponse in
                
                let packageWithoutQRConfirm = packageResponse.filter { package in
                    package.product?.allSatisfy({ $0.qrconfirm == nil }) as! Bool
                }
//                var packageWithQR = [QRCode]()
//                var packages = [QRCode]()
//                packageResponse.forEach { package in
//                    let hasNotQRConfirm = package.product?.filter({ product in
//                        product.qrconfirm == nil
//                    }).isEmpty
//                    print(hasNotQRConfirm)
//                    if hasNotQRConfirm! {
//                        packages.append(package)
//                    } else {
//                        packageWithQR.append(package)
//                    }
//                }
                self.tickets = productResponse + packageWithoutQRConfirm
                self.sortedTickets = self.tickets.sorted(by: { ticket1, ticket2 in
                    ticket1.orderDate > ticket2.orderDate
                })
                self.emptyView.isHidden = self.sortedTickets.count != 0
            }
        }
    }
    
    @objc func refreshList() {
        self.refreshControl.beginRefreshing()
        QRCodeService.shared.confirmList(id: account, pwd: password, ispackage: "0") { productResponse in
            QRCodeService.shared.confirmList(id: self.account, pwd: self.password, ispackage: "1") { packageResponse in
                let packageWithoutQRConfirm = packageResponse.filter { package in
                    package.product?.allSatisfy({ $0.qrconfirm == nil }) as! Bool
                }
                self.tickets = productResponse + packageWithoutQRConfirm
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

extension UsedTicketViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedTickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsedTableViewCell") as! UsedTableViewCell
        
        let ticket = sortedTickets[indexPath.row]
        cell.configure(with: ticket)
        
        return cell
    }
}
