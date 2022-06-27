//
//  OrderService.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/6.
//

import Foundation
import Alamofire
import SwiftyJSON

class OrderService {
    static let shared = OrderService()
    
    func addECOrder(id: String, pwd: String, orderAmount: String, discountAmount: String, orderPay: String, completion: @escaping (Response) -> Void) {
        let url = SHOP_API_URL + URL_ADDECORDER
        let parameters = [
            "member_id": id,
            "member_pwd": pwd,
            "order_amount": orderAmount,
            "discount_amount": discountAmount,
            "order_pay": orderPay
        ]
        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: Response.self) { response in
//            print("------")
//            print(response)
            guard let response = response.value else { return }
            completion(response)
//            print("-----------")
//            print("\(response)")
        }
    }
    
    func getECOrderList(id: String, pwd: String, completion: @escaping ([Order]) -> Void) {
        let url = SHOP_API_URL + URL_ECORDERLIST
        let parameters = [
            "member_id": id,
            "member_pwd": pwd
        ]
        
        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [Order].self) { response in
//            print("-----")
//            print(response.response)
            guard let orders = response.value else { return }
            completion(orders)
        }
    }
    
    func getECOrderList(id: String, pwd: String, completion: @escaping Completion) {
        let url = SHOP_API_URL + URL_ECORDERLIST
        let parameters = [
            "member_id": id,
            "member_pwd": pwd
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
                let datas = value[""].arrayValue
                var orders = [Order]()
                for data in datas {
                    let order = Order(oid: data["oid"].stringValue,
                                      orderNo: data["orderNo"].stringValue,
                                      orderDate: data["orderDate"].stringValue,
                                      storeID: data["storeID"].stringValue,
                                      memberID: data["memberID"].stringValue,
                                      orderAmount: data["orderAmount"].stringValue,
                                      couponNo: data["couponNo"].stringValue,
                                      discountAmount: data["discountAmount"].stringValue,
                                      payType: data["payType"].stringValue,
                                      orderPay: data["orderPay"].stringValue,
                                      payStatus: data["payStatus"].stringValue,
                                      bonusPoint: data["bonusPoint"].stringValue,
                                      orderStatus: data["orderStatus"].stringValue)
                    orders.append(order)
                }
                print("-----------")
//                print("orders:\(orders))
                completion(true, orders as AnyObject)
            case .failure:
                let errorMsg = value["responseMessage"].stringValue
                completion(false, errorMsg as AnyObject)
            }
        }
    }
    
//    func getECOrderList(id: String, pwd: String, completion: @escaping ([OrderInfo]) -> Void) {
//        let url = SHOP_API_URL + URL_ECORDERLIST
//        let parameters = [
//            "member_id": id,
//            "member_pwd": pwd
//        ]
//
//        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [OrderInfo].self) { response in
////            print("-----")
////            print(response.response)
//            guard let orders = response.value else { return }
//            completion(orders)
//        }
//    }
    
    func getECOrderInfo(id: String, pwd: String, no: String, completion: @escaping ([OrderInfo]) -> Void) {
        let url = SHOP_API_URL + URL_ECORDERINFO
        let parameters = [
            "member_id": id,
            "member_pwd": pwd,
            "order_no": no
        ]

        AF.request(url, method: .post, parameters: parameters).validate().responseDecodable(of: [OrderInfo].self) { response in
            print(#function)
            guard let order = response.value else { return }
            print(order)
            completion(order)
        }
    }
    
//    func getECOrderInfo(id: String, pwd: String, no: String, completion: @escaping ([List]) -> Void) {
//        let url = SHOP_API_URL + URL_ECORDERINFO
//        let parameters = [
//            "member_id": id,
//            "member_pwd": pwd,
//            "order_no": no
//        ]
//
//        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [List].self) { response in
//            print("+++++")
//            print(response.result)
//            guard let order = response.value else { return }
//            completion(order)
//        }
//    }
    
//    func getECOrderInfo(id: String, pwd: String, no: String, completion: @escaping ([Product]) -> Void) {
//        let url = TEST_API_URL + URL_ECORDERINFO
//        let parameters = [
//            "member_id": id,
//            "member_pwd": pwd,
//            "order_no": no
//        ]
//
//        AF.request(url, method: .post, parameters: parameters).validate().responseDecodable(of: [Product].self) { response in
//            print("+++++")
//            print(response.result)
//            guard let order = response.value else { return }
//            completion(order)
//        }
//    }
    
//    func getECOrderInfo(id: String, pwd: String, no: String, completion: @escaping ([ProductList]) -> Void) {
//        let url = TEST_API_URL + URL_ECORDERINFO
//        let parameters = [
//            "member_id": id,
//            "member_pwd": pwd,
//            "order_no": no
//        ]
//
//        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [ProductList].self) { response in
//            print("+++++")
//            print(response.result)
//            guard let order = response.value else { return }
//            completion(order)
//        }
//    }
//    func getECOrderInfo(id: String, pwd: String, no: String, completion: @escaping ([PackageList]) -> Void) {
//        let url = TEST_API_URL + URL_ECORDERINFO
//        let parameters = [
//            "member_id": id,
//            "member_pwd": pwd,
//            "order_no": no
//        ]
//
//        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [PackageList].self) { response in
//            print("+++++")
//            print(response.result)
//            guard let order = response.value else { return }
//            completion(order)
//        }
//    }
}
