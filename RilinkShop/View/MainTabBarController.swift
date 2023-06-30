//
//  MainTabBarController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/6.
//

import UIKit
import SwiftUI

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        tabBar.tintColor = .primaryOrange
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if UserService.shared.didLogin {
            print("main_didLogIn")
            tryLogIn()
        } else {
            UserService.shared.renewUser = {
                print("main_renewUser")
                self.tryLogIn()
            }
        }
    }

    func tryLogIn() {
        if MyKeyChain.getAccount() == nil,
           MyKeyChain.getBossAccount() != nil {
            // 登入店長頁面
            let vc = UIStoryboard(name: "Merchant", bundle: nil).instantiateViewController(withIdentifier: "MerchantNavigationController") as! MerchantNavigationController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        } else if MyKeyChain.getBossAccount() == nil,
                  MyKeyChain.getAccount() != nil {
            // 登入使用者頁面
        } else if MyKeyChain.getAccount() == nil,
                  MyKeyChain.getBossAccount() == nil {
            selectedIndex = 3
        }
    }
}
// MARK: - 點選tab之後會跳回該tab的第一頁，tab->nav->viewController
extension MainTabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(self, #function)
        
        tryLogIn()
        guard let MainTabViewControllers = self.viewControllers else {
            print("no valid viewControllers in MainTabBarController.")
            return
        }
        guard let rootVC = MainTabViewControllers[self.selectedIndex] as? UINavigationController else {
            print("fail to get viewControllers(as UINavigationController).")
            return
        }
        rootVC.popToRootViewController(animated: false)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        tryLogIn()
    }
}
