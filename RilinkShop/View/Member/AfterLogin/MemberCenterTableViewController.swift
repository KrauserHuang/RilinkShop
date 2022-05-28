//
//  MemberCenterTableViewController.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/6.
//

import UIKit
import SwiftUI

protocol MemberCenterTableViewControllerDelegate: AnyObject {
    func memberInfo(_ viewController: MemberCenterTableViewController)
    func myTicket(_ viewController: MemberCenterTableViewController)
    func coupon(_ viewController: MemberCenterTableViewController)
    func point(_ viewController: MemberCenterTableViewController)
    func privateRule(_ viewController: MemberCenterTableViewController)
    func question(_ viewController: MemberCenterTableViewController)
    func logout(_ viewController: MemberCenterTableViewController)
    func memberInfoDidUpdate(_ viewController: MemberCenterTableViewController)
}

class MemberCenterTableViewController: UITableViewController {
    
    @IBOutlet weak var cartButton: UIBarButtonItem!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var camera: UIButton!
    
    weak var delegate: MemberCenterTableViewControllerDelegate?
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = false
        self.tableView.rowHeight = 48
        
        userImage.layer.cornerRadius = userImage.frame.height / 2
        camera.layer.cornerRadius = camera.frame.height / 2
//        cartButton.setBadge()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        if Global.personalData?.cmdImageFile == nil || Global.personalData?.cmdImageFile == "" {
            return
        }
        if let personalCMDImageFile = Global.personalData?.cmdImageFile {
            self.userImage?.setImage(imageURL: MEMBER_IMAGE_URL + personalCMDImageFile)
        }
    }
    
    func uploadImage() {
        if let image = userImage.image {
            
//            let resizeImage = image.imageResized(to: <#T##CGSize#>)
            HUD.showLoadingHUD(inView: self.view, text: "")
            UserService.shared.uploadImage(imgtitle: Global.ACCOUNT, cmdImageFile: image) { success, response in
                DispatchQueue.global(qos: .userInitiated).async {
                    URLCache.shared.removeAllCachedResponses()
                    DispatchQueue.main.sync {
                        HUD.hideLoadingHUD(inView: self.view)
                        
                        guard success else {
                            if let errorMsg = response as? String {
                                Alert.showMessage(title: "", msg: errorMsg, vc: self)
                            }
                            return
                        }
                        
                        Alert.showMessage(title: "", msg: "修改成功", vc: self) {
                            self.dismiss(animated: true) {
                                self.delegate?.memberInfoDidUpdate(self)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func cameraAction(_ sender: UIButton) {
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
    // 至訂單頁面
    @IBAction func myOrderAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(MyOrderTableViewController(), animated: true)
    }
    // 2022/5/12 -> 收起來沒用
    @IBAction func myCollectionAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(MyCollectionViewController(), animated: true)
    }
    // 2022/5/12 -> 收起來沒用
    @IBAction func cnosumptionAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(ConsumptionRecordViewController(), animated: true)
    }
    
    @IBAction func toCartVC(_ sender: UIBarButtonItem) {
        let cartVC = CartViewController()
        navigationController?.pushViewController(cartVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            delegate?.memberInfo(self)
        case 1:
            delegate?.myTicket(self)
        case 2:
            delegate?.coupon(self)
        case 3:
            delegate?.point(self)
        case 4:
            delegate?.privateRule(self)
        case 5:
            delegate?.question(self)
        case 6:
            delegate?.logout(self)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return 0
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerHeight: CGFloat

            switch section {
            case 0:
                // hide the header
                headerHeight = CGFloat.leastNonzeroMagnitude
            case 1:
                // section2 height
                headerHeight = 150
            default:
                headerHeight = 21
            }
            return headerHeight
    }
}

extension MemberCenterTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = (info[.editedImage] as? UIImage)?.imageResized(to: userImage.frame.size) {
            dismiss(animated: true) {
                self.userImage.backgroundColor = .clear
                self.userImage.image = image
                self.uploadImage()
            }
            
//            delegate?.headImageAction(self, image: image)
        }
    }
}
