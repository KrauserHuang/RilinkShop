//
//  MemberCenterViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/7/14.
//

import UIKit
import SwiftUI

class MemberCenterViewController: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var loginNameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var rPointButton: UIButton!
    
    static var newRPoint = ""
    
    var tableViewController: ContainerMemberCenterTableViewController?
    var user: User?
    let account = Global.ACCOUNT
    let password = Global.ACCOUNT_PASSWORD

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = false
        tableViewController = self.children[0] as? ContainerMemberCenterTableViewController
        tableViewController?.delegate = self
        
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        
        if Global.ACCOUNT != "" {
            loginButton.setTitle("登出", for: .normal)
            editButton.isHidden = false
        } else {
            loginButton.setTitle("登入", for: .normal)
            editButton.isHidden = true
        }
        
        guard Global.ACCOUNT.count != 7 else{return}
        
//        initUI()
    }
    
    func initUI() {
        navigationItems()
        //登入
        loginButton.layer.cornerRadius = 13
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.borderWidth = 1
        
        //編輯
        editButton.layer.cornerRadius = 13
        editButton.layer.borderColor = UIColor.white.cgColor
        editButton.layer.borderWidth = 1
        
        //背景
        bgView.layer.cornerRadius  = 55
        bgView.layer.maskedCorners = [.layerMaxXMinYCorner]
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOpacity = 0.2
        bgView.layer.shadowOffset = CGSize(width: 2, height: -2)
        
        //大頭照
        userImage.layer.cornerRadius = 36
        userImage.layer.borderColor = UIColor.white.cgColor
        userImage.layer.borderWidth = 1
        
        loadPersonalData()
    }
    
    func navigationItems() {
        let shoppingcartButton = UIBarButtonItem(image: UIImage(systemName: "cart"),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(toCartViewController))
        navigationItem.rightBarButtonItem = shoppingcartButton
    }
    @objc private func toCartViewController() {
        let vc = CartViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadPersonalData() {
        let accountType = "0"
        HUD.showLoadingHUD(inView: self.view, text: "載入中")
        UserService.shared.getPersonalData(account: account,
                                           pw: password,
                                           accountType: accountType) { success, response in
            DispatchQueue.global(qos: .userInitiated).async {
                URLCache.shared.removeAllCachedResponses()
                DispatchQueue.main.sync {
                    
                    HUD.hideLoadingHUD(inView: self.view)
                    
                    guard success else {
                        let errorMsg = response as! String
                        Alert.showMessage(title: "", msg: errorMsg, vc: self, handler: nil)
                        return
                    }
                    //load完更新使用者名稱/點數/使用者頭像
                    self.loginNameLabel.text = "Hi~ " + (Global.personalData?.name ?? "")
                    MemberCenterViewController.newRPoint = Global.personalData?.point ?? "0"
                    
                    self.rPointButton.setTitle(Global.personalData?.point, for: .normal)
                    
                    if Global.personalData?.cmdImageFile == nil || Global.personalData?.cmdImageFile == "" {
                        return
                    }
                    if let personalCMDImageFile = Global.personalData?.cmdImageFile {
                        self.userImage.setImage(imageURL: MEMBER_IMAGE_URL + personalCMDImageFile)
                    }
                }
            }
        }
    }
    
    func uploadImage() {
        if let image = userImage.image {
            HUD.showLoadingHUD(inView: self.view, text: "")
            UserService.shared.uploadImage(imgtitle: account,
                                           cmdImageFile: image) { success, response in
                DispatchQueue.global(qos: .userInitiated).async {
                    URLCache.shared.removeAllCachedResponses()
                    DispatchQueue.main.sync {
                        HUD.hideLoadingHUD(inView: self.view)
                        
                        guard success else {
                            let errorMsg = response as! String
                            Alert.showMessage(title: "", msg: errorMsg, vc: self, handler: nil)
                            return
                        }
                        
                        Alert.showMessage(title: "", msg: "修改成功", vc: self) {
                            self.dismiss(animated: true) {
                                //
                            }
                        }
                    }
                }
            }
        }
    }
    // MARK: - 更改使用者圖面
    @IBAction func userImageButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "請選擇照片來源", message: "", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "照相", style: .default) { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true
                imagePicker.delegate = self
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        alert.addAction(cameraAction)
        let photoLibAction = UIAlertAction(title: "圖庫", style: .default) { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true
                imagePicker.delegate = self
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        alert.addAction(photoLibAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        if Global.ACCOUNT != "" {
            Alert.showConfirm(title: "", msg: "確定要登出？", vc: self) {
                self.signOut()
            }
        } else {
//            let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
//            let vc = loginStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            
            let vc = LoginViewController_1()
            present(vc, animated: true, completion: nil)
        }
    }
    
    func signOut() {
        HUD.showLoadingHUD(inView: self.view, text: "登出中")
        UserService.shared.logout()
        HUD.hideLoadingHUD(inView: self.view)
        loginButton.setTitle("登入", for: .normal)
        editButton.isHidden = true
        loginNameLabel.text = "Hi~ 歡迎回來"
        rPointButton.setTitle("0", for: .normal)
        userImage.image = UIImage(named: "user_avatarxxhdpi")
    }
    // MARK: - 進使用者資料畫面
    @IBAction func editButtonTapped(_ sender: UIButton) {
        let vc = MemberInfoViewController_1()
        vc.user = Global.personalData
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func rPointButtonTapped(_ sender: UIButton) {
        //沒作用
    }
    // MARK: - 我的票券頁面
    @IBAction func myTicketButtonTapped(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Ticket", bundle: nil).instantiateViewController(withIdentifier: "Ticket")
        present(vc, animated: true, completion: nil)
    }
    // MARK: - 點數紀錄頁面
    @IBAction func pointHistoryButtonTapped(_ sender: UIButton) {
        let vc = PointViewController()
        present(vc, animated: true, completion: nil)
    }
}
// MARK: - ContainerMemberCenterTableViewControllerDelegate
extension MemberCenterViewController: ContainerMemberCenterTableViewControllerDelegate {
    //我的訂單頁面
    func myOrder(_ viewController: ContainerMemberCenterTableViewController) {
        let vc = MyOrderTableViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    //常見問題頁面(還未開放)
    func question(_ viewController: ContainerMemberCenterTableViewController) {
        Alert.showSecurityAlert(title: "", msg: "敬請期待", vc: self, handler: nil)
    }
    //聯絡客服頁面(還未開放)
    func customerService(_ viewController: ContainerMemberCenterTableViewController) {
        Alert.showSecurityAlert(title: "", msg: "敬請期待", vc: self, handler: nil)
    }
    //協議及聲明頁面(還未開放)
    func statement(_ viewController: ContainerMemberCenterTableViewController) {
        Alert.showSecurityAlert(title: "", msg: "敬請期待", vc: self, handler: nil)
    }
}
// MARK: - MemberInfoViewController_1_Delegate
extension MemberCenterViewController: MemberInfoViewController_1_Delegate {
    func memberInfoDidUpdate(_ viewController: MemberInfoViewController_1) {
        //
    }
}
// MARK: - UIImagePickerControllerDelegate/UINavigationControllerDelegate
extension MemberCenterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = (info[.editedImage] as? UIImage)?.imageResized(to: userImage.frame.size) {
            dismiss(animated: true) {
                self.userImage.backgroundColor = .clear
                self.userImage.image = image
                self.uploadImage()
            }
        }
    }
}
