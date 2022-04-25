//
//  MyOrderTableViewController.swift
//  Rilink
//
//  Created by 王璽權 on 2022/1/11.
//

import UIKit

class MyOrderTableViewController: UITableViewController {

    let tool = Tool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = 130
        
        self.tableView.register(UINib(nibName: "MyOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "myOrderTableViewCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "myOrderTableViewCell") as! MyOrderTableViewCell
        
        cell.closure = {
            self.navigationController?.pushViewController(OrderDetailViewController(), animated: true)
        }
        
        tool.makeRoundedCornersButton(button: cell.detailButton)
        cell.detailButton.layer.borderColor = tool.customOrange.cgColor
        cell.detailButton.backgroundColor = .white
        cell.detailButton.layer.borderWidth = 3
        cell.detailButton.tintColor = tool.customOrange
        
        return cell
    }

}
