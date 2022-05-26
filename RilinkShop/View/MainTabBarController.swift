//
//  MainTabBarController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/6.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        MyKeyChain.setAccount("0911838460")
//        MyKeyChain.setPassword("simon07801")
        
        delegate = self
        self.tabBar.tintColor = UIColor(hex: "4F846C")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        MyKeyChain.setAccount("0911838460")
//        MyKeyChain.setPassword("simon07801")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(#function)
        print(UserService.shared.didLogin)
        print(MyKeyChain.getAccount())
        print(MyKeyChain.getBossAccount())
        
        if UserService.shared.didLogin {
            tryLogIn()
        } else {
//            HUD.showLoadingHUD(inView: self.view, text: "")
            UserService.shared.renewUser = {
//                HUD.hideLoadingHUD(inView: self.view)
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
            print("跑來這裡")
            selectedIndex = 0
            Global.ACCOUNT = MyKeyChain.getAccount() ?? ""
            Global.ACCOUNT_PASSWORD = MyKeyChain.getPassword() ?? ""
        }
        else if MyKeyChain.getAccount() == nil,
                  MyKeyChain.getBossAccount() == nil {
//            let vc = LoginViewController_1()
            self.selectedIndex = 3
//            let memberNavC = self.selectedViewController as? MemberNavigationViewController
//            memberNavC?.popToRootViewController(animated: true)
//            if let vc = memberNavC?.viewControllers.compactMap({ $0 as? LoginViewController_1
//            }).first {
//                vc.delegate = self
//                memberNavC?.setViewControllers([vc], animated: true)
////                vc.modalPresentationStyle = .fullScreen
////                present(vc, animated: true, completion: nil)
//            }
//            vc.delegate = self
//            vc.modalPresentationStyle = .fullScreen
//            present(vc, animated: true, completion: nil)
        }
    }
    // MARK: - 跳會員首頁(MemberCenterTableViewController)
    func showRoot(animated: Bool) {
        guard let memberCenterTVC = UIStoryboard(name: "MemberCenterTableViewController", bundle: nil).instantiateViewController(identifier: "MemberCenterTableViewController") as? MemberCenterTableViewController else {
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
//            viewControllers = [memberCenterTVC]
        }
    }
}
// MARK: - 點選tab之後會跳回該tab的第一頁，tab->nav->viewController
extension MainTabBarController:  UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
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
