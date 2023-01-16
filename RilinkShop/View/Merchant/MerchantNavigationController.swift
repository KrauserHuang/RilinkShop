//
//  MerchantNavigationController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2023/1/9.
//

import UIKit

class MerchantNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        toRootVC()
    }
    
    private func toRootVC() {
        let rootVC = self.viewControllers.first as! MerchantMainViewController
        rootVC.delegate = self
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    private func showRoot(animated: Bool) {
        let vc = UIStoryboard(name: "MemberCenterTableViewController", bundle: nil).instantiateViewController(withIdentifier: "MemberCenterViewController") as! MemberCenterViewController
        self.dismiss(animated: true)
        self.setViewControllers([vc], animated: false)
    }
}

extension MerchantNavigationController: MerchantMainViewControllerDelegate {
    func didTapScanButton(_ viewController: MerchantMainViewController) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QRCodeViewController") as! QRCodeViewController
        vc.modalPresentationStyle = .fullScreen
        viewController.present(vc, animated: true, completion: nil)
    }
    // MARK: - 取得店長推播歷史紀錄
    func didTapNotifyButton(_ viewController: MerchantMainViewController) {
        guard let adminAccount = MyKeyChain.getBossAccount(),
              let adminPassword = MyKeyChain.getBossPassword() else { return }
        print("adminAccount:\(adminAccount)")
        print("adminPassword:\(adminPassword)")
        print("ID:\(Global.OWNER_STORE_ID)")
        NotificationService.shared.storeAdminGetNotifyHistory(storeAcc: adminAccount,
                                                              storePwd: adminPassword,
                                                              storeID: Global.OWNER_STORE_ID) { success, response in
            guard success else {
                let errorMsg = response as! String
                Alert.showMessage(title: "", msg: errorMsg, vc: self)
                return
            }
            
            let messages = response as! [NotifyViewModel]
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "NotifyTableViewController") as! NotifyTableViewController
            controller.messages = messages
            
            if messages.count == 0 {
                controller.showEmptyStateView(with: "無訊息", in: controller.view)
            }
            self.pushViewController(controller, animated: true)
        }
    }
    // MARK: - 進入設定頁面，先取得推播設定狀態
    func didTapPreferencesButton(_ viewController: MerchantMainViewController) {
        guard let adminAccount = MyKeyChain.getBossAccount(),
              let adminPassword = MyKeyChain.getBossPassword() else { return }
        HUD.showLoadingHUD(inView: viewController.view, text: "設定中")
        print("adminAccount:\(adminAccount)")
        print("adminPassword:\(adminPassword)")
        print("ID:\(Global.OWNER_STORE_ID)")
        NotificationService.shared.storeAdminIsNotify(storeAcc: adminAccount,
                                                      storePwd: adminPassword,
                                                      storeID: Global.OWNER_STORE_ID) { success, response in
            HUD.hideLoadingHUD(inView: viewController.view)
            
            guard success else {
                print("取得推播狀態失敗")
                return
            }
            
            let status = response as! String
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "PreferencesTableViewController") as! PreferencesTableViewController
            controller.delegate = self
            if status == "on" {
                controller.isOn = true
            } else {
                controller.isOn = false
            }
            self.pushViewController(controller, animated: true)
        }
    }
}

extension MerchantNavigationController: PreferencesTableViewControllerDelegate {
    // MARK: - 設定頁面，設定推播狀態
    func didTapNotifySwitch(_ viewController: PreferencesTableViewController, to status: Bool) {
        guard let adminAccount = MyKeyChain.getBossAccount(),
              let adminPassword = MyKeyChain.getBossPassword() else { return }
        HUD.showLoadingHUD(inView: viewController.view, text: "設定中")
        NotificationService.shared.storeAdminSetNotify(storeAcc: adminAccount,
                                                       storePwd: adminPassword,
                                                       storeID: Global.OWNER_STORE_ID,
                                                       isNotify: status ? "on" : "off") { success, response in
            print("設定成功")
            HUD.hideLoadingHUD(inView: viewController.view)
        }
    }
    
    func didTapLogout(_ viewController: PreferencesTableViewController) {
        guard let adminAccount = MyKeyChain.getBossAccount(),
              let adminPassword = MyKeyChain.getBossPassword() else { return }
        UserService.shared.storeAdminLogout(storeAcc: adminAccount,
                                            storePwd: adminPassword,
                                            storeID: Global.OWNER_STORE_ID) { success, response in
            guard success else {
                return
            }
            self.showRoot(animated: true)
        }
    }
}
