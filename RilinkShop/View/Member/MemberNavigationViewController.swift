//
//  MemberNavigationViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/6.
//

import UIKit

class MemberNavigationViewController: UINavigationController {

    func showRoot(){
        if #available(iOS 13.0, *) {
            guard let controller = UIStoryboard(name: "MemberCenterTableViewController", bundle: nil).instantiateViewController(identifier: "MemberCenterTableViewController") as? MemberCenterTableViewController else { return }
            controller.delegate = self
            viewControllers = [controller]
        } else {
            // Fallback on earlier versions
        }
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showRoot()
        
    }

}

extension MemberNavigationViewController: MemberCenterTableViewControllerDelegate{
    func memberInfo(_ viewController: MemberCenterTableViewController) {
        viewController.navigationController?.pushViewController(MemberInfoViewController(), animated: true)
    }
    
    func myTicket(_ viewController: MemberCenterTableViewController) {
        let controller = UIStoryboard(name: "Ticket", bundle: nil).instantiateViewController(withIdentifier: "Ticket")
        viewController.navigationController?.pushViewController(controller, animated: true)
    }
    
    func coupon(_ viewController: MemberCenterTableViewController) {
        let controller = UIStoryboard(name: "Coupon", bundle: nil).instantiateViewController(withIdentifier: "Coupon")
        viewController.navigationController?.pushViewController(controller, animated: true)
    }
    
    func point(_ viewController: MemberCenterTableViewController) {
        viewController.navigationController?.pushViewController(PointViewController(), animated: true)
    }
    
    func privateRule(_ viewController: MemberCenterTableViewController) {
        viewController.navigationController?.pushViewController(PrivateRuleViewController(), animated: true)
    }
    
    func question(_ viewController: MemberCenterTableViewController) {
        viewController.navigationController?.pushViewController(QuestionViewController(), animated: true)
    }
    
    func logout(_ viewController: MemberCenterTableViewController) {
//        viewController.navigationController?.pushViewController(LoginViewController(), animated: true)
//        let controller = LoginViewController()
//        setViewControllers([controller], animated: false)
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//        let controller = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
