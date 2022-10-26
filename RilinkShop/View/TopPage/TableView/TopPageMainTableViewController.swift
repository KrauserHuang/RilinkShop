//
//  TopPageMainTableViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/9/14.
//

import UIKit
import SafariServices

class TopPageMainTableViewController: UITableViewController {

    var account = MyKeyChain.getAccount() ?? ""
    var password = MyKeyChain.getPassword() ?? ""
    var packages = [Package]()

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }

        navigationItems()
        configureTableView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TopPageStoreTableViewCell.cellIdentifier()), for: indexPath) as! TopPageStoreTableViewCell
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TopPageOptionTableViewCell.cellIdentifier()), for: indexPath) as! TopPageOptionTableViewCell
            cell.delegate = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TopPagePackageTableViewCell.cellIdentifier()), for: indexPath) as! TopPagePackageTableViewCell
            cell.delegate = self
            cell.frame = tableView.bounds
            return cell
        default:
            return UITableViewCell()
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 263
        case 1:
            return 100
        case 2:
//            return UITableView.automaticDimension
//            return 260
            print("packages.count:\(packages.count)")
            return CGFloat(((self.packages.count / 2) + 1) * 260)
        default:
            return 0
        }
    }

//    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
////        return 260
//    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: tableView.frame.width,
                                              height: 40))

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemGray

        let separatorLine = UIView()
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorLine.backgroundColor = .systemGray

        let headerStackView = UIStackView()
        headerStackView.axis = .horizontal
        headerStackView.alignment = .center
        headerStackView.distribution = .fill
        headerStackView.spacing = 10
        headerStackView.translatesAutoresizingMaskIntoConstraints = false

        headerStackView.addArrangedSubview(label)
        headerStackView.addArrangedSubview(separatorLine)

        headerView.addSubview(headerStackView)

        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: headerView.topAnchor),
            headerStackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            headerStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            headerStackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16)
        ])

        switch section {
        case 0:
            label.text = "活動資訊"
            return headerView
        case 2:
            label.text = "優惠方案"
            return headerView
        default:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 40
        case 2:
            return 40
        default:
            return 0
        }
    }
    // 設定
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}
// MARK: - internal functions
extension TopPageMainTableViewController {
    // 設定左上logo右上購物車
    func navigationItems() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LOGO")
        imageView.contentMode = .scaleAspectFit

        let leftNavigationItem = UIBarButtonItem(customView: imageView)
        navigationItem.leftBarButtonItem = leftNavigationItem

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
    // 註冊對應nib
    func configureTableView() {
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 260

        let storeNib = UINib(nibName: String(describing: TopPageStoreTableViewCell.self), bundle: nil)
        tableView.register(storeNib, forCellReuseIdentifier: String(describing: TopPageStoreTableViewCell.self))

        let optionNib = UINib(nibName: String(describing: TopPageOptionTableViewCell.self), bundle: nil)
        tableView.register(optionNib, forCellReuseIdentifier: String(describing: TopPageOptionTableViewCell.self))

        let packageNib = UINib(nibName: String(describing: TopPagePackageTableViewCell.self), bundle: nil)
        tableView.register(packageNib, forCellReuseIdentifier: String(describing: TopPagePackageTableViewCell.self))
    }
    // 作弊用，應該要拿掉
    func loadPackage() {
        ProductService.shared.loadPackageList(id: account,
                                              pwd: password) { packagesResponse in
            let wholePackages = packagesResponse
            self.packages = wholePackages
        }
    }
}
// MARK: - Store Cell的動作
extension TopPageMainTableViewController: TopPageStoreTableViewCellDelegate {
    func didTapBanner(_ cell: TopPageStoreTableViewCell, banner: Banner) {
//        let vc = WKWebViewController()
//        vc.urlStr = banner.bannerLink
//        navigationController?.pushViewController(vc, animated: true)

        if let url = URL(string: banner.bannerLink) {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
    }

    func didTapStore(_ cell: TopPageStoreTableViewCell, store: Store) {
        let vc = HostelDetailViewController()
        vc.store = store
        vc.fixmotor = store.fixmotor
        navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - Option Cell的動作
extension TopPageMainTableViewController: TopPageOptionTableViewCellDelegate {
    func didTapOption(_ cell: TopPageOptionTableViewCell, option: String) {
//        let vc = MainPageWebViewController()
//        vc.urlStr = option
//        navigationController?.pushViewController(vc, animated: true)
        if let url = URL(string: option) {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
    }
    func toRepairReservation(_ cell: TopPageOptionTableViewCell) {
        let vc = RepairReservationMainViewController()
        self.navigationController?.pushViewController(vc, animated: true)
//        self.tabBarController?.selectedIndex = 3
//        guard let memberNavigationController = self.tabBarController?.selectedViewController as? MemberNavigationViewController else { return }
//
//        memberNavigationController.popToRootViewController(animated: false)
//        let repairReservationMainViewController = RepairReservationMainViewController()
////        if let repairReservationMainViewController = memberNavigationController.viewControllers.compactMap({ $0 as? RepairReservationMainViewController }).first {
////            memberNavigationController.pushViewController(repairReservationMainViewController, animated: true)
////        }
//        memberNavigationController.pushViewController(repairReservationMainViewController, animated: false)
    }

    func toShop(_ cell: TopPageOptionTableViewCell, producttypeName: String) {
        print(#function, "Hello, world")
        self.tabBarController?.selectedIndex = 1
        let vc = UIStoryboard(name: "Shop", bundle: nil).instantiateViewController(withIdentifier: "Shop")
//        let vc = ShopMainViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - Package Cell的動作
extension TopPageMainTableViewController: TopPagePackageTableViewCellDelegate {
    func didTapPackage(_ cell: TopPagePackageTableViewCell, package: Package) {
        let vc = PackageInfoViewController()
        vc.package = package
        navigationController?.pushViewController(vc, animated: true)
    }
}
