//
//  UsedTicketViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/10.
//

import UIKit

class UsedTicketViewController: UIViewController {

    @IBOutlet weak var tableViiew: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableViiew.rowHeight = 101
        self.tableViiew.register(UINib(nibName: "UsedTableViewCell", bundle: nil), forCellReuseIdentifier: "UsedTableViewCell")
        self.tableViiew.delegate = self
        self.tableViiew.dataSource = self
    }

}

extension UsedTicketViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsedTableViewCell") as! UsedTableViewCell
        return cell
    }
    
    
}
