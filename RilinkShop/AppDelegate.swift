//
//  AppDelegate.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/4.
//

import UIKit
import UserNotifications
import FirebaseCore
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var apnsToken: String?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let navBarAppearance = UINavigationBarAppearance()
        var backButtonImage = UIImage(systemName: "arrow.backward", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20.0, weight: .semibold))
        backButtonImage = backButtonImage?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0))
        navBarAppearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().standardAppearance = navBarAppearance
//        UINavigationBar.appearance().compactAppearance = navBarAppearance
//        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance

        // 調整back button文字
//        let attributes = [NSAttributedString.Key.font:  UIFont(name: "Helvetica-Bold", size: 0.1)!, NSAttributedString.Key.foregroundColor: UIColor.clear]
//        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .normal)
//        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .highlighted)
//        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: 0), for: .default)
        // Connect to Firebase and initialize it
        FirebaseApp.configure()
        // Push Notification(請求授權給使用者)
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { granted, _ in
            if granted {
                NSLog("取得權限成功")
                print("User Notification got granted.")
            } else {
                print("User Notification got denied.")
            }
        }
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            NSLog("settings = \(settings)")
        }
        UIApplication.shared.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        
        UserService.shared.didLogin = true
        
        Global.ACCOUNT          = MyKeyChain.getAccount() ?? ""
        Global.ACCOUNT_PASSWORD = MyKeyChain.getPassword() ?? ""
        Global.ACCESS_TOKEN     = MyKeyChain.getAccessToken() ?? ""
        Global.OWNER_STORE_ID   = MyKeyChain.getStoreId() ?? ""
        Global.OWNER_STORE_NAME = MyKeyChain.getStoreName() ?? ""

        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    // FirebaseMessaging() -> 註冊推播成功
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        var token = ""
        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print("\n==========didRegisterForRemoteNotificationsWithDeviceToken===========")
        print("apns token = " + token)
        print("=================================End=================================\n")

        Messaging.messaging().apnsToken = deviceToken
    }
    // FirebaseMessaging() -> 註冊推播失敗
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    // UserNotifications(原生) -> notification要呈現的方式
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo    // 印出後台送出的推播訊息(JOSN 格式)
        print("userInfo: \(userInfo)")
        if #available(iOS 14, *) {
            completionHandler([.badge, .sound, .banner, .list]) // 14以後alert被拆成banner/list
        } else {
            completionHandler([.badge, .sound, .alert])
        }
    }
    // UserNotifications(原生) -> 當使用者點擊notification時會觸發
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo // 印出後台送出的推播訊息(JOSN 格式)
        print("userInfo: \(userInfo)")
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        print("Firebase registration token: \(fcmToken)")
        
        AppDelegate.apnsToken = fcmToken //FCM確認有收到token後才把它存到AppDelegate的apnsToken
        Global.ACCESS_TOKEN = fcmToken
        MyKeyChain.setAccessToken(fcmToken)
        
        let userInfo: [String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: userInfo)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}
