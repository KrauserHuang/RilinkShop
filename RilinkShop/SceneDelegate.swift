//
//  SceneDelegate.swift
//  Rilink
//
//  Created by Jotangi on 2022/1/4.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var tabbarController: UITabBarController?

    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        tabbarController = window?.rootViewController as? UITabBarController
        
        if let url = connectionOptions.urlContexts.first?.url {
            handleURL(url)
        }
    }

    @available(iOS 13.0, *)
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    @available(iOS 13.0, *)
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    @available(iOS 13.0, *)
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    @available(iOS 13.0, *)
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    @available(iOS 13.0, *)
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    // MARK: - What's openURLContexts/absoluteString
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        print("URLContexts:\(URLContexts)")
        guard let url = URLContexts.first?.url else { return }
        handleURL(url)
    }
    // MARK: - What's UIApplication.shared.windows
    func handleURL(_ url: URL) {
        guard url.scheme == "rilinkshop" && url.host == "rilink.com.tw" else { return }
        let root = UIApplication.shared.windows.first?.rootViewController as? MainTabBarController
        let navC = root?.selectedViewController as? UINavigationController
        navC?.popToRootViewController(animated: false)
        switch url.path {
        case "/shop":
            tabbarController?.selectedIndex = 2
        case "/ticket":
            guard let tabbarController = tabbarController else {
                return
            }

            tabbarController.selectedIndex = 3
            let navigationController = tabbarController.viewControllers?.filter { $0 is MemberNavigationViewController
            }.first as? MemberNavigationViewController
            navigationController?.popToRootViewController(animated: false)
            DispatchQueue.main.async {
                navigationController?.toTicketViewController()
            }
        default:
            return
        }
        
    }
}

