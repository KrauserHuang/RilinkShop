//
//  UsableTicketViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/10.
//

import UIKit

class UsableTicketViewController: UIViewController {

    @IBOutlet weak var tableViiew: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableViiew.rowHeight = 101
        self.tableViiew.register(UINib(nibName: "UsableTableViewCell", bundle: nil), forCellReuseIdentifier: "UsableTableViewCell")
        self.tableViiew.delegate = self
        self.tableViiew.dataSource = self
        
    }

}

extension UsableTicketViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsableTableViewCell",for: indexPath) as! UsableTableViewCell
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = TicketDetailViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
