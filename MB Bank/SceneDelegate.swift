//
//  SceneDelegate.swift
//  MB Bank
//
//  Created by Aedotris on 13/6/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        // Kiểm tra xem user đã login chưa
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
        if isLoggedIn {
            window.rootViewController = createTabBarController()
        } else {
            let loginVC = LoginViewController()
            let loginNav = UINavigationController(rootViewController: loginVC)
            window.rootViewController = loginNav
        }
        
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func createTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.tabBar.tintColor = .black
        
        // Tab 1: Chuyển tiền (Tạo bill giả)
        let transferVC = TransferViewController()
        let transferNav = UINavigationController(rootViewController: transferVC)
        transferNav.tabBarItem = UITabBarItem(title: "Chuyển tiền", image: UIImage(systemName: "arrow.right.circle.fill"), tag: 0)
        transferVC.title = "Chuyển Tiền"
        
        // Tab 2: Quản lý số dư
        let balanceVC = BalanceManagementViewController()
        let balanceNav = UINavigationController(rootViewController: balanceVC)
        balanceNav.tabBarItem = UITabBarItem(title: "Số dư", image: UIImage(systemName: "wallet.pass.fill"), tag: 1)
        balanceVC.title = "Quản lý Số Dư"
        
        // Tab 3: Tài khoản
        let accountVC = AccountViewController()
        let accountNav = UINavigationController(rootViewController: accountVC)
        accountNav.tabBarItem = UITabBarItem(title: "Tài khoản", image: UIImage(systemName: "person.fill"), tag: 2)
        accountVC.title = "Tài Khoản"
        
        tabBarController.viewControllers = [transferNav, balanceNav, accountNav]
        
        return tabBarController
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

