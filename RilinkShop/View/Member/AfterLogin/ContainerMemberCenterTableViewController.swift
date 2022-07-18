//
//  ContainerMemberCenterTableViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/7/14.
//

import UIKit

protocol ContainerMemberCenterTableViewControllerDelegate: AnyObject {
    func myOrder(_ viewController: ContainerMemberCenterTableViewController)
    func question(_ viewController: ContainerMemberCenterTableViewController)
    func customerService(_ viewController: ContainerMemberCenterTableViewController)
    func statement(_ viewController: ContainerMemberCenterTableViewController)
}

class ContainerMemberCenterTableViewController: UITableViewController {
    
    weak var delegate: ContainerMemberCenterTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isScrollEnabled = false
    }
    //倒頁面就好
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            delegate?.myOrder(self)
        case 1:
            delegate?.question(self)
        case 2:
            delegate?.customerService(self)
        case 3:
            delegate?.statement(self)
        default:
            break
        }
    }
}
