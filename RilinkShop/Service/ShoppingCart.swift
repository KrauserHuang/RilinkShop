//
//  ShoppingCart.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/7.
//

import Foundation
import UIKit

struct ShoppingCartItem {
    let product: Product
    var count = 0
}

class ShoppingCart {
    private init() {}
    static let shared = ShoppingCart()
    
    private var items: [ShoppingCartItem] = []
    
    private let queue = DispatchQueue(label: "ShoppingCart")
        
    func add(_ item: ShoppingCartItem) {
        
        queue.sync {
            items.append(item)
        }
    }
}
