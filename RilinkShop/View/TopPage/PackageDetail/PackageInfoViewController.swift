//
//  PackageInfoViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/10.
//

import UIKit
import SwiftUI

enum PackageOrProduct: Int {
    case product
    case package
}

class PackageInfoViewController: UIViewController {

    @IBOutlet weak var packageImageView: UIImageView!
    @IBOutlet weak var packageNameLabel: UILabel!
    @IBOutlet weak var packageCostLabel: UILabel!
    @IBOutlet weak var itemNumberLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var stepperOuterView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var buyNowButton: UIButton!
    
    var cartButton = UIBarButtonItem() {
        didSet {
            cartButton.image = UIImage(systemName: "cart")
            cartButton.action = #selector(cartButtonAction(_:))
//            cartButton.setBadge()
        }
    }
    
    var itemNumber = 1 {
        didSet {
            itemNumberLabel.text = String(itemNumber)
        }
    }
    let maxValue = 10
    let minValue = 1
    let stepValue = 1
    
    var package = Package()
    var products = [PackageInfo]()
    let account = MyKeyChain.getAccount() ?? ""
    let password = MyKeyChain.getPassword() ?? ""
    
    var spec = PackageOrProduct.package
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        showItemInfo()
        print("@@@@@!")
        print(package.packageNo)
        print(spec.rawValue)
    }
    
    func configureView() {
        // stepper外圍
        stepperOuterView.backgroundColor = .systemGray6
        stepperOuterView.layer.cornerRadius = stepperOuterView.frame.height / 2
        // 加減
        plusButton.tintColor = UIColor(hex: "#4F846C")
        plusButton.backgroundColor = UIColor(hex: "#D6E5E2")
        plusButton.layer.borderColor = UIColor(hex: "#4F846C")?.cgColor
        plusButton.layer.borderWidth = 1
        plusButton.layer.cornerRadius = plusButton.frame.height / 2
        minusButton.tintColor = UIColor(hex: "#4F846C")
        minusButton.backgroundColor = UIColor(hex: "#D6E5E2")
        minusButton.layer.borderColor = UIColor(hex: "#4F846C")?.cgColor
        minusButton.layer.borderWidth = 1
        minusButton.layer.cornerRadius = minusButton.frame.height / 2
        // 中間的數字
        itemNumberLabel.backgroundColor = .clear
        // 下面兩個button
        addToCartButton.layer.cornerRadius = 10
        addToCartButton.layer.borderWidth = 1
        addToCartButton.layer.borderColor = UIColor(hex: "#4F846C")?.cgColor
        addToCartButton.tintColor = UIColor(hex: "#4F846C")
        buyNowButton.layer.cornerRadius = 10
        buyNowButton.tintColor = .white
        buyNowButton.backgroundColor = UIColor(hex: "#4F846C")
    }
    
    func showItemInfo() {
        ProductService.shared.loadPackageInfo(id: account, pwd: password, no: package.packageNo) { packagesResponse in
            self.products = packagesResponse
        }
        let imageURLString = SHOP_ROOT_URL + package.productPicture
        packageImageView.setImage(imageURL: imageURLString)
        packageNameLabel.text = package.productName
        packageCostLabel.text = package.productPrice
        descriptionLabel.text = package.productDescription
    }
    
    @objc func cartButtonAction(_ sender: UIBarButtonItem) {
        print("連進商城喔！")
    }
    
    @IBAction func itemNumberStepper(_ sender: UIButton) {
        if sender.tag == 0 {
            if itemNumber > minValue {
                itemNumber -= stepValue
            }
        } else if sender.tag == 1 {
            if itemNumber < maxValue {
                itemNumber += stepValue
            }
        }
    }
    // MARK: - 純新增至購物車
    @IBAction func addToCartButtonTapped(_ sender: UIButton) {
        HUD.showLoadingHUD(inView: self.view, text: "新增中")
        let no = self.package.packageNo
        let qty = self.itemNumberLabel.text
        let price = self.package.productPrice
        if let qty = qty,
           let qtyInt = Int(qty),
           let priceInt = Int(price) {
            let total = priceInt * qtyInt
            ProductService.shared.addShoppingCartItem(id: self.account,
                                                      pwd: self.password,
                                                      no: no,
                                                      spec: String(self.spec.rawValue),
                                                      price: price,
                                                      qty: qty,
                                                      total: String(total)) { success, response in
                DispatchQueue.global(qos: .userInitiated).async {
                    URLCache.shared.removeAllCachedResponses()
                    DispatchQueue.main.sync {
                        
                        guard success else {
                            HUD.hideLoadingHUD(inView: self.view)
                            let errorMsg = response as! String
                            Alert.showMessage(title: "", msg: errorMsg, vc: self, handler: nil)
                            return
                        }
                        
                        HUD.hideLoadingHUD(inView: self.view)
                        let message = "新增購物車成功"
                        Alert.showMessage(title: "", msg: message, vc: self, handler: nil)
                    }
                }
            }
        }
    }
    // MARK: - 新增至購物車兼換頁至購物車頁面
    @IBAction func buyNowButtonTapped(_ sender: UIButton) {
        HUD.showLoadingHUD(inView: self.view, text: "新增中")
        let no = package.packageNo
        let qty = itemNumberLabel.text
        let price = package.productPrice
        if let qty = qty,
           let qtyInt = Int(qty),
           let priceInt = Int(price) {
            let total = priceInt * qtyInt
            ProductService.shared.addShoppingCartItem(id: self.account,
                                                      pwd: self.password,
                                                      no: no,
                                                      spec: String(self.spec.rawValue),
                                                      price: price,
                                                      qty: qty,
                                                      total: String(total)) { success, response in
                DispatchQueue.global(qos: .userInitiated).async {
                    URLCache.shared.removeAllCachedResponses()
                    DispatchQueue.main.sync {
                        
                        guard success else {
                            HUD.hideLoadingHUD(inView: self.view)
                            let errorMsg = response as! String
                            Alert.showMessage(title: "", msg: errorMsg, vc: self, handler: nil)
                            return
                        }
                        
                        HUD.hideLoadingHUD(inView: self.view)
                        let message = "新增購物車成功"
                        Alert.showMessage(title: "", msg: message, vc: self) {
                            let vc = CartViewController()
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
        }
    }
}
