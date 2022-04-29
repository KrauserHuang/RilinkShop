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
    
    func getProductType(id: String, pwd: String, completion: @escaping ([Category]) -> Void) {
        let url = OFFICIAL_API_URL + URL_PRODUCTTYPE
        let parameters = [
            "member_id": id,
            "member_pwd": pwd
        ]
        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [Category].self) { response in
            guard let category = response.value else { return }
            completion(category)
        }
    }
    
    func getProductList(id: String, pwd: String, completion: @escaping ([Product]) -> Void) {
        let url = OFFICIAL_API_URL + URL_PRODUCTLIST
        let parameters = [
            "member_id": id,
            "member_pwd": pwd
        ]
        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [Product].self) { response in
//            print("-----------------")
//            print("\(response.value)")
            guard let product = response.value else { return }
            completion(product)
        }
    }
    
//    func loadProductInfo(id: String, pw: String, no: String, completion: @escaping (Product) -> Void) {
////        let url = API_URL + URL_PRODUCTINFO // test
//        let url = OFFICIAL_API_URL + URL_PRODUCTINFO // official
//        let parameters = ["member_id": id, "member_pwd": pw, "product_no": no]
//
//        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
//            let json = JSON(response.value ?? "")
//            if let results = json.array {
//                var product = Product()
//                for result in results {
////                    product.rid                 = "\(result["rid"])"
//                    product.product_no          = "\(result["product_no"])"
//                    product.product_name        = "\(result["product_name"])"
//                    product.pid                 = "\(result["pid"])"
//                    product.product_description = "\(result["product_description"])"
//                    product.product_price       = "\(result["product_price"])"
//                    product.product_bonus       = "\(result["product_bonus"])"
//                    product.product_stock       = "\(result["product_stock"])"
//                    product.product_picture     = "\(result["product_picture"])"
//                    product.channel_price       = "\(result["channel_price"])"
//                    product.group_price         = "\(result["group_price"])"
//                }
//                completion(product)
//            } else {
//                print("Fail to get ProductInfo")
//            }
//        }
//    }
}
