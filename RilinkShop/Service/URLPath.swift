//
//  URLPath.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/26.
//

import Foundation

// MARK: - MAIN
// 綠悠游商城正式
 let SHOP_API_URL = "https://rilink.com.tw/ticketec/api/"
 let SHOP_ROOT_URL = "https://rilink.com.tw/ticketec/"

// 綠悠游商城測試
// let SHOP_API_URL = "http://211.20.181.125:11073/ticketec/api/"
// let SHOP_ROOT_URL = "http://211.20.181.125:11073/ticketec/"

// 綠悠游正式
 let API_URL = "https://rilink.com.tw/api/v1"

// 綠悠游測試
// let API_URL = "https://rilink.jotangi.com.tw:11074/api/v1"

// 綠悠游商城測試
// let SHOP_API_URL = "https://rilink.jotangi.com.tw:11074/ticketec/api/"
// let SHOP_ROOT_URL = "https://rilink.jotangi.com.tw:11074/ticketec/"

// Web串接購買金流正式
 let PAYMENT_API_URL = "https://rilink.com.tw/ticketec/ecpay/ecpayindex.php?orderid="

// Web串接購買金流測試
// let PAYMENT_API_URL = "http://211.20.181.125:11073/ticketec/ecpay/ecpayindex.php?orderid="

/**
 綠悠遊商城串接
 */

// 後台會員註冊
let MALL_REGISTER    = "https://ks-api.jotangi.net/api/auth/register"
// 會員密碼變更
let MALL_REWRITE_PWD = "https://ks-api.jotangi.net/api/auth/rewritepwd"
// 使用者圖像
public let MEMBER_IMAGE_URL = API_URL + "/personimages/"
// 上傳使用者圖像
let UPLOAD_IMAGE     = "/account/uploadimage"

// MARK: - BOSS RELATED
// 商店ID列表
let URL_STOREIDLIST = "storeId_list.php"
// 店長登入
let URL_STOREADMINLOGIN = "storeadmin_login.php"

// MARK: - USER RELATED
// 使用者登入
let URL_USERLOGIN = "user_login.php"
// 會員資料修改
let URL_USEREDIT = "user_edit.php"
// 取得會員資料
let URL_USERGETDATA = "user_getdata.php"
// ==========
// 帳號註冊(傳送手機號) 一般用 fb認證勿使用
let SIGN_UP =  "/account/signup"
// 註冊驗證(一般用 fb認證勿使用)
let VERIFY_CODE = "/account/codeverify"
// 重送驗證碼
let RESEND_CODE = "/account/resendcode"
// 取得會員詳細資料
let GET_PERSONAL_DATA = "/account/getpersondata"
// 註冊驗證通過 (初始個人資料)
let MODIFY_PERSONAL_DATA = "/account/modifypersondata"
// 使用者刪除
let URL_USERDEL = "user_del.php"

// MARK: - PRODUCT RELATED
// 查詢商品類別
let URL_PRODUCTTYPE = "product_type.php"
// 商城商品列表
let URL_PRODUCTLIST = "product_list.php"
// 商城套票列表
let URL_PACKAGELIST = "package_list.php"
// 商城商品資訊
let URL_PRODUCTINFO = "product_info.php"
// 商城套票資訊
let URL_PACKAGEINFO = "package_info.php"
// 新增商品到購物車
let URL_ADDSHOPPINGCART = "add_shoppingcart.php"
// 購物車內商品列表
let URL_SHOPPINGCARTLIST = "shoppingcart_list.php"
// 修改購物車內商品數量
let URL_EDITSHOPPINGCART = "edit_shoppingcart.php"
// 刪除購物車內某項商品
let URL_DELETESHOPPINGCART = "del_shoppingcart.php"
// 購物車內商品總數
let URL_SHOPPINGCARTCOUNT = "shoppingcart_count.php"
// 清空購物車內的商品
let URL_CLEARSHOPPINGCART = "clear_shoppingcart.php"
// 新增商城訂單
let URL_ADDECORDER = "add_ecorder.php"
// 會員訂單列表
let URL_ECORDERLIST = "ecorder_list.php"
// 會員訂單詳細資料
let URL_ECORDERINFO = "ecorder_info.php"

// MARK: - STORE RELATED
// 商店類別
let URL_STORETYPE = "store_type.php"
// 商店列表
let URL_STORELIST = "store_list.php"

// MARK: - QR RELATED
// 會員未核銷商品/套票
let URL_QRUNCONFIRMLIST = "qr_unconfirm_list.php"
// 會員已核銷商品/套票
let URL_QRCONFIRMLIST = "qr_confirm_list.php"
// 店家核銷商品/套票
let URL_STOREAPPQRCONFIRM = "storeapp_qrconfirm.php"

// MARK: - FIX MOTOR RELATED
// 商店可預約服務列表
let URL_FIXMOTORINFO = "fixmotor_info.php"
// 客戶開始預約
let URL_BOOKINGFIXMOTOR = "booking_fixmotor.php"
// 取得紅利點數歷史紀錄
let URL_FETCHPOINTHISTORY = "fetch_pointhistory.php"

// MARK: - BOOKING FIX LIST
// 查詢會員預約服務列表
let URL_BOOKINGFIXMOTORLIST = "booking_fixmotor_list.php"
// 會員取消預約服務
let URL_BOOKINGFIXMOTORCANCEL = "booking_fixmotor_cancel.php"

// MARK: - BANNER
// 新增取得banner資訊
let URL_BANNERLIST = "banner_list.php"
