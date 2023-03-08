//
//  InvoiceService.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2023/2/24.
//

import Foundation
import Alamofire
import SwiftyJSON

class InvoiceService {
    static let shared = InvoiceService()
    private init() {}
    
    func createInvoice() async throws {
        let urlString = API_URL + URL_ECORDERINVOICE
        let parameters: [String: String] = [
            "member_id": "",
            "member_pwd": "",
            "order_no": "",
            "invoice_type": "",
            "companytitle": "",
            "uniformno": "",
            "invoicephone": "",
        ]
        var components = URLComponents(string: urlString)!
        components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        let url = components.url!
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            return
        }
        
        let responseMessage = String(data: data, encoding: .utf8)
    }
    
    func createInvoice(orderNo: String, invoiceType: String, companyTitle: String, uniformNo: String, invoicePhone: String, completion: @escaping Completion) {
        let urlString = SHOP_API_URL + URL_ECORDERINVOICE
        let parameters = [
            "member_id": Global.ACCOUNT,
            "member_pwd": Global.ACCOUNT_PASSWORD,
            "order_no": orderNo,
            "invoice_type": invoiceType,
            "companytitle": companyTitle,
            "uniformno": uniformNo,
            "invoicephone": invoicePhone,
        ]
        
        print("parameters:\(parameters)")
        let returnCode = ReturnCode.MALL_RETURN_SUCCESS.0
        
//        var components = URLComponents(string: urlString)!
//        components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
//        let url = components.url!
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//
//        print("parameters:\(parameters)")
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let data = data {
//                let responseMessage = String(data: data, encoding: .utf8)
//                completion(true, responseMessage as AnyObject)
//            } else {
//                completion(false, response as AnyObject)
//            }
//        }
        
        AF.request(urlString, method: .post, parameters: parameters).response { response in
            guard response.error == nil else {
                completion(false, RSError.connectionFailure as AnyObject)
                return
            }
            
            let value = JSON(response.value)
            
            switch response.result {
            case .success:
                guard value["code"].stringValue == returnCode else {
                    let errorMsg = value["responseMessage"].stringValue
                    print("errorMsg:\(errorMsg)")
                    completion(false, errorMsg as AnyObject)
                    return
                }
                let successMsg = value["responseMessage"].stringValue
                print("successMsg:\(successMsg)")
                completion(true, successMsg as AnyObject)
            case .failure:
                let errorMsg = value["responseMessage"].stringValue
                completion(false, errorMsg as AnyObject)
            }
        }
    }
    
    
}
