//
//  MemberCenterTableViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/6.
//

import UIKit

protocol MemberCenterTableViewControllerDelegate: AnyObject {
    func memberInfo(_ viewController: MemberCenterTableViewController)
    func myTicket(_ viewController: MemberCenterTableViewController)
    func coupon(_ viewController: MemberCenterTableViewController)
    func point(_ viewController: MemberCenterTableViewController)
    func privateRule(_ viewController: MemberCenterTableViewController)
    func question(_ viewController: MemberCenterTableViewController)
    func logout(_ viewController: MemberCenterTableViewController)
}

class MemberCenterTableViewController: UITableViewController {

   
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var camera: UIButton!
    @IBAction func cameraAction(_ sender: UIButton) {
    }
    @IBAction func myOrderAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(MyOrderTableViewController(), animated: true)
    }
    @IBAction func myCollectionAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(MyCollectionViewController(), animated: true)
    }
    @IBAction func cnosumptionAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(ConsumptionRecordViewController(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = 48
        
        userImage.layer.cornerRadius = userImage.frame.height / 2
        camera.layer.cornerRadius = camera.frame.height / 2
        
    }

    weak var delegate: MemberCenterTableViewControllerDelegate?

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            delegate?.memberInfo(self)
        case 1:
            delegate?.myTicket(self)
        case 2:
            delegate?.coupon(self)
        case 3:
            delegate?.point(self)
        case 4:
            delegate?.privateRule(self)
        case 5:
            delegate?.question(self)
        case 6:
            delegate?.logout(self)
        default:
            break
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerHeight: CGFloat

            switch section {
            case 0:
                // hide the header
                headerHeight = CGFloat.leastNonzeroMagnitude
            case 1:
                // section2 height
                headerHeight = 150
            default:
                headerHeight = 21
            }
            return headerHeight
    }
    
}
