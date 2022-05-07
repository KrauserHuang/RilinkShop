//
//  OrderService.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/6.
//

import Foundation
import Alamofire

class OrderService {
    static let shared = OrderService()
    
    func addECOrder(id: String, pwd: String, orderAmount: String, discountAmount: String, orderPay: String, completion: @escaping (Response) -> Void) {
        let url = TEST_API_URL + URL_ADDECORDER
        let parameters = [
            "member_id": id,
            "member_pwd": pwd,
            "order_amount": orderAmount,
            "discount_amount": discountAmount,
            "order_pay": orderPay
        ]
        AF.request(url, method: .post, parameters: parameters).validate().responseDecodable(of: Response.self) { response in
            guard let response = response.value else { return }
            completion(response)
//            print("-----------")
//            print("\(response)")
        }
    }
}
