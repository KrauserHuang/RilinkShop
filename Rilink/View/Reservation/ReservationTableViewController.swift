//
//  ReservationTableViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/6.
//

import UIKit

class ReservationTableViewController: UITableViewController {

    let tool = Tool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 131
        self.tableView.register(UINib(nibName: "ReservationTableViewCell", bundle: nil), forCellReuseIdentifier: "reservationTableViewCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reservationTableViewCell", for: indexPath) as! ReservationTableViewCell
        
        cell.closure = {
            self.navigationController?.pushViewController(CalendarViewController(), animated: true)
        }
        
        cell.reservationButton.backgroundColor = tool.customOrange
        tool.makeRoundedCornersButton(button: cell.reservationButton)
        
        return cell
        
    }
    
}
