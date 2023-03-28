//
//  CouponDetailViewController.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2023/3/6.
//

import UIKit

class CouponDetailViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        return scrollView
    }()
    
    private let imageView = RSProductImageView(frame: .zero)
    private let titleLabel = RSTitleLabel(textAlignment: .center, fontSize: 20)
    private let dueDateLabel = RSTitleLabel(textAlignment: .center, fontSize: 20)
    private let descriptionLabel = RSTitleLabel(textAlignment: .center, fontSize: 18, weight: .regular)
    private let backButton = RSButton(isTinted: false, color: .primaryOrange, title: "返回")
    private let useButton = RSButton(isTinted: true, color: .primaryOrange, title: "使用優惠券")
    private let underlineView1: UIView = {
        let view = UIView()
        view.backgroundColor = .primaryOrange
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let underlineView2: UIView = {
        let view = UIView()
        view.backgroundColor = .primaryOrange
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.spacing = 10
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let coupon: Coupon!
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    init(model: Coupon) {
        self.coupon = model
        super.init(nibName: nil, bundle: nil)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureUIElements()
    }
    
    private func configure() {
        imageView.setImage(from: coupon.couponPicture)
        titleLabel.text         = coupon.couponName
        guard let couponEnddateToDate = coupon.couponEnddate.convertStringToDate() else { return }
        let couponEnddateToString = couponEnddateToDate.convertDateToMonthYearFormat()
        dueDateLabel.text       = "有效期限：\(couponEnddateToString)"
        descriptionLabel.text   = coupon.couponDescription
    }
    
    private func configureUIElements() {
        view.addSubviews(imageView, underlineView1, titleLabel, underlineView2, dueDateLabel, descriptionLabel, stackView)
        stackView.addArrangedSubview(backButton)
        stackView.addArrangedSubview(useButton)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            
            underlineView1.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            underlineView1.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            underlineView1.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            underlineView1.heightAnchor.constraint(equalToConstant: 2),
            
            titleLabel.topAnchor.constraint(equalTo: underlineView1.bottomAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            titleLabel.heightAnchor.constraint(equalToConstant: 60),
            
            underlineView2.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            underlineView2.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            underlineView2.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            underlineView2.heightAnchor.constraint(equalToConstant: 2),
            
            dueDateLabel.topAnchor.constraint(equalTo: underlineView2.bottomAnchor, constant: 10),
            dueDateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dueDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            dueDateLabel.heightAnchor.constraint(equalToConstant: 60),
            
            descriptionLabel.topAnchor.constraint(equalTo: dueDateLabel.bottomAnchor, constant: 10),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            descriptionLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -10),
            
            stackView.heightAnchor.constraint(equalToConstant: 40),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
        ])
        
        titleLabel.numberOfLines = 0
        dueDateLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0
        
        backButton.addTarget(self, action: #selector(backButtonDidTapped(_:)), for: .touchUpInside)
        useButton.addTarget(self, action: #selector(useButtonDidTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func backButtonDidTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func useButtonDidTapped(_ sender: UIButton) {
        Alert.showConfirm(title: "提醒", msg: "執行操作後即無法取消。請出示畫面由店員點選「使用優惠劵」,或依店家指示自行操作。", confirmTitle: "使用優惠券", vc: self) {
            self.getCouponConfirm(couponToBeRedeemed: self.coupon.couponId)
        }
    }
    
    private func getCouponConfirm(couponToBeRedeemed id: String) {
        CouponService.shared.newMemberCouponConfirm(id: id) { success, response in
            guard success else {
                let errorMsg = response as! String
                Alert.showMessage(title: "系統訊息", msg: errorMsg, vc: self)
                return
            }
            print("核銷完成1")
            self.dismiss(animated: true) {
                self.navigationController?.popViewController(animated: true)
                print("核銷完成2")
            }
        }
    }
}
