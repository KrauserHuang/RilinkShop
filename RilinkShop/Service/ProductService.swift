//
//  ProductService.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/25.
//

import Foundation
import Alamofire
import SwiftyJSON

class ProductService {
    static let shared = ProductService()
    static let didUpdateInCartItems = Notification.Name("ProductService.inCartItemUpdated")
    var inCartItems = [Product]() {
        didSet {
            NotificationCenter.default.post(name: ProductService.didUpdateInCartItems, object: nil)
        }
    }
    private(set) var productList = [Product]()
    // MARK: - Product/Package Related
    func getProductType(id: String, pwd: String, completion: @escaping ([Category]) -> Void) {
        let url = SHOP_API_URL + URL_PRODUCTTYPE // 測試機
        let parameters = [
            "member_id": id,
            "member_pwd": pwd
        ]
        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [Category].self) { response in
            guard let category = response.value else { return }
            completion(category)
        }
    }

    // 載入商品列表
    func loadProductList(id: String, pwd: String, completion: @escaping ([Product]) -> Void) {
        let url = SHOP_API_URL + URL_PRODUCTLIST // 測試機
        let parameters = ["member_id": id,
                          "member_pwd": pwd]

        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
            let json = JSON(response.value ?? "")
            if let results = json.array {
                var productList = [Product]()
                for result in results {
                    var product = Product()
                    product.pid              = "\(result["pid"])"
                    product.product_no       = "\(result["product_no"])"
                    product.product_type     = "\(result["product_type"])"
                    product.producttype_name = "\(result["producttype_name"])"
                    product.product_name     = "\(result["product_name"])"
                    product.product_price    = "\(result["product_price"])"
                    product.product_status   = "\(result["product_status"])"
                    product.product_picture  = "\(result["product_picture"])"
                    productList.append(product)
                }
                completion(productList)
                self.productList = productList
            } else {
                print("Get ProductList Fail.")
            }
        }
    }
    // 載入商品資訊
    func loadProductInfo(id: String, pw: String, no: String, completion: @escaping (Product) -> Void) {
        let url = SHOP_API_URL + URL_PRODUCTINFO // test
        let parameters = ["member_id": id, "member_pwd": pw, "product_no": no]

        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
            let json = JSON(response.value ?? "")
            if let results = json.array {
                var product = Product()
                for result in results {
                    product.product_no          = "\(result["product_no"])"
                    product.product_name        = "\(result["product_name"])"
                    product.pid                 = "\(result["pid"])"
                    product.product_description = "\(result["product_description"])"
                    product.product_price       = "\(result["product_price"])"
                    product.product_stock       = "\(result["product_stock"])"
                    product.product_picture     = "\(result["product_picture"])"
                }
                completion(product)
            } else {
                print("Fail to get ProductInfo")
            }
        }
    }

    func loadPackageList(id: String, pwd: String, completion: @escaping ([Package]) -> Void) {
        let url = SHOP_API_URL + URL_PACKAGELIST // 測試機
        let parameters = [
            "member_id": id,
            "member_pwd": pwd
        ]

        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [Package].self) { response in
//            print(response)
            guard let packages = response.value else { return }
//            print("-----")
//            print("\(packages)")
            completion(packages)
        }
    }

    func loadPackageInfo(id: String, pwd: String, no: String, completion: @escaping ([PackageInfo]) -> Void) {
        let url = SHOP_API_URL + URL_PACKAGEINFO // 測試機
        let parameters = [
            "member_id": id,
            "member_pwd": pwd,
            "package_no": no
        ]

        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [PackageInfo].self) { response in
            guard let products = response.value else { return }
            completion(products)
        }
    }
    // MARK: - Shoppingcart Related
    // Add item to shopping cart(新增商品至購物車)
    func addShoppingCartItem(id: String, pwd: String, no: String, spec: String, price: String, qty: String, total: String, completion: @escaping (Product) -> Void) {
        let url = SHOP_API_URL + URL_ADDSHOPPINGCART // test
        let parameters = [
            "member_id": id,
            "member_pwd": pwd,
            "product_no": no,
            "product_spec": spec,
            "product_price": price,
            "order_qty": qty,
            "total_amount": total
        ]
        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
            print("---")
            print(response.response)
            print(response.value)
            let isSuccess: Bool = response.response == nil ? false : response.response!.statusCode == 200
            NotificationCenter.default.post(name: ProductService.didUpdateInCartItems, object: nil, userInfo: ["ifHasItem": isSuccess])
            print("新增項目成功！")
            // dosomething for error or whatever

        }
    }

    func addShoppingCartItem(id: String, pwd: String, no: String, spec: String, price: String, qty: String, total: String, completed: @escaping Completion) {
        let url = SHOP_API_URL + URL_ADDSHOPPINGCART
        let parameters = [
            "member_id": id,
            "member_pwd": pwd,
            "product_no": no,
            "product_spec": spec,
            "product_price": price,
            "order_qty": qty,
            "total_amount": total
        ]
        let returnCode = ReturnCode.MALL_RETURN_SUCCESS.0
        print("parameters:\(parameters)")

        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
            print(#function)
            print(response)
            guard response.value != nil else {
                let errorMsg = "伺服器連線失敗"
                completed(false, errorMsg as AnyObject)
                return
            }

            let value = JSON(response.value!)
//            print(#function)
//            print(response)
            print(value)

            switch response.result {
            case .success:
                guard value["code"].stringValue == returnCode else {
                    let errorMsg = value["responseMessage"].stringValue
                    completed(false, errorMsg as AnyObject)
                    return
                }

                let message = value["responseMessage"].stringValue
                completed(true, message as AnyObject)
            case .failure:
                let errorMsg = value["responseMessage"].stringValue
                completed(false, errorMsg as AnyObject)
            }
        }
    }
    // get shopping cart list(取得購物車目前列表)
    func loadShoppingCartList(id: String, pwd: String, completion: @escaping ([Product]) -> Void) {
        let url = SHOP_API_URL + URL_SHOPPINGCARTLIST // test
        let parameters = [
            "member_id": id,
            "member_pwd": pwd
        ]
        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
            let json = JSON(response.value ?? "")
            var shoppingCartList = [Product]()
            if let results = json.array {
                for result in results {
                    var product = Product()
                    product.did              = "\(result["did"])"
                    product.product_no       = "\(result["product_no"])"
                    product.product_price    = "\(result["product_price"])"
                    product.order_qty        = "\(result["order_qty"])"
                    product.total_amount     = "\(result["total_amount"])"
                    product.product_name     = "\(result["product_name"])"
                    product.producttype_name = "\(result["producttype_name"])"
                    product.product_picture  = "\(result["product_picture"])"
                    product.product_stock    = "\(result["product_stock"])"
                    shoppingCartList.append(product)
                    self.inCartItems = shoppingCartList
                }
                print("有")
                completion(shoppingCartList)
            } else {
                print("沒有")
                completion(shoppingCartList)
            }
        }
    }
    // get shopping cart item count(取得購物商品種類數)
    func getShoppingCartCount(id: String, pwd: String, completion: @escaping (Response) -> Void) {
        let url = SHOP_API_URL + URL_SHOPPINGCARTCOUNT // test
        let parameters = [
            "member_id": id,
            "member_pwd": pwd
        ]
        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
            let json = JSON(response.value ?? "")
//            print("json\(json)")
            var response = Response()
            response.code            = "\(json["code"])"
            response.status          = "\(json["status"])"
            response.responseMessage = "\(json["responseMessage"])"
            completion(response)
            print("++++++++++++++++")
            print("\(response)")
//            print("新增訂單成功")
            print("++++++++++++++++")
//            guard response.response?.statusCode == 200 else {
//                fatalError()
//            }
        }
    }
    // edit shopping cart(修改商品的數量，直到數字變零則執行removeShoppingCartItem)
    func editShoppingCartItem(id: String, pwd: String, no: String, qty: Int, completion: @escaping Completion) {
        let url = SHOP_API_URL + URL_EDITSHOPPINGCART // test
        let parameters = [
            "member_id": id,
            "member_pwd": pwd,
            "product_no": no,
            "order_qty": "\(qty)"
        ]
        let returnCode = ReturnCode.MALL_RETURN_SUCCESS.0

        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
            guard response.error == nil else {
                let errorMsg = "伺服器連線失敗"
                completion(false, errorMsg as AnyObject)
                return
            }

            let value = JSON(response.value)
            print(#function)
            print(value)

            switch response.result {
            case .success:
                guard value["code"].stringValue == returnCode else {
                    let errorMsg = value["responseMessage"].stringValue
                    completion(false, errorMsg as AnyObject)
                    return
                }
                let successMsg = value["responseMessage"].stringValue
                completion(true, successMsg as AnyObject)
            case .failure:
                let errorMsg = value["responseMessage"].stringValue
                completion(false, errorMsg as AnyObject)
            }
        }

    }
    // delete item from shopping cart(刪掉對應商品)
    func removeShoppingCartItem(id: String, pwd: String, no: String, completion: @escaping (Product) -> Void) {
        let url = SHOP_API_URL + URL_DELETESHOPPINGCART // test
        let parameters = [
            "member_id": id,
            "member_pwd": pwd,
            "product_no": no
        ]
        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
            let isSuccess: Bool = response.response == nil ? false : response.response!.statusCode == 200
//            NotificationCenter.default.post(name: ProductService.didUpdateInCartItems, object: nil, userInfo: ["isHasItem": isSuccess])
            print("刪除項目成功！")
        }
    }
    // delete all items from shopping cart(刪掉所有的商品)
    func clearShoppingCartItem(id: String, pwd: String, completion: @escaping (Product) -> Void) {
        let url = SHOP_API_URL + URL_CLEARSHOPPINGCART // test
        let parameters = [
            "member_id": id,
            "member_pwd": pwd
        ]
        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
            let isSuccess: Bool = response.response == nil ? false : response.response?.statusCode == 200
            self.inCartItems = []
            print("刪除所有項目成功")
        }
    }
}
