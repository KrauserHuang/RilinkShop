//
//  ProductDetailViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/25.
//

import UIKit

class ProductDetailViewController: UIViewController {

    @IBOutlet weak var ticketImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var itemNumberLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var substractButton: UIButton!
    @IBOutlet weak var stepperOuterView: UIView!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var buyNowButton: UIButton!
    
    var cartButton = UIBarButtonItem() {
        didSet {
            cartButton.image = UIImage(systemName: "cart")
            cartButton.action = #selector(cartButtonAction(_:))
            cartButton.setBadge()
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
        navigationItem.rightBarButtonItem = cartButton
//        cartButton.setBadge()
        
        configureView()
    }
    
    @objc func cartButtonAction(_ sender: UIBarButtonItem) {
        print("連進商城喔！")
    }
    
    func configureView() {
        stepperOuterView.backgroundColor = .systemGray
        stepperOuterView.layer.borderWidth = 1.0
        stepperOuterView.layer.borderColor = UIColor.systemGray.cgColor
        stepperOuterView.layer.cornerRadius = 5
        addButton.tintColor = .white
        substractButton.tintColor = .white
        itemNumberLabel.backgroundColor = .white
        addToCartButton.layer.cornerRadius = 10
        addToCartButton.layer.borderWidth = 1
        addToCartButton.layer.borderColor = UIColor(hex: "#54a0ff")?.cgColor
        addToCartButton.tintColor = UIColor(hex: "#54a0ff")
        buyNowButton.layer.cornerRadius = 10
        buyNowButton.tintColor = .white
        buyNowButton.backgroundColor = UIColor(hex: "#54a0ff")
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
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func buyNowButtonTapped(_ sender: UIButton) {
        let controller = CartViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
