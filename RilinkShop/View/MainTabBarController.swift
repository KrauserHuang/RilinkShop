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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(#function)
        print("didLogin:\(UserService.shared.didLogin)")
        print("userAccount:\(MyKeyChain.getAccount())")
        print("adminAccount:\(MyKeyChain.getBossAccount())")
        
        if UserService.shared.didLogin {
            tryLogIn()
        } else {
            UserService.shared.renewUser = {
                self.tryLogIn()
            }
        }
    }
    
    func tryLogIn(){
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
            Global.ACCOUNT = MyKeyChain.getAccount() ?? ""
            Global.ACCOUNT_PASSWORD = MyKeyChain.getPassword() ?? ""
        }
        else if MyKeyChain.getAccount() == nil,
                  MyKeyChain.getBossAccount() == nil {
            self.selectedIndex = 3
        }
    }
    // MARK: - 跳會員首頁(MemberCenterTableViewController)
    func showRoot(animated: Bool) {
        guard let memberCenterTVC = UIStoryboard(name: "MemberCenterTableViewController", bundle: nil).instantiateViewController(identifier: "MemberCenterViewController") as? MemberCenterViewController else {
            print("showRoot失敗")
            return
        }
        if MyKeyChain.getBossAccount() != nil {
            let vc = StoreAppViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        } else {
//            memberCenterTVC.delegate = self
//            pushViewController(memberCenterTVC, animated: animated)
            dismiss(animated: true, completion: nil)
            self.selectedIndex = 3
//            let memberNavC = self.selectedViewController as? MemberNavigationViewController
//            memberNavC?.popToRootViewController(animated: false)
//            if let memberCenterTVC =
            viewControllers = [memberCenterTVC]
        }
    }
}
// MARK: - 點選tab之後會跳回該tab的第一頁，tab->nav->viewController
extension MainTabBarController:  UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        tryLogIn()
//        if Global.ACCOUNT == "" {
//            Alert.showMessage(title: "", msg: "使用商城前\n請先登入帳號。", vc: self)
//            return
//        }
        guard Global.ACCOUNT != "" else {
            Alert.showSecurityAlert(title: "", msg: "使用商城前\n請先登入帳號。", vc: self) {
                tabBar.isUserInteractionEnabled = false
            }
            return
        }
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
}

extension MainTabBarController: LoginViewController_1_Delegate {
    func finishLoginView(_ viewController: LoginViewController_1, action: finishLoginViewWith) {
        switch action {
        case .Login:
//            loadUserData()
            showRoot(animated: true)
        case .Forget:
            let vc = ForgotPasswordViewController_1()
            vc.delegate = self
            present(vc, animated: true, completion: nil)
        case .Singup:
            let vc = SignUpViewController_1()
            vc.delegate = self
            present(vc, animated: true, completion: nil)
        case .BossLogIn:
            showRoot(animated: true)
            let vc = StoreAppViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    
    func showStoreID(_ viewController: LoginViewController_1) {
        // do nothing
    }
}

extension MainTabBarController: ForgotPasswordViewController_1_Delegate {
    func finishViewWith(tempAccount: String) {
        // do nothing
    }
}

extension MainTabBarController: SignUpViewController_1_Delegate {
    func finishSignup1WithSubmitCode(_ viewController: SignUpViewController_1, resultType: Int) {
        // nothing
    }
}
