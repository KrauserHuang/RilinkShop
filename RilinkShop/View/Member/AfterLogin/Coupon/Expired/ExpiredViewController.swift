//
//  ExpiredViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/10.
//

import UIKit

class ExpiredViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 101
        tableView.register(UINib(nibName: "ExpiredTableViewCell", bundle: nil), forCellReuseIdentifier: "expiredTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension ExpiredViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expiredTableViewCell", for: indexPath) as! ExpiredTableViewCell

        return cell
    }

}
