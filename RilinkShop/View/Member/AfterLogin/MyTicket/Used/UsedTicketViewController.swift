//
//  UsedTicketViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/10.
//

import UIKit

class UsedTicketViewController: UIViewController {

    @IBOutlet weak var tableViiew: UITableView!
    
    var tickets = [QRCode]() {
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

        tableViiew.rowHeight = 101
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
            
                print(#function)
                print(packageWithoutQRConfirm)
                self.tickets = productResponse + packageWithoutQRConfirm
//                print(packages)
//                self.tickets = productResponse + packages
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
                if self.tickets.count != 0 {
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
        return tickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsedTableViewCell") as! UsedTableViewCell
        
        let ticket = tickets[indexPath.row]
        cell.configure(with: ticket)
        
        return cell
    }
}
