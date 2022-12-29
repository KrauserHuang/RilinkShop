//
//  PointService.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/6/23.
//

import Foundation
import Alamofire
import SwiftyJSON

class PointService {
    static let shared = PointService()

    func fetchPointHistory(id: String, pwd: String, completion: @escaping Completion) {
        let url = SHOP_API_URL + URL_FETCHPOINTHISTORY
        let parameters = [
            "member_id": id,
            "member_pwd": pwd
        ]

        AF.request(url, method: .post, parameters: parameters).responseJSON { response in

            guard response.error == nil else {
                let errorMsg = "伺服器連線失敗"
                completion(false, errorMsg as AnyObject)
                return
            }

            let value = JSON(response.value!)
            print(#function)
//            print(value)
            print(response.result)

            switch response.result {
            case .success:
                let datas = value["data"].arrayValue
                var points: [Point] = []
                for data in datas {
                    let point = Point(id: data["id"].stringValue,
                                      point: data["point"].stringValue,
                                      msg: data["msg"].stringValue,
                                      time: data["time"].stringValue,
                                      account: data["account"].stringValue,
                                      accountType: data["accountType"].stringValue)
                    points.append(point)
                }
                completion(true, points as AnyObject)
            case .failure:
                let errorMsg = value["responseMessage"].stringValue
                completion(false, errorMsg as AnyObject)
            }
        }
    }
}
