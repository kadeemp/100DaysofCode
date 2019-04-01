//
//  AppDelegate.swift
//  100DaysofCode
//
//  Created by Kadeem Palacios on 1/21/19.
//  Copyright © 2019 Kadeem Palacios. All rights reserved.
//

import UIKit
import AVFoundation
import UserNotifications
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    let userDefaults = UserDefaults.standard
    let center = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
     //   CommitManager.updateHasCommited()
//        if  userDefaults.string(forKey: "username") != nil {
//            self.window = UIWindow(frame: UIScreen.main.bounds)
//            center.delegate = self
//            self.window?.rootViewController = Nav.returnMainView()
//            self.window?.makeKeyAndVisible()
//        } else {
//
//            self.window = UIWindow(frame: UIScreen.main.bounds)
//            self.window?.rootViewController = Nav.returnLoginView()
//            self.window?.makeKeyAndVisible()
//        }
//        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
//            if granted {
//
//            } else {
//
//            }
//        }
        return true
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        NetworkingProvider.returnCommitData { (status, streak, nodes) in
            if status {
                AlarmController.shared.notifyCommitConfirmation()
                AlarmController.shared.incrementAlarmFireDate()
            } else {

            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "Home")
        
        if let topVC = UIApplication.getTopMostViewController() {
            if topVC.tabBarItem.title! == "Home" {
                //notify refresh
            }
        }
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }

    func deleteAllData() {
        CoreDataStack.deleteSavedNodes()
        for alarm in AlarmController.shared.allAlarms {
            AlarmController.shared.deleteAlarm(alarmBeingDeleted: alarm)
        }
        let domain = Bundle.main.bundleIdentifier!

        userDefaults.removePersistentDomain(forName: domain)
        userDefaults.synchronize()

            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = Nav.tempLoginView()
            self.window?.makeKeyAndVisible()


}
}

