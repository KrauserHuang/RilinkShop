//
//  ProductDetailViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/25.
//

import UIKit
import Kingfisher
import SwiftUI

class ProductDetailViewController: UIViewController {

    @IBOutlet weak var ticketImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var itemNumberLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var substractButton: UIButton!
    @IBOutlet weak var stepperOuterView: UIView!
    @IBOutlet weak var descriptionView: UIView!
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
    var itemInfo: Item?
    var products = [PackageInfo]() // 由於有些資訊取用package有些取用package內的product(ex: stock)
    var itemNumber = 1 {
        didSet {
            itemNumberLabel.text = String(itemNumber)
        }
    }
    let maxValue = 10
    let minValue = 1
    let stepValue = 1
    var stock = Int()
    var account = MyKeyChain.getAccount() ?? ""
    var password = MyKeyChain.getPassword() ?? ""
    var spec = PackageOrProduct.product
    var productNo = String()
    var producrPrice = String()
    var productStockMin = String()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.hidesBottomBarWhenPushed = true
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backButtonTitle = ""
        navigationItem.rightBarButtonItem = cartButton

        configureView()
        showItemInfo()
    }

    @objc func cartButtonAction(_ sender: UIBarButtonItem) {
        print("連進商城喔！")
    }

    func configureView() {
        ticketImageView.layer.cornerRadius = 10
        // stepper外圍
        stepperOuterView.backgroundColor = .systemGray6
        stepperOuterView.layer.cornerRadius = stepperOuterView.frame.height / 2
        // 加減
        addButton.tintColor = .white
        addButton.backgroundColor = Theme.customOrange
        addButton.layer.cornerRadius = addButton.frame.height / 2
        substractButton.tintColor = .white
        substractButton.backgroundColor = Theme.customOrange
        substractButton.layer.cornerRadius = substractButton.frame.height / 2
        // 中間的數字
        itemNumberLabel.backgroundColor = .clear
        // 商品敘述View
        descriptionView.layer.shadowColor = UIColor.black.cgColor
        descriptionView.layer.shadowOpacity = 0.2
        descriptionView.layer.shadowOffset = CGSize(width: 2, height: -2)
        // 下面兩個button
        addToCartButton.layer.cornerRadius = 10
        addToCartButton.layer.borderWidth = 1
        addToCartButton.layer.borderColor = Theme.customOrange.cgColor
        addToCartButton.tintColor = Theme.customOrange
        buyNowButton.layer.cornerRadius = 10
        buyNowButton.tintColor = .white
        buyNowButton.backgroundColor = Theme.customOrange
    }

    func showItemInfo() {
        switch itemInfo {
        case .product(let product):
            ProductService.shared.loadProductInfo(id: account, pw: password, no: product.product_no) { productResponse in
                self.stock = Int(productResponse.product_stock)!
                self.nameLabel.text = productResponse.product_name
                self.costLabel.text = "NT$：\(productResponse.product_price)"
                self.descriptionLabel.text = productResponse.product_description

                if let imageURL = URL(string: SHOP_ROOT_URL + productResponse.product_picture) { // test
                    self.ticketImageView.isHidden = false
                    self.ticketImageView.kf.setImage(with: imageURL)
                } else {
                    self.ticketImageView.isHidden = true
                }

                if self.stock == 0 {
                    self.addToCartButton.isHidden = true
                    self.buyNowButton.setTitle("備貨中", for: .normal)
                    self.buyNowButton.backgroundColor = .lightGray
                    self.buyNowButton.isUserInteractionEnabled = false
                }
            }
        case .package(let package):
            ProductService.shared.loadPackageInfo(id: account, pwd: password, no: package.packageNo) { packageResponse in
                self.products = packageResponse
                // 設定庫存，將package內的product的stock取出，並重整將stock最少的product擺在前面取出，最後變數stock將取出的最少庫存數量存入
//                let productStock = self.products.map { $0.productStock }
//                self.productStockMin = productStock.sorted { $0 < $1 }.first!
//                self.stock = Int(self.productStockMin)!
            }
            let imageURLString = SHOP_ROOT_URL + package.productPicture
            ticketImageView.setImage(imageURL: imageURLString)
            stock = Int(package.productStock)!
            nameLabel.text = package.productName
            costLabel.text = "NT$：\(package.productPrice)"
            descriptionLabel.text = package.productDescription

            if self.stock == 0 {
                self.addToCartButton.isHidden = true
                self.buyNowButton.setTitle("備貨中", for: .normal)
                self.buyNowButton.backgroundColor = .lightGray
                self.buyNowButton.isUserInteractionEnabled = false
            } else {
                // 有庫存，沒事的
                print("stock:\(self.stock)")
            }
        case .none:
            break
        }
    }

    @IBAction func itemNumberStepper(_ sender: UIButton) {
        if sender.tag == 0 { // 點minus
            if itemNumber > minValue {
                itemNumber -= stepValue
            }
        } else if sender.tag == 1 { // 點plus
            print(#function)
            print("stock:\(stock)")
            if itemNumber < stock {
                itemNumber += stepValue
            } else {
                Alert.showMessage(title: "超過庫存數量", msg: "", vc: self) {
//                    self.addToCartButton.isHidden = true
//                    self.buyNowButton.setTitle("備貨中", for: .normal)
//                    self.buyNowButton.backgroundColor = .lightGray
//                    self.buyNowButton.isUserInteractionEnabled = false
                }
            }
        }
    }
    // MARK: - 純新增至購物車
    @IBAction func addToCartButtonTapped(_ sender: UIButton) {
        HUD.showLoadingHUD(inView: self.view, text: "新增中")
        switch self.itemInfo {
        case .product(let product):
            self.productNo = product.product_no
            self.producrPrice = product.product_price
            self.spec = PackageOrProduct.product
        case .package(let package):
            self.productNo = package.packageNo
            self.producrPrice = package.productPrice
            self.spec = PackageOrProduct.package
        case .none:
            break
        }
        // 數量
        let qty = itemNumberLabel.text
        if let qty = qty,
           let qtyInt = Int(qty),
           let priceInt = Int(producrPrice) {
            let total = priceInt * qtyInt
            ProductService.shared.addShoppingCartItem(id: self.account,
                                                      pwd: self.password,
                                                      no: self.productNo,
                                                      spec: String(self.spec.rawValue),
                                                      price: self.producrPrice,
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
        switch self.itemInfo {
        case .product(let product):
            productNo = product.product_no
            producrPrice = product.product_price
            spec = PackageOrProduct.product
        case .package(let package):
            productNo = package.packageNo
            producrPrice = package.productPrice
            spec = PackageOrProduct.package
        case .none:
            break
        }
        let qty = itemNumberLabel.text
        if let qty = qty,
           let qtyInt = Int(qty),
           let priceInt = Int(producrPrice) {
            let total = priceInt * qtyInt
            ProductService.shared.addShoppingCartItem(id: account,
                                                      pwd: password,
                                                      no: productNo,
                                                      spec: String(spec.rawValue),
                                                      price: producrPrice,
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
                            let vc = CartViewController()
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
        }
    }
}
