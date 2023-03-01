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

    private init() {}

    static let shared = ProductService()
    static let didUpdateInCartItems = Notification.Name.inCartItemsDidUpdate
    var inCartItems = [Product]() {
        didSet {
            NotificationCenter.default.post(name: Notification.Name.inCartItemsDidUpdate,
                                            object: nil)
        }
    }
    var isEmpty: Bool = true
    private(set) var productList = [Product]()
    // MARK: - Product/Package Related
    func getProductType(id: String, pwd: String, completion: @escaping ([Category]) -> Void) {
        let url = SHOP_API_URL + URL_PRODUCTTYPE
        let parameters = [
            "member_id": id,
            "member_pwd": pwd
        ]
        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [Category].self) { response in
            guard let category = response.value else { return }
            completion(category)
        }
    }
    
    func getProductType() async throws -> [Category] {
        let urlString = SHOP_API_URL + URL_PRODUCTTYPE
        var components = URLComponents(string: urlString)!
        components.queryItems = [
            "member_id": Global.ACCOUNT,
            "member_pwd": Global.ACCOUNT_PASSWORD
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
        let url = components.url!
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw RSError.connectionFailure
        }
        let decoder = JSONDecoder()
        let categories = try decoder.decode([Category].self, from: data)
        return categories
    }

    // 載入商品列表
    func loadProductList(id: String, pwd: String, completion: @escaping ([Product]) -> Void) {
        let url = SHOP_API_URL + URL_PRODUCTLIST // 測試機
        let parameters = ["member_id": id,
                          "member_pwd": pwd]

        AF.request(url, method: .post, parameters: parameters).response { response in
//            if let data = response.data {
//                print("data:\(data)")
//                do {
//                    let decoder = JSONDecoder()
//                    decoder.keyDecodingStrategy = .convertFromSnakeCase
//                    let products = try decoder.decode([Product].self, from: data)
//                    print("products:\(products)")
//                    completion(products)
//                } catch {
//                    print("Something wrong")
//                }
//            }
            
            
            let json = JSON(response.value ?? "")
            if let results = json.array {
                var productList = [Product]()
                for result in results {
                    print("result:\(result)")
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
    func loadProductInfo(id: String, pwd: String, no: String, completion: @escaping (Product) -> Void) {
        let url = SHOP_API_URL + URL_PRODUCTINFO // test
        let parameters = [
            "member_id": id,
            "member_pwd": pwd,
            "product_no": no
        ]

        AF.request(url, method: .post, parameters: parameters).response { response in
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
            guard let packages = response.value else { return }
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

        AF.request(url, method: .post, parameters: parameters).response { response in
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
        AF.request(url, method: .post, parameters: parameters).response { response in
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
        AF.request(url, method: .post, parameters: parameters).response { response in
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

        AF.request(url, method: .post, parameters: parameters).response { response in
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
        AF.request(url, method: .post, parameters: parameters).response { response in
            let isSuccess: Bool = response.response == nil ? false : response.response!.statusCode == 200
            NotificationCenter.default.post(name: Notification.Name.inCartItemsDidUpdate,
                                            object: nil,
                                            userInfo: ["isHasItem": isSuccess])
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
        AF.request(url, method: .post, parameters: parameters).response { response in
            let isSuccess: Bool = response.response == nil ? false : response.response?.statusCode == 200
            self.inCartItems = []
            print("刪除所有項目成功")
        }
    }
}
