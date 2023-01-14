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
//        LocalStorageManager.shared.setData("0911838460", key: .userIdKey)
//        LocalStorageManager.shared.setData("simon07801", key: .userPasswordKey)
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
        
//        if LocalStorageManager.shared.getData(String.self, forKey: .userIdKey) == nil,
//           LocalStorageManager.shared.getData(String.self, forKey: .adminIdKey) != nil {
//            // 登入店長頁面
//            let storeVC = StoreAppViewController()
//            storeVC.modalPresentationStyle = .fullScreen
//            present(storeVC, animated: true, completion: nil)
//        } else if LocalStorageManager.shared.getData(String.self, forKey: .adminIdKey) == nil,
//                  LocalStorageManager.shared.getData(String.self, forKey: .userIdKey) != nil {
//            // 登入使用者頁面
////            selectedIndex = 0
//        } else if LocalStorageManager.shared.getData(String.self, forKey: .userIdKey) == nil,
//                  LocalStorageManager.shared.getData(String.self, forKey: .adminIdKey) == nil {
//            selectedIndex = 3
//        }
        
        
        if MyKeyChain.getAccount() == nil,
           MyKeyChain.getBossAccount() != nil {
            // 登入店長頁面
            let vc = UIStoryboard(name: "Merchant", bundle: nil).instantiateViewController(withIdentifier: "MerchantNavigationController") as! MerchantNavigationController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        } else if MyKeyChain.getBossAccount() == nil,
                  MyKeyChain.getAccount() != nil {
            // 登入使用者頁面
//            selectedIndex = 0
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
//        guard LocalStorageManager.shared.getData(String.self, forKey: .userIdKey) == nil else {
////        guard MyKeyChain.getAccount() == nil else {
//            tryLogIn()
//            guard let MainTabViewControllers = self.viewControllers else {
//                print("no valid viewControllers in MainTabBarController.")
//                return
//            }
//            guard let rootVC = MainTabViewControllers[self.selectedIndex] as? UINavigationController else {
//                print("fail to get viewControllers(as UINavigationController).")
//                return
//            }
//            rootVC.popToRootViewController(animated: false)
//            return
//        }
//        guard let MainTabViewControllers = self.viewControllers else {
//            print("no valid viewControllers in MainTabBarController.")
//            return
//        }
//        guard let rootVC = MainTabViewControllers[self.selectedIndex] as? UINavigationController else {
//            print("fail to get viewControllers(as UINavigationController).")
//            return
//        }
//        rootVC.popToRootViewController(animated: false)
//        Alert.showSecurityAlert(title: "", msg: "使用商城前\n請先登入帳號。", vc: self) {
//            self.selectedIndex = 3
//        }
        
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
        
//        if LocalStorageManager.shared.getData(String.self, forKey: .userIdKey) == nil {
////        if MyKeyChain.getAccount() == nil {
//            Alert.showSecurityAlert(title: "", msg: "使用商城前\n請先登入帳號。", vc: self) {
//                self.selectedIndex = 3
//            }
//        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        tryLogIn()
    }
}
