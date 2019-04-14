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

        let mainTabBarController: UITabBarController = storyboard.instantiateViewController(withIdentifier:"MainTabBar" ) as! UITabBarController
        
        let homeViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: VCIdentifiers.Home)
        let settingsViewController:UIViewController = storyboard.instantiateViewController(withIdentifier: VCIdentifiers.Settings)

        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "HomeIcon"), selectedImage: UIImage(named: "HomeIcon"))
        settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "WhiteSettingsIcon"), selectedImage: UIImage(named: "WhiteSettingsIcon"))
        let controllerTabs = [homeViewController,settingsViewController]

        return mainTabBarController
    }

    static func returnLoginView() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController1:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        let loginVC = storyboard.instantiateViewController(withIdentifier: VCIdentifiers.LOGIN)
        navigationController1.viewControllers = [loginVC]

        return navigationController1
    }


}
