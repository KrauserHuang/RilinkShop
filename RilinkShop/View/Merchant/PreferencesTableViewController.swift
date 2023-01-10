//
//  PreferencesTableViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2023/1/9.
//

import UIKit

protocol PreferencesTableViewControllerDelegate: AnyObject {
    func didTapNotifySwitch(_ viewController: PreferencesTableViewController, to status: Bool)
    func didTapLogout(_ viewController: PreferencesTableViewController)
}

class PreferencesTableViewController: UITableViewController {

    @IBOutlet weak var notifySwitch: UISwitch!
    
    weak var delegate: PreferencesTableViewControllerDelegate?
    var authorizedStatus: UNAuthorizationStatus = .notDetermined
    var isOn: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.notifySwitch.isOn = self.isOn
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            self.authorizedStatus = settings.authorizationStatus
        }
        
    }
    
    @IBAction func notifySwitchAction(_ sender: UISwitch) {
        delegate?.didTapNotifySwitch(self, to: sender.isOn)
        if sender.isOn, authorizedStatus != .authorized{
            Alert.showMessage(title: "", msg: "請至設定開啟推播通知權限", vc: self)
        }
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
        delegate?.didTapLogout(self)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = .clear
    }
}
