//
//  ProductDetailViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/25.
//

import UIKit
import Kingfisher

class ProductDetailViewController: UIViewController {

    @IBOutlet weak var ticketImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var itemNumberLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var substractButton: UIButton!
    @IBOutlet weak var stepperOuterView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var buyNowButton: UIButton!
    
    var cartButton = UIBarButtonItem() {
        didSet {
            cartButton.image = UIImage(systemName: "cart")
            cartButton.action = #selector(cartButtonAction(_:))
            cartButton.setBadge()
        }
    }
    var itemInfo = Product()
    
    var itemNumber = 1 {
        didSet {
            itemNumberLabel.text = String(itemNumber)
        }
    }
    let maxValue = 10
    let minValue = 1
    let stepValue = 1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.hidesBottomBarWhenPushed = true
        self.tabBarController?.tabBar.isHidden = true
//        self.automaticallyAdjustsScrollViewInsets = false
//        self.listTableView.contentInsetAdjustmentBehavior = .automatic
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(cartButtonAction(_:)))
//        navigationItem.rightBarButtonItem?.tintColor = .darkGray
//        navigationItem.rightBarButtonItem?.setBadge()
//        cartButton = UIBarButtonItem()
        navigationItem.backButtonTitle = ""
        navigationItem.rightBarButtonItem = cartButton
//        cartButton.setBadge()
        
        configureView()
        showItemInfo()
    }
    
    @objc func cartButtonAction(_ sender: UIBarButtonItem) {
        print("連進商城喔！")
    }
    
    func configureView() {
        // stepper外圍
        stepperOuterView.backgroundColor = .systemGray6
        stepperOuterView.layer.cornerRadius = stepperOuterView.frame.height / 2
        // 加減
        addButton.tintColor = UIColor(hex: "#4F846C")
        addButton.backgroundColor = UIColor(hex: "#D6E5E2")
        addButton.layer.borderColor = UIColor(hex: "#4F846C")?.cgColor
        addButton.layer.borderWidth = 1
        addButton.layer.cornerRadius = addButton.frame.height / 2
        substractButton.tintColor = UIColor(hex: "#4F846C")
        substractButton.backgroundColor = UIColor(hex: "#D6E5E2")
        substractButton.layer.borderColor = UIColor(hex: "#4F846C")?.cgColor
        substractButton.layer.borderWidth = 1
        substractButton.layer.cornerRadius = substractButton.frame.height / 2
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
//        ProductService.shared.loadProductInfo(id: "0911838460", pw: "simon07801", no: itemInfo.product_no) { product in
            ProductService.shared.loadProductInfo(id: "0910619306", pw: "a12345678", no: itemInfo.product_no) { product in
            self.itemInfo = product
            self.nameLabel.text = self.itemInfo.product_name
            self.costLabel.text = "$\(self.itemInfo.product_price)"
            self.descriptionLabel.text = self.itemInfo.product_description
            
            if let imageURL = URL(string: TEST_ROOT_URL + self.itemInfo.product_picture) { // test
                self.ticketImageView.isHidden = false
                self.ticketImageView.kf.setImage(with: imageURL)
            } else {
                self.ticketImageView.isHidden = true
            }
        }
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
    @IBAction func addToCartButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "加入購物車成功", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let no = self.itemInfo.product_no
            let qty = self.itemNumberLabel.text
            let price = self.itemInfo.product_price
            if let qty = qty,
               let qtyInt = Int(qty),
               let priceInt = Int(price) {
                let total = priceInt * qtyInt
                ProductService.shared.addShoppingCartItem(id: "0910619306",
                                                          pwd: "a12345678",
                                                          no: no,
                                                          spec: "0",
                                                          price: price,
                                                          qty: qty,
                                                          total: String(total)) { _ in
                }
            }
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func buyNowButtonTapped(_ sender: UIButton) {
        let no = itemInfo.product_no
        let qty = itemNumberLabel.text
        let price = itemInfo.product_price
        if let qty = qty,
           let qtyInt = Int(qty),
           let priceInt = Int(price) {
            let total = priceInt * qtyInt
            ProductService.shared.addShoppingCartItem(id: "0910619306",
                                                      pwd: "a12345678",
                                                      no: no,
                                                      spec: "0",
                                                      price: price,
                                                      qty: qty,
                                                      total: String(total)) { _ in
            }
        }
        let controller = CartViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
