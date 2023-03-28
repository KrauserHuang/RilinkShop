//
//  CouponService.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2023/3/23.
//

import Foundation
import Alamofire
import SwiftyJSON

class CouponService {
    static let shared = CouponService()
    private init() {}
    
    enum MemberCouponReceiveType: Int { // 0: 未兌換, 1: 已兌換
        case unredeemed
        case redeemed
    }
    
    func getNewMemberCoupon(type: MemberCouponReceiveType, completion: @escaping Completion) {
        let url = SHOP_API_URL + URL_GETNEWMEMBERCOUPON
        let parameters = [
            "member_id": Global.ACCOUNT,
            "member_pwd": Global.ACCOUNT_PASSWORD,
            "confirm_type": "\(type.rawValue)"
        ]
        let returnCode = ReturnCode.MALL_RETURN_SUCCESS.0
        
        AF.request(url, method: .post, parameters: parameters).response { response in
            guard response.error == nil else {
                completion(false, RSError.connectionFailure as AnyObject)
                return
            }
            
            let value = JSON(response.value)
            
            switch response.result {
            case .success:
                guard value["code"].stringValue == returnCode else {
                    let errorMsg = value["responseMessage"].stringValue
                    completion(false, errorMsg as AnyObject)
                    return
                }
                let infos = value["info"].arrayValue
                var coupons: [Coupon] = []
                for info in infos {
                    let coupon = Coupon(couponId: info["coupon_id"].stringValue,
                                        couponName: info["coupon_name"].stringValue,
                                        couponPicture: info["coupon_picture"].stringValue,
                                        couponDescription: info["coupon_description"].stringValue,
                                        couponEnddate: info["coupon_enddate"].stringValue)
                    coupons.append(coupon)
                }
                completion(true, coupons as AnyObject)
            case .failure:
                let errorMsg = value["responseMessage"].stringValue
                completion(false, errorMsg as AnyObject)
            }
        }
    }
    
    func newMemberCouponConfirm(id: String, completion: @escaping Completion) {
        let url = SHOP_API_URL + URL_NEWMEMBERCOUPONCONFIRM
        let parameters = [
            "member_id": Global.ACCOUNT,
            "member_pwd": Global.ACCOUNT_PASSWORD,
            "coupon_id": id
        ]
        let returnCode = ReturnCode.MALL_RETURN_SUCCESS.0
        
        AF.request(url, method: .post, parameters: parameters).response { response in
            guard response.error == nil else {
                completion(false, RSError.connectionFailure as AnyObject)
                return
            }
            
            let value = JSON(response.value)
        }
    }
}
