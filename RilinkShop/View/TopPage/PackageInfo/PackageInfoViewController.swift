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
    @IBOutlet weak var substractButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var stepperOuterView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var buyNowButton: UIButton!

    var cartButton = UIBarButtonItem() {
        didSet {
            cartButton.image = UIImage(systemName: "cart")
            cartButton.action = #selector(cartButtonAction(_:))
        }
    }
    var package = Package()
    var products = [PackageInfo]()
    var itemNumber = 1 {
        didSet {
            itemNumberLabel.text = String(itemNumber)
        }
    }
    let maxValue        = 10
    let minValue        = 1
    let stepValue       = 1
    var stock           = Int()
    var account         = MyKeyChain.getAccount() ?? ""
    var password        = MyKeyChain.getPassword() ?? ""
    var spec            = PackageOrProduct.package
    var productNo       = String()
    var producrPrice    = String()
    var productStockMin = String()
    
//    var account: String!
//    var password: String!
//    
//    init(account: String, password: String) {
//        super.init(nibName: nil, bundle: nil)
//        self.account = account
//        self.password = password
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        showItemInfo()
    }

    private func configureView() {
        packageImageView.layer.cornerRadius = 10
        // stepper外圍
        stepperOuterView.backgroundColor    = .systemGray6
        stepperOuterView.layer.cornerRadius = stepperOuterView.frame.height / 2
        // 加減
        addButton.tintColor                 = .white
        addButton.backgroundColor           = .primaryOrange
        addButton.layer.cornerRadius        = addButton.frame.height / 2
        substractButton.tintColor           = .white
        substractButton.backgroundColor     = .primaryOrange
        substractButton.layer.cornerRadius  = substractButton.frame.height / 2
        // 中間的數字
        itemNumberLabel.backgroundColor     = .clear
        // 商品敘述View
        descriptionView.layer.shadowColor   = UIColor.black.cgColor
        descriptionView.layer.shadowOpacity = 0.2
        descriptionView.layer.shadowOffset  = CGSize(width: 2, height: -2)
        // 下面兩個button
        addToCartButton.layer.cornerRadius  = 10
        addToCartButton.layer.borderWidth   = 1
        addToCartButton.layer.borderColor   = UIColor.primaryOrange.cgColor
        addToCartButton.tintColor           = .primaryOrange
        buyNowButton.layer.cornerRadius     = 10
        buyNowButton.tintColor              = .white
        buyNowButton.backgroundColor        = .primaryOrange
    }

    private func showItemInfo() {
        ProductService.shared.loadPackageInfo(id: account, pwd: password, no: package.packageNo) { packagesResponse in
            self.products = packagesResponse
            // 設定庫存，將package內的product的stock取出，並重整將stock最少的product擺在前面取出，最後變數stock將取出的最少庫存數量存入
//            let productStock = self.products.map { $0.productStock }
//            self.productStockMin = productStock.sorted { $0 < $1 }.first!
//            self.stock = Int(self.productStockMin)!

//            if self.stock == 0 {
//                self.addToCartButton.isHidden = true
//                self.buyNowButton.setTitle("備貨中", for: .normal)
//                self.buyNowButton.backgroundColor = .lightGray
//                self.buyNowButton.isUserInteractionEnabled = false
//            } else {
//                //有庫存，沒事的
//                print("stock:\(self.stock)")
//            }
        }
        
        stock                   = Int(package.productStock)!
        packageNameLabel.text   = package.productName
        packageCostLabel.text   = "NT$：\(package.productPrice)"
        descriptionLabel.text   = package.productDescription
        let imageURLString      = SHOP_ROOT_URL + package.productPicture
        packageImageView.setImage(with: imageURLString)

        if self.stock == 0 {
            self.addToCartButton.isHidden = true
            self.buyNowButton.setTitle("備貨中", for: .normal)
            self.buyNowButton.backgroundColor = .lightGray
            self.buyNowButton.isUserInteractionEnabled = false
        } else {
            // 有庫存，沒事的
            print("stock:\(self.stock)")
        }
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
            print(#function)
            print("stock:\(stock)")
            if itemNumber < stock {
                itemNumber += stepValue
            } else {
                Alert.showMessage(title: "超過庫存數量", msg: "", vc: self) {
                    //
                }
            }
        }
    }
    // MARK: - 純新增至購物車
    @IBAction func addToCartButtonTapped(_ sender: UIButton) {
        HUD.showLoadingHUD(inView: self.view, text: "新增中")
        let no = package.packageNo
        let price = package.productPrice
        let qty = itemNumberLabel.text
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
                        let title = "新增購物車成功"
                        let message = "請儘速完成付款，商品於購物車中僅留存3天"
                        Alert.showMessage(title: title, msg: message, vc: self, handler: nil)
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
                        let title = "新增購物車成功"
                        let message = "請儘速完成付款，商品於購物車中僅留存3天"
                        Alert.showMessage(title: title, msg: message, vc: self) {
//                            let vc = CartViewController(account: self.account, password: self.password)
                            let vc = CartViewController()
                            self.navigationController?.pushViewController(vc, animated: true)

                        }
                    }
                }
            }
        }
    }
}
