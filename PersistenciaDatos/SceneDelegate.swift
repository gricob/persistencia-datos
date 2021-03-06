//
//  SceneDelegate.swift
//  PersistenciaDatos
//
//  Created by Gerardo Rico Botella on 03/05/2020.
//  Copyright © 2020 Gerardo Rico Botella. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    let lastScreenKey = "lastScreen"
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let heroesViewController = HeroesViewController()
        let battlesViewController = BattlesViewController()
        let villainsViewController = VillainsViewController()
        
        let heroesNavController = UINavigationController(rootViewController: heroesViewController)
        heroesNavController.tabBarItem = UITabBarItem(title: NSLocalizedString("Heroes", comment: ""), image: UIImage(named: "ic_tab_heroes"), tag: 0)
        
        let battlesNavController = UINavigationController(rootViewController: battlesViewController)
        battlesNavController.tabBarItem = UITabBarItem(title: NSLocalizedString("Battles", comment: ""), image: UIImage(named: "ic_tab_battles"), tag: 1)
        
        let villainsNavController = UINavigationController(rootViewController: villainsViewController)
        villainsNavController.tabBarItem = UITabBarItem(title: NSLocalizedString("Villains", comment: ""), image: UIImage(named: "ic_tab_villain"), tag: 2)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            heroesNavController,
            battlesNavController,
            villainsNavController
        ]
        
        tabBarController.selectedIndex = UserDefaults.standard.integer(forKey: lastScreenKey)
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
        saveCurrentScreen()
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
        
        saveCurrentScreen()
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    
    }

    func saveCurrentScreen() {
        let selectedIndex = (self.window?.rootViewController as! UITabBarController).selectedIndex
        UserDefaults.standard.setValue(selectedIndex, forKey: lastScreenKey)
    }
}

