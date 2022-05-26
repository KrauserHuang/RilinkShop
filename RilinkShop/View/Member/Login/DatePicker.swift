//
//  DatePicker.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/21.
//

import Foundation
import UIKit
import SnapKit

protocol DatePickerDelegate: AnyObject {
    func datePickerDidSelectDone(_ datePicker: DatePicker)
    func datePickerDidSelectDate(_ datePicker: DatePicker, date: Date)
}

class DatePicker: UIView {
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(doneTapped(_:)), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setTitle("完成", for: .normal)
        button.setTitleColor(UIColor(hex: "4F846C"), for: .normal)
        return button
    }()
    weak var delegate: DatePickerDelegate?
    
    @objc func doneTapped(_ sender: UIButton) {
        delegate?.datePickerDidSelectDone(self)
    }
    @objc func dateChanged(_ sender: UIDatePicker) {
        delegate?.datePickerDidSelectDate(self, date: sender.date)
    }
    
    func setDate(_ date: Date) {
        datePicker.date = date
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(datePicker)
        addSubview(separator)
        addSubview(doneButton)
        datePicker.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self)
        }
        separator.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self)
            make.height.equalTo(0.5)
            make.bottom.equalTo(datePicker.snp.top).offset(-44)
        }
        doneButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(15)
            make.bottom.equalTo(datePicker.snp.top)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
