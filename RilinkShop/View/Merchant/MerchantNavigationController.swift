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

}

extension MerchantNavigationController: MerchantMainViewControllerDelegate {
    func didTapScanButton(_ viewController: MerchantMainViewController) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QRCodeViewController") as! QRCodeViewController
        vc.modalPresentationStyle = .fullScreen
        viewController.present(vc, animated: true, completion: nil)
    }
    
    func didTapNotifyButton(_ viewController: MerchantMainViewController) {
//        let url = API_URL + URL_BOSSFETCHNOTIFYHISTORY
//        let parameters: [String: Any] = ["account": Global.ACCOUNT, "accessToken": Global.ACCESS_TOKEN]
//        HUD.showLoadingHUD(inView: viewController.view, text: "讀取中")
//        ApiConnection.getAPIRequest(url: url, parameters: parameters) { isSuccess, response in
//            HUD.hideLoadingHUD(inView: viewController.view)
//            guard isSuccess else {
//                print("ERROR\(response)")
//                return}
//            guard let response = response as? JSON, let returnData = response["returnData"].array else{
//                print("ERROR response")
//                return}
//            var dataArray = [NotifyViewModel]()
//            for data in returnData {
//                dataArray.append(NotifyViewModel(with: data))
//            }
//            let controller = self.storyboard?.instantiateViewController(withIdentifier: "NotifyTableViewController") as! NotifyTableViewController
//            controller.messages = dataArray
//            self.pushViewController(controller, animated: true)
//        }
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "NotifyTableViewController") as! NotifyTableViewController
//        controller.messages = dataArray
        self.pushViewController(controller, animated: true)
    }
    
    func didTapPreferencesButton(_ viewController: MerchantMainViewController) {
//        let url = API_URL + URL_BOSSISNOTIFY
//        let parameters: [String: Any] = ["account": Global.ACCOUNT, "accessToken": Global.ACCESS_TOKEN]
//        HUD.showLoadingHUD(inView: viewController.view, text: "讀取中")
//        ApiConnection.getAPIRequest(url: url, parameters: parameters) { isSuccess, response in
//            HUD.hideLoadingHUD(inView: viewController.view)
//            let controller = self.storyboard?.instantiateViewController(withIdentifier: "PreferencesTableViewController") as! PreferencesTableViewController
//            controller.delegate = self
//            if let response = response as? JSON, let returnData = response["returnData"].array, let notify = returnData.first {
//                if notify["notify"].stringValue == "ON" {
//                    controller.isOn = true
//                }
//            }
//            self.pushViewController(controller, animated: true)
//        }
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "PreferencesTableViewController") as! PreferencesTableViewController
        controller.delegate = self
        self.pushViewController(controller, animated: true)
    }
}

extension MerchantNavigationController: PreferencesTableViewControllerDelegate {
    func didTapNotifySwitch(_ viewController: PreferencesTableViewController, to status: Bool) {
        print("switch切換")
    }
    
    func didTapLogout(_ viewController: PreferencesTableViewController) {
        MyKeyChain.logout()
        dismiss(animated: true, completion: nil)
    }
}
