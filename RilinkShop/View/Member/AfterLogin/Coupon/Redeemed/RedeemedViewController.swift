//
//  RedeemedViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/10.
//

import UIKit

class RedeemedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = 101
        self.tableView.register(UINib(nibName: "RedeemedTableViewCell", bundle: nil), forCellReuseIdentifier: "redeemedTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

}

extension RedeemedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "redeemedTableViewCell", for: indexPath) as! RedeemedTableViewCell

        return cell
    }
}
