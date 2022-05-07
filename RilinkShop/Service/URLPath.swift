//
//  URLPath.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/4/26.
//

import Foundation

// MARK: - MAIN
let OFFICIAL_API_URL = "https://medicalec.jotangi.net/medicalec/api/"
let OFFICIAL_ROOT_URL = "https://medicalec.jotangi.net/medicalec/"
let TEST_API_URL = "https://rilink.jotangi.com.tw:11074/ticketec/api/"
let TEST_ROOT_URL = "https://rilink.jotangi.com.tw:11074/ticketec/"

// MARK: - USER RELATED
//使用者登入
let URL_USERLOGIN = "user_login.php"
//會員資料修改
let URL_USEREDIT = "user_edit.php"
//取得會員資料
let URL_USERGETDATA = "user_getdata.php"

// MARK: - PRODUCT RELATED
//查詢商品類別
let URL_PRODUCTTYPE = "product_type.php"
//商城商品列表
let URL_PRODUCTLIST = "product_list.php"
//商城套票列表
let URL_PACKAGELIST = "package_list.php"
//商城商品資訊
let URL_PRODUCTINFO = "product_info.php"
//商城套票資訊
let URL_PACKAGEINFO = "package_info.php"
//新增商品到購物車
let URL_ADDSHOPPINGCART = "add_shoppingcart.php"
//購物車內商品列表
let URL_SHOPPINGCARTLIST = "shoppingcart_list.php"
//修改購物車內商品數量
let URL_EDITSHOPPINGCART = "edit_shoppingcart.php"
//刪除購物車內某項商品
let URL_DELETESHOPPINGCART = "del_shoppingcart.php"
//購物車內商品總數
let URL_SHOPPINGCARTCOUNT = "shoppingcart_count.php"
//清空購物車內的商品
let URL_CLEARSHOPPINGCART = "clear_shoppingcart.php"
//新增商城訂單
let URL_ADDECORDER = "add_ecorder.php"
