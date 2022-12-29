//
//  CartViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/25.
//

import UIKit
import MBProgressHUD

class CartViewController: UIViewController {

    @IBOutlet weak var noItemView: UIView! {
        didSet {
            noItemView.isHidden = true
        }
    }
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var ruleButton: UIButton!
    @IBOutlet weak var clearAllButton: UIButton!
    @IBOutlet weak var keepBuyButton: UIButton!
    @IBOutlet weak var checkoutButton: UIButton!

    var inCartItems = [Product]() {
        didSet {
            DispatchQueue.main.async {
                self.cartTableView.reloadData()
            }
        }
    }
    var total = 0
    var account = MyKeyChain.getAccount() ?? ""
    var password = MyKeyChain.getPassword() ?? ""
//    var account: String!
//    var password: String!
    
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

        navigationItem.backButtonTitle = ""
        loadInCartItems()
        configureTableView()
        configureView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadInCartItems()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        agreeButton.isSelected = false
    }
    // 載入購物車資料
    func loadInCartItems() {
//        let indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
//        indicator.isUserInteractionEnabled = false
//        indicator.show(animated: true)
//        cartTableView.isHidden = true
        HUD.showLoadingHUD(inView: self.view, text: "")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ProductService.shared.loadShoppingCartList(id: self.account, pwd: self.password) { items in
                HUD.hideLoadingHUD(inView: self.view)
                self.inCartItems = items
//                self.cartTableView.isHidden = false
//                print(#function)
//                print(items)
//                indicator.hide(animated: true)

//                self.noItemView.isHidden = self.inCartItems.isEmpty ? false : true
                self.noItemView.isHidden = self.inCartItems.count != 0
            }
            ProductService.shared.getShoppingCartCount(id: self.account, pwd: self.password) { response in
                self.noItemView.isHidden = response.responseMessage == "0" ? false : true
            }
        }
    }
    // tableView相關設定
    func configureTableView() {
        cartTableView.delegate = self
        cartTableView.dataSource = self
        cartTableView.register(UINib(nibName: CartTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: CartTableViewCell.reuseIdentifier)
        cartTableView.separatorStyle = .none
    }
    // 其餘view設定
    func configureView() {
        agreeButton.tintColor = .primaryOrange
        ruleButton.titleLabel?.tintColor = .primaryOrange
        clearAllButton.layer.borderColor = UIColor.primaryOrange.cgColor
        clearAllButton.layer.borderWidth = 1
        clearAllButton.layer.cornerRadius = 10
        clearAllButton.tintColor = .primaryOrange
        keepBuyButton.layer.borderColor = UIColor.primaryOrange.cgColor
        keepBuyButton.layer.borderWidth = 1
        keepBuyButton.layer.cornerRadius = 10
        keepBuyButton.tintColor = .primaryOrange
        checkoutButton.layer.cornerRadius = 10
        checkoutButton.backgroundColor = .primaryOrange
        checkoutButton.tintColor = .white
    }

    @IBAction func agreeAction(_ sender: UIButton) {
        sender.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        sender.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        sender.isSelected.toggle()
    }

    @IBAction func shopRuleButtonTapped(_ sender: UIButton) {
        let controller = ShopRuleViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    // 清除
    @IBAction func clearAllButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "是否清除全部", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "清除", style: .destructive) { _ in
            ProductService.shared.clearShoppingCartItem(id: self.account, pwd: self.password) { _ in }
            self.inCartItems.removeAll()
            ProductService.shared.inCartItems = self.inCartItems
            self.noItemView.isHidden = self.inCartItems.isEmpty ? false : true
        }
        let noAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(noAction)
        present(alertController, animated: true, completion: nil)
    }
    // 繼續購買應該回到購買頁面首頁？
    @IBAction func keepBuyButtonTapped(_ sender: UIButton) {
        if let controllers = navigationController?.viewControllers {
            for controller in controllers {
                switch controller {
                case is ShopMainViewController:
                    navigationController?.popToViewController(controller, animated: true)
                case is TopPageMainViewController:
                    navigationController?.popToViewController(controller, animated: true)
                case is MemberCenterViewController:
                    navigationController?.popToViewController(controller, animated: true)
                default:
                    break
                }
            }
        }
    }

    @IBAction func checkoutButtonTapped(_ sender: UIButton) {
        /*
         一段確認購物車有沒有東西決定是否進結帳頁
         二段判斷購物條款有沒有閱讀同意，有的話會將inCartItems的資訊傳到扣款頁
         三段將各項目的total_amount加在一起顯示在結帳頁
         */
        guard !inCartItems.isEmpty else {
            let alertController = UIAlertController.simpleOKAlert(title: "", message: "購物車沒東西喔", buttonTitle: "確認", action: nil)
            present(alertController, animated: true, completion: nil)
            return
        }
        guard agreeButton.isSelected else {
            let alertController = UIAlertController.simpleOKAlert(title: "", message: "請確認是否已詳細閱讀購物條款", buttonTitle: "確認", action: nil)
            present(alertController, animated: true, completion: nil)
            return
        }
        let controller = CheckoutViewController(account: account, password: password)
        total = inCartItems.reduce(0, { result, product in
            result + Int(product.total_amount)!
        })
        controller.orderAmount = total
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inCartItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.reuseIdentifier, for: indexPath) as! CartTableViewCell

        cell.delegate = self
        let inCartItem = inCartItems[indexPath.row]
        cell.configure(with: inCartItem)

        return cell
    }
}
// MARK: - Cell Delegate
extension CartViewController: CartTableViewCellDelegate {
    func didAddQty(_ cell: CartTableViewCell) {
        guard let indexPath = cartTableView.indexPath(for: cell) else { return }

        let no = inCartItems[indexPath.row].product_no
        var qty = Int(inCartItems[indexPath.row].order_qty)!
        print(#function)
        print(inCartItems[indexPath.row].product_stock)
        let stock = Int(inCartItems[indexPath.row].product_stock)!

        if qty < stock {
            qty += 1
            HUD.showLoadingHUD(inView: self.view, text: "")
            ProductService.shared.editShoppingCartItem(id: account, pwd: password, no: no, qty: qty) { (success, response) in
                DispatchQueue.global(qos: .userInitiated).async {
                    URLCache.shared.removeAllCachedResponses()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        guard success else {
                            HUD.hideLoadingHUD(inView: self.view)
                            let errmsg = response as! String
                            Alert.showMessage(title: "", msg: errmsg, vc: self)
                            return
                        }

                        HUD.hideLoadingHUD(inView: self.view)
                        ProductService.shared.loadShoppingCartList(id: self.account, pwd: self.password) { products in
                            self.inCartItems = products
                            let item = self.inCartItems[indexPath.row]
                            cell.configure(with: item)
                            self.viewDidLayoutSubviews()
                        }
                    }
                }
            }
        } else {
            Alert.showMessage(title: "超過庫存數量", msg: "", vc: self)
        }
    }

    func didSubstractQty(_ cell: CartTableViewCell) {
        guard let indexPath = cartTableView.indexPath(for: cell) else { return }

        let no = inCartItems[indexPath.row].product_no
        var qty = Int(inCartItems[indexPath.row].order_qty)!

        if qty == 1 {
            removeItem(cell)
        } else if qty > 1 {
            qty -= 1

            HUD.showLoadingHUD(inView: self.view, text: "")
            ProductService.shared.editShoppingCartItem(id: account, pwd: password, no: no, qty: qty) { (success, response) in
                DispatchQueue.global(qos: .userInitiated).async {
                    URLCache.shared.removeAllCachedResponses()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {

                        guard success else {
                            HUD.hideLoadingHUD(inView: self.view)
                            let errmsg = response as! String
                            Alert.showMessage(title: "", msg: errmsg, vc: self)
                            return
                        }

                        HUD.hideLoadingHUD(inView: self.view)
                        ProductService.shared.loadShoppingCartList(id: self.account, pwd: self.password) { products in
                            self.inCartItems = products
                            let item = self.inCartItems[indexPath.row]
                            cell.configure(with: item)
                            self.viewDidLayoutSubviews()
                        }
                    }
                }
            }
        }
    }

    func removeItem(_ cell: CartTableViewCell) {
        guard let indexPath = cartTableView.indexPath(for: cell) else { return }

        let alertController = UIAlertController(title: "", message: "確定要刪除此商品？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確認", style: .default) { _ in
            let no = self.inCartItems[indexPath.row].product_no
            ProductService.shared.removeShoppingCartItem(id: self.account, pwd: self.password, no: no) { _ in }
            self.inCartItems.remove(at: indexPath.row)
            ProductService.shared.inCartItems = self.inCartItems
            self.cartTableView.beginUpdates()
            self.cartTableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
            self.cartTableView.endUpdates()
            self.noItemView.isHidden = self.inCartItems.isEmpty ? false : true
        }
        let noAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(noAction)
        present(alertController, animated: true, completion: nil)
    }
}
