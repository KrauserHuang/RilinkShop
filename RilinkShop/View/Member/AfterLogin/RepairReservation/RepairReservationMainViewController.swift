//
//  RepairReservationMainViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/9/12.
//

import UIKit
import DropDown

class RepairReservationMainViewController: UIViewController {

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    var motorNos = [FixMotor]() // 所有該使用者預約的車牌
    var specificMotorNoDetails = [FixMotor]() // 該車牌所有的預約時間
    let dropDown = DropDown()
//    var account: String!
//    var password: String!
//
//    init(account: String, password: String) {
//        super.init(nibName: nil, bundle: nil)
//        self.account = account
//        self.password = password
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 230

        searchButton.tintColor = .primaryOrange

        loadFixMotorList()
        configTableView()
    }
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        var motorNosString = [String]()
        for no in motorNos {
            motorNosString.append(no.motorNo)
        }
        dropDown.dataSource = motorNosString
        dropDown.anchorView = searchButton
        dropDown.bottomOffset = CGPoint(x: 0,
                                        y: searchButton.frame.size.height)
        dropDown.show()
        dropDown.selectionAction = { [weak self] (_: Int, item: String) in
            guard let self = self else { return }
            self.searchButton.setTitle(item, for: .normal)

            self.specificMotorNoDetails.removeAll()

            HUD.showLoadingHUD(inView: self.view, text: "")
//            FixMotorService.shared.bookingFixMotorList(id: self.account,
//                                                       pwd: self.password,
//                                                       no: item) { success, response in
            FixMotorService.shared.bookingFixMotorList(id: MyKeyChain.getAccount() ?? "",
                                                       pwd: MyKeyChain.getPassword() ?? "",
                                                       no: item) { success, response in
//            FixMotorService.shared.bookingFixMotorList(id: MyKeyChain.getAccount() ?? UserService.shared.id,
//                                                       pwd: MyKeyChain.getPassword() ?? UserService.shared.pwd,
//                                                       no: item) { success, response in
                HUD.hideLoadingHUD(inView: self.view)
                guard success else {
                    let errorMsg = response as! String
                    Alert.showMessage(title: "", msg: errorMsg, vc: self)
                    return
                }
                let detail = response as! [FixMotor]
                self.specificMotorNoDetails = detail.sorted(by: { detail1, detail2 in
                    detail1.bookingDate > detail2.bookingDate
//                    if detail1.bookingDate == detail2.bookingDate {
//                        return detail1.duration > detail2.duration
//                    }
                })
//                self.specificMotorNoDetails = response as! [FixMotor]
                self.tableView.reloadData()
            }
        }
    }
}
// MARK: - internal functions
extension RepairReservationMainViewController {
    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RepairReservationTableViewCell.nib, forCellReuseIdentifier: RepairReservationTableViewCell.reuseIdentifier)
    }
    private func loadFixMotorList() {
//        FixMotorService.shared.bookingFixMotorList(id: account,
//                                                   pwd: password,
//                                                   no: "") { success, response in
        FixMotorService.shared.bookingFixMotorList(id: Global.ACCOUNT,
                                                   pwd: Global.ACCOUNT_PASSWORD,
                                                   no: "") { success, response in
//        FixMotorService.shared.bookingFixMotorList(id: MyKeyChain.getAccount() ?? UserService.shared.id,
//                                                   pwd: MyKeyChain.getPassword() ?? UserService.shared.pwd,
//                                                   no: "") { success, response in
            guard success else {
                let errorMsg = response as! String
                Alert.showMessage(title: "", msg: errorMsg, vc: self)
                return
            }

            self.motorNos = response as! [FixMotor]

        }
    }
}
// MARK: - TableView Delegate/DataSource
extension RepairReservationMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return specificMotorNoDetails.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepairReservationTableViewCell.reuseIdentifier, for: indexPath) as? RepairReservationTableViewCell else {
            return UITableViewCell()
        }

        let model = specificMotorNoDetails[indexPath.row]
        cell.configure(with: model)
//        cell.model = model
        cell.delegate = self

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
// MARK: - TableView Cell Delegate
extension RepairReservationMainViewController: RepairReservationTableViewCellDelegate {
    // 點選按鈕後動態伸展畫面
    func didTapExpandButton(_ cell: RepairReservationTableViewCell) {
//        guard let indexPath = tableView.indexPath(for: cell) else { return }
//        let model = cellModels[indexPath.row]

//        cell.expandToggle == true ? false : true
        tableView.layoutIfNeeded()
        switch cell.expandToggle {
        case true:
            cell.expandToggle = false
        case false:
            cell.expandToggle = true
        }
        tableView.beginUpdates()
        tableView.endUpdates()
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
    // 取消預約執行API，並在成功後將UI更新(灰色不可點選狀態)
    func didTapCancelButton(_ cell: RepairReservationTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let bid = specificMotorNoDetails[indexPath.row].bid
        Alert.showConfirm(title: "", msg: "是否取消預約？", vc: self) {
            HUD.showLoadingHUD(inView: self.view, text: "")

            FixMotorService.shared.bookingFixMotorCancel(id: Global.ACCOUNT,
                                                         pwd: Global.ACCOUNT_PASSWORD,
                                                         bid: bid) { success, response in
                HUD.hideLoadingHUD(inView: self.view)
                guard success else {
                    let errorMsg = response as! String
                    Alert.showMessage(title: "", msg: errorMsg, vc: self)
                    return
                }

                let successMsg = response as! String
                Alert.showMessage(title: "", msg: successMsg, vc: self) {
                    cell.isCancelled = true
                }
            }
        }
    }
}
