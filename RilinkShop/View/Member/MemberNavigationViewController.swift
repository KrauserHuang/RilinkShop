//
//  MemberNavigationViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/6.
//

import UIKit

class MemberNavigationViewController: UINavigationController {

    var user = User()
    var userImage: UIImageView?
    var initAction: (() -> Void)?
    var initFlag = false

    override func viewDidLoad() {
        super.viewDidLoad()

//        print("MemberNavigationViewController + \(#function)")
//        print("didLogin:\(UserService.shared.didLogin)")

        if UserService.shared.didLogin {
            tryLogin()
        } else {
            UserService.shared.renewUser = {
                self.tryLogin()
            }
        }
        Global.ACCOUNT = MyKeyChain.getAccount() ?? ""
        Global.ACCOUNT_PASSWORD = MyKeyChain.getPassword() ?? ""
//        Global.ACCOUNT = LocalStorageManager.shared.getData(String.self, forKey: .userIdKey) ?? ""
//        Global.ACCOUNT_PASSWORD = LocalStorageManager.shared.getData(String.self, forKey: .userPasswordKey) ?? ""
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 只在一開始執行一次
        if initAction != nil {
            initAction?()
            initAction = nil
        }
        initFlag = true
    }

    func tryLogin() {
        if Global.ACCOUNT == "" {
//        if UserService.shared.user == nil {
//        if MyKeyChain.getAccount() == nil && MyKeyChain.getBossAccount() == nil {
            print("showLogin")
            initAction = showLogIn
        } else {
            print("showRoot")
            initAction = {
                self.showRoot(animated: false)
            }
        }
        if initFlag, initAction != nil {
            self.initAction?()
            self.initAction = nil
        }
    }
    // MARK: - 跳會員首頁(MemberCenterViewController)
    func showRoot(animated: Bool) {
        // 取得Storyboard MemberCenterTableViewController其下面的ViewController(MemberCenterViewController)
        guard let memberCenterVC = UIStoryboard(name: "MemberCenterTableViewController", bundle: nil).instantiateViewController(identifier: "MemberCenterViewController") as? MemberCenterViewController else {
            print("showRoot失敗")
            return
        }
//        if LocalStorageManager.shared.getData(String.self, forKey: .adminIdKey) != nil {
        if MyKeyChain.getBossAccount() != nil {
            let vc = UIStoryboard(name: "Merchant", bundle: nil).instantiateViewController(withIdentifier: "MerchantNavigationController") as! MerchantNavigationController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        } else {
            memberCenterVC.delegate = self
//            pushViewController(memberCenterTVC, animated: animated)
            self.popToRootViewController(animated: true)
//            self.viewControllers = [memberCenterVC]
            self.setViewControllers([memberCenterVC], animated: false)
        }
    }
    // MARK: - 跳登入首頁(LoginViewController_1)，只要沒跑showLogIn()，就不會換頁
    func showLogIn() {
        let memberCenterVC = UIStoryboard(name: "MemberCenterTableViewController", bundle: nil).instantiateViewController(identifier: "MemberCenterViewController") as! MemberCenterViewController
        popToRootViewController(animated: true)
        setViewControllers([memberCenterVC], animated: false)
        memberCenterVC.delegate = self
        user = User()
    }
    // MARK: - 進會員首頁前要載會員資料
    func loadUserData() {
        guard Global.ACCOUNT != "" && Global.ACCOUNT.count == 10 else {
            return
        }
        print("MemberNavigationViewController + \(#function)")
        print("GlobalACCOUNT:\(Global.ACCOUNT)")
        print("GlobalPASSWORD:\(Global.ACCOUNT_PASSWORD)")

        let accountType = "0"
        sleep(1)
        UserService.shared.getPersonalData(account: Global.ACCOUNT,
                                           pw: Global.ACCOUNT_PASSWORD,
                                           accountType: accountType) { success, response in
            DispatchQueue.global(qos: .userInitiated).async {
                URLCache.shared.removeAllCachedResponses()
                DispatchQueue.main.sync {

                    guard success else {
                        return
                    }

                    Global.personalData = response as? User

//                    Global.ACCOUNT = MyKeyChain.getAccount() ?? ""
//                    Global.ACCOUNT_PASSWORD = MyKeyChain.getPassword() ?? ""

                    MemberCenterViewController.newRPoint = Global.personalData?.point ?? "0"

                    if Global.personalData?.cmdImageFile == nil || Global.personalData?.cmdImageFile == "" {
                        return
                    }
                    if let personalCMDImageFile = Global.personalData?.cmdImageFile {
                        self.userImage?.setImage(with: API_URL + personalCMDImageFile)
                    }
                }
            }
        }
    }

    func toTicketViewController() {
        let controller = UIStoryboard(name: "Ticket", bundle: nil).instantiateViewController(withIdentifier: "Ticket")
        pushViewController(controller, animated: true)
    }
}
extension MemberNavigationViewController: MemberCenterViewControllerDelegate {
    func didTappedLogin(_ viewController: MemberCenterViewController) {
        let vc = LoginViewController_1()
        vc.delegate = self
        pushViewController(vc, animated: true)
    }
}
// MARK: - SignUp1 Delegate(進入第二頁面填寫認證碼、密碼)
extension MemberNavigationViewController: SignUpViewController_1_Delegate {
    func finishSignup1WithSubmitCode(_ viewController: SignUpViewController_1, resultType: Int) {
        if resultType == 1 { // 繼續驗證
            let vc = SignUpViewController_2()
            vc.delegate = self
            present(vc, animated: true, completion: nil)
        } else { // 前往登入頁
            let vc = LoginViewController_1()
            vc.delegate = self
            present(vc, animated: true, completion: nil)
        }
    }
}
// MARK: - SignUp2 Delegate(進入註冊第三頁填寫會員資訊)
extension MemberNavigationViewController: SignupViewController_2_Delegate {
    func finishSignup2With() {
        let vc = SignUpViewController()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
}
// MARK: - SignUp3 Delegate(註冊完直接進會員首頁-需要載入會員資料)
extension MemberNavigationViewController: SignUpViewControllerDelegate {
    func finishSignup3With() {
//        showRoot()
//        showLogIn()
//        loadUserData()
//        showRoot(animated: true)
    }
}
// MARK: - Login Delegate(登入/忘記密碼/註冊)
extension MemberNavigationViewController: LoginViewController_1_Delegate {
    func finishLoginView(_ viewController: LoginViewController_1, action: finishLoginViewWith) {
        switch action {
        case .Login:
            loadUserData()
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
//            showRoot(animated: true)
            print("我有跑到這邊！")
            let vc = UIStoryboard(name: "Merchant", bundle: nil).instantiateViewController(withIdentifier: "MerchantNavigationController") as! MerchantNavigationController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    func showStoreID(_ viewController: LoginViewController_1) {
        let vc = StoreIDSelectViewController()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
}
// MARK: - 忘記密碼1(重新提供手機)
extension MemberNavigationViewController: ForgotPasswordViewController_1_Delegate {
    func finishViewWith(tempAccount: String) {
        let vc = ForgotPasswordViewController_2()
        vc.delegate = self
        vc.tempAccount = tempAccount
        present(vc, animated: true, completion: nil)
    }
}
// MARK: - 忘記密碼2(完成返回登入頁面)
extension MemberNavigationViewController: ForgotPasswordViewController_2_Delegate {
    func finishPwdStep2ViewWith() {
        showLogIn()
    }
}
// MARK: - 選擇店家(StoreID) - 沒用到
extension MemberNavigationViewController: StoreIDSelectViewControllerDelegate {
    func didDismissAndPassStoreID(_ viewController: StoreIDSelectViewController, storeIDInfo: StoreIDInfo) {
        let vc = LoginViewController_1()
        vc.delegate = self
//        vc.storeIDs = storeIDInfo
        setViewControllers([vc], animated: false)
    }
}
// MARK: - StoreApp(登入後店長主頁-剩單純掃描)
//extension MemberNavigationViewController: StoreAppViewControllerDelegate {
//    func toQRScan(_ viewController: StoreAppViewController) {
//        let vc = QRCodeViewController()
//        vc.delegate = self
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: true, completion: nil)
//    }
//
//    func backToLogin(_ viewController: StoreAppViewController) {
//        let vc = LoginViewController_1()
//        setViewControllers([vc], animated: true)
//    }
//}

extension MemberNavigationViewController: MemberInfoViewController_1_Delegate {
    func memberInfoDidUpdate(_ viewController: MemberInfoViewController_1) {
        loadUserData()
    }
}

extension MemberNavigationViewController: QRCodeViewControllerDelegate {
    func didFinishScan(_ viewController: QRCodeViewController) {
        //
    }
}
