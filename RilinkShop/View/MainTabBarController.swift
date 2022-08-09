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
        tabBar.tintColor = Theme.customOrange
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

//        print("MainTabBarController + \(#function)")
//        print("didLogin:\(UserService.shared.didLogin)")
//        print("userAccount:\(MyKeyChain.getAccount())")
//        print("adminAccount:\(MyKeyChain.getBossAccount())")
//        MyKeyChain.setAccount("0910619306")
//        MyKeyChain.setPassword("a12345678")
//        UserService.shared.id = "0910619306"
//        UserService.shared.pwd = "a12345678"
//        UserService.shared.didLogin = true

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
            let storeVC = StoreAppViewController()
            storeVC.modalPresentationStyle = .fullScreen
            present(storeVC, animated: true, completion: nil)
        } else if MyKeyChain.getBossAccount() == nil,
                  MyKeyChain.getAccount() != nil {
            // 登入使用者頁面
            selectedIndex = 0
//            Global.ACCOUNT = MyKeyChain.getAccount() ?? ""
//            Global.ACCOUNT_PASSWORD = MyKeyChain.getPassword() ?? ""
            print("MainTabBarController + \(#function)")
            print("GlobalAccount:\(Global.ACCOUNT)")
            print("GlobalPassword:\(Global.ACCOUNT_PASSWORD)")
            print("-----------------------------------")
            print("KeyChainAccount:\(MyKeyChain.getAccount())")
            print("KeyChainPassword:\(MyKeyChain.getPassword())")
            print("-----------------------------------")
            print("UserServiceAccount:\(UserService.shared.id)")
            print("UserServicePassword:\(UserService.shared.pwd)")
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
        if UserService.shared.id == "" {
            Alert.showSecurityAlert(title: "", msg: "使用商城前\n請先登入帳號。", vc: self) {
                self.selectedIndex = 3
            }
        }
    }
}
