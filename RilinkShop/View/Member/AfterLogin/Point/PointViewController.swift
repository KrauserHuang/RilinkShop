//
//  PointViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/7.
//

import UIKit

class PointViewController: UIViewController {

    @IBOutlet weak var pointLabel: UIButton!
    @IBOutlet weak var point: UILabel!
    @IBOutlet weak var remindLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    var points: [Point] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPoint()
    }
    
    private func configureUI() {
        tableView.rowHeight = 67
        tableView.register(PointTableViewCell.nib, forCellReuseIdentifier: PointTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        pointLabel.isUserInteractionEnabled = false
    }

    private func getPoint() {
        pointLabel.setTitle("\(Global.personalData?.point ?? "0")", for: .normal)
        HUD.showLoadingHUD(inView: self.view, text: "載入點數紀錄中")
        PointService.shared.fetchPointHistory { success, response in
            HUD.hideLoadingHUD(inView: self.view)

            guard success else {
                let errorMsg = response as! String
                Alert.showMessage(title: "", msg: errorMsg, vc: self, handler: nil)
                return
            }

            let points = response as! [Point]
            self.points = points
            self.emptyView.isHidden = self.points.count != 0
        }
    }
}
// MARK: - UITableViewDelegate/DataSource
extension PointViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return points.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PointTableViewCell.reuseIdentifier) as! PointTableViewCell

        let point = points[indexPath.row]
        cell.configure(with: point)

        return cell
    }
}
