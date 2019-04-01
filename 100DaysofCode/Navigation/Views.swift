//
//  Views.swift
//  100DaysofCode
//
//  Created by Kadeem Palacios on 2/22/19.
//  Copyright © 2019 Kadeem Palacios. All rights reserved.
//

import Foundation
import UIKit



class Nav {
    static func returnMainView() -> UITabBarController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController1:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        let navigationController2:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        let navigationController3:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        //Test
        let navigationController4:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        var mainTabBarController: UITabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBar") as! UITabBarController
        let LoginViewController:UIViewController = storyboard.instantiateViewController(withIdentifier: "Login")
        let homeViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "Home")
        let settingsViewController:UIViewController = storyboard.instantiateViewController(withIdentifier: "Settings")
        let testViewController:UIViewController = storyboard.instantiateViewController(withIdentifier: "Test")
        let postVC :UIViewController = storyboard.instantiateViewController(withIdentifier: "PostVC")
        postVC.tabBarItem = UITabBarItem(title: "Write a post", image: UIImage(named: "WriteIcon"), selectedImage: UIImage(named: "WriteIcon"))
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "HomeIcon"), selectedImage: UIImage(named: "HomeIcon"))
        settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "WhiteSettingsIcon"), selectedImage: UIImage(named: "WhiteSettingsIcon"))
        navigationController1.isNavigationBarHidden = true
        navigationController2.isNavigationBarHidden = true
        navigationController4.isNavigationBarHidden = true
        navigationController1.viewControllers = [homeViewController]
        navigationController3.viewControllers = [settingsViewController]
        navigationController2.viewControllers = [postVC]
        navigationController4.viewControllers = [testViewController]

        mainTabBarController.viewControllers = [navigationController1, navigationController2, navigationController3, navigationController4]

        return mainTabBarController
    }

    static func tempLoginView() -> UINavigationController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController1:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
         let LoginViewController:UIViewController = storyboard.instantiateViewController(withIdentifier: "Login")
         navigationController1.viewControllers = [LoginViewController]
        return navigationController1
    }
}
