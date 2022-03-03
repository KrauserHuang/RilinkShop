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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = 67
        self.tableView.register(UINib(nibName: "PointTableViewCell", bundle: nil), forCellReuseIdentifier: "pointTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }

}

extension PointViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pointTableViewCell") as! PointTableViewCell
        return cell
    }
    
    
}
