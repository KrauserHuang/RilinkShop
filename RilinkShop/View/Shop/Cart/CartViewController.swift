//
//  CartViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/25.
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var clearAllButton: UIButton!
    @IBOutlet weak var keepBuyButton: UIButton!
    @IBOutlet weak var checkoutButton: UIButton!
    
    var inCartItems = [Product]()
    {
        didSet {
            DispatchQueue.main.async {
                self.cartTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureTableView()
        configureView()
    }
    
    func configureTableView() {
        cartTableView.delegate = self
        cartTableView.dataSource = self
        cartTableView.register(UINib(nibName: CartTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: CartTableViewCell.reuseIdentifier)
        cartTableView.separatorStyle = .none
    }
    
    func configureView() {
        clearAllButton.layer.borderColor = UIColor(hex: "#54a0ff")?.cgColor
        clearAllButton.layer.borderWidth = 1
        clearAllButton.layer.cornerRadius = 10
        clearAllButton.tintColor = UIColor(hex: "#54a0ff")
        keepBuyButton.layer.borderColor = UIColor(hex: "#54a0ff")?.cgColor
        keepBuyButton.layer.borderWidth = 1
        keepBuyButton.layer.cornerRadius = 10
        keepBuyButton.tintColor = UIColor(hex: "#54a0ff")
        checkoutButton.layer.cornerRadius = 10
        checkoutButton.backgroundColor = UIColor(hex: "#54a0ff")
        checkoutButton.tintColor = .white
    }
    
    @IBAction func shopRuleButtonTapped(_ sender: UIButton) {
        let controller = ShopRuleViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func clearAllButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "是否清除全部", message: "There's no turnig back!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "清除", style: .destructive, handler: nil)
        let noAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(noAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func agreeAction(_ sender: UIButton) {
//        sender.setImage(UIImage(named: "check_icon_2"), for: .normal)
//        sender.setImage(UIImage(named: "check_icon"), for: .selected)
        sender.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        sender.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        sender.isSelected.toggle()
    }
    
    @IBAction func keepBuyButtonTapped(_ sender: UIButton) {
//        self.navigationController?.popToRootViewController(animated: true)
        if let controllers = navigationController?.viewControllers {
            for controller in controllers {
                switch controller {
                case is ShopViewController:
                    navigationController?.popToViewController(controller, animated: true)
                case is TopPageViewController:
                    navigationController?.popToViewController(controller, animated: true)
                case is MemberCenterTableViewController:
                    navigationController?.popToViewController(controller, animated: true)
                default:
                    break
                }
            }
        }
    }
    
    @IBAction func checkoutButtonTapped(_ sender: UIButton) {
//        guard !inCartItems.isEmpty else { // 一段確認購物車有沒有東西決定是否進結帳頁
//            let alertController = UIAlertController.simpleOKAlert(title: "", message: "購物車沒東西喔", buttonTitle: "確認", action: nil)
//            present(alertController, animated: true, completion: nil)
//            return
//        }
        guard agreeButton.isSelected else { // 二段判斷購物條款有沒有閱讀同意，有的話會將inCartItems的資訊傳到扣款頁
            let alertController = UIAlertController.simpleOKAlert(title: "", message: "請確認是否已詳細閱讀購物條款", buttonTitle: "確認", action: nil)
            present(alertController, animated: true, completion: nil)
            return
        }
        let controller = CheckoutViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
 
    
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.reuseIdentifier, for: indexPath) as! CartTableViewCell
        
        cell.delegate = self
        cell.configure()
        
        return cell
    }
}
// MARK: - Cell Delegate
extension CartViewController: CartTableViewCellDelegate {
    func removeItem(_ cell: CartTableViewCell) {
//        guard let indexPath = cartTableView.indexPath(for: cell) else { return }
        
        let alertController = UIAlertController(title: "", message: "確定要刪除此商品？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確認", style: .default, handler: nil)
        let noAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(noAction)
        present(alertController, animated: true, completion: nil)
    }
}
