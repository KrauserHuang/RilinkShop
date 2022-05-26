//
//  StorePicker.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/21.
//

import Foundation
import UIKit

protocol StorePickerDelegate: AnyObject {
//    func storePickerDidSelectDone(_ pickerView: StorePicker)
//    func storePickerDidSelectItem(_ pickerView: StorePicker, store: StoreIDInfo)
    func didTapDone(_ picker: StorePicker)
//    func didTapDone()
}

class StorePicker: UIPickerView {
    
    private var toolBar: UIToolbar?
    weak var toolBarDelegate: StorePickerDelegate?
//    private let toolBar: UIToolbar = {
//        let toolBar = UIToolbar()
//        toolBar.barStyle = .default
//        toolBar.isTranslucent = true
//        toolBar.tintColor = .black
//        toolBar.sizeToFit()
//
//        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped(_:)))
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        toolBar.setItems([spaceButton, doneButton], animated: false)
//        toolBar.isUserInteractionEnabled = true
//
//        return toolBar
//    }()
    
    func commonInit() {
        let toolBar = UIToolbar()
        toolBar.backgroundColor = .cyan
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.toolBar = toolBar
    }
    
    @objc func doneTapped(_ sender: UIBarButtonItem) {
        toolBarDelegate?.didTapDone(self)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
