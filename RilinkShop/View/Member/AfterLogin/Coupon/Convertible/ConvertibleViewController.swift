//
//  ConvertibleViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/10.
//

import UIKit

class ConvertibleViewController: UIViewController {

    let tool = Tool()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = 101
        self.tableView.register(UINib(nibName: "ConvertibleTableViewCell", bundle: nil), forCellReuseIdentifier: "convertibleTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self

    }
}

extension ConvertibleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "convertibleTableViewCell", for: indexPath) as! ConvertibleTableViewCell

        tool.makeRoundedCornersButton(button: cell.copyButton)
        cell.copyButton.backgroundColor = .white
        cell.copyButton.layer.borderColor = tool.customOrange.cgColor
        cell.copyButton.layer.borderWidth = 2
        cell.copyButton.tintColor = tool.customOrange

        return cell
    }
}
