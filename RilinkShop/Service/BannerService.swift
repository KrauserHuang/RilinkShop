//
//  BannerService.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/9/23.
//

import Foundation
import Alamofire
import SwiftyJSON

class BannerService {
    static let shared = BannerService()

    func getBannerList(id: String, pwd: String, completion: @escaping Completion) {
        let url = SHOP_API_URL + URL_BANNERLIST
        let parameters = [
            "member_id": id,
            "member_pwd": pwd
        ]
        let returnCode = ReturnCode.MALL_RETURN_SUCCESS.0

        AF.request(url, method: .post, parameters: parameters).response { response in

            guard response.error == nil else {
                let errorMsg = "伺服器連線失敗"
                completion(false, errorMsg as AnyObject)
                return
            }

            let value = JSON(response.value!)
//            print(#function)
//            print("response:=====\n\(response.response)")
//            print("value:=====\n\(value)")

            switch response.result {
            case .success:
//                guard value["code"].stringValue == returnCode else {
//                    let errorMsg = value["responseMessage"].stringValue
//                    completion(false, errorMsg as AnyObject)
//                    return
//                }

                let datas = value.arrayValue
                var banners: [Banner] = []
                for data in datas {
                    let banner = Banner(bid: data["bid"].stringValue,
                                        bannerSubject: data["banner_subject"].stringValue,
                                        bannerDate: data["banner_date"].stringValue,
                                        bannerEndDate: data["banner_enddate"].stringValue,
                                        bannerDescript: data["banner_descript"].stringValue,
                                        bannerPicture: data["banner_picture"].stringValue,
                                        bannerLink: data["banner_link"].stringValue)
                    banners.append(banner)
                }

//                print("banners:=====\n\(banners)")
                completion(true, banners as AnyObject)
            case .failure:
                let errorMsg = value["responseMessage"].stringValue
                completion(false, errorMsg as AnyObject)
            }
        }
    }
}
