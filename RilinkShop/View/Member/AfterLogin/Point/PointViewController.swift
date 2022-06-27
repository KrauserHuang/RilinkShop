//
//  PointViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/7.
//

import UIKit

class PointViewController: UIViewController {

    @IBOutlet weak var point: UILabel!
    @IBOutlet weak var remindLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var account = Global.ACCOUNT
    var password = Global.ACCOUNT_PASSWORD
    var points: [Point] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = 67
        self.tableView.register(UINib(nibName: "PointTableViewCell", bundle: nil), forCellReuseIdentifier: "pointTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        getPoint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPoint()
    }
    
    func getPoint() {
        let accountType = "0"
//        sleep(1)
        UserService.shared.getPersonalData(account: account, pw: password, accountType: accountType) { success, response in
            DispatchQueue.global(qos: .userInitiated).async {
                URLCache.shared.removeAllCachedResponses()
                DispatchQueue.main.async {
                    
                    guard success else {
                        return
                    }
                    if let user = response as? User {
                        self.point.text = user.point
                    }
                }
            }
        }
        PointService.shared.fetchPointHistory(id: account, pwd: password) { success, response in
            guard success else {
                return
            }
            
            let points = response as! [Point]
            self.points = points
            print(#function)
            print(points)
        }
    }

}

extension PointViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return points.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pointTableViewCell") as! PointTableViewCell
        
        let point = points[indexPath.row]
        cell.configure(with: point)
        
        return cell
    }
}
