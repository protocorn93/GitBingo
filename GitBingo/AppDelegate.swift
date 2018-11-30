//
//  AppDelegate.swift
//  Gitergy
//
//  Created by 이동건 on 23/08/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]

        center.requestAuthorization(options: options) {
            (_, _) in

        }

        addShortcuts(to: application)

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if url.absoluteString.contains(AppURL.notificaiton.path) {
            showRegisterViewController()
        }
        return true
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if shortcutItem.type == "SetAlarm" {
            showRegisterViewController()
        }
    }

    private func showRegisterViewController() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initViewController  = storyBoard.instantiateViewController(withIdentifier: "MainNavigationController")
        let registerAlertViewController = storyBoard.instantiateViewController(withIdentifier: RegisterAlertViewController.reusableIdentifier)
        if self.window?.rootViewController == nil {
            self.window?.rootViewController = initViewController
            self.window?.makeKeyAndVisible()
        } else {
            self.window?.rootViewController?.present(registerAlertViewController, animated: true, completion: nil)
        }
    }

    private func addShortcuts(to application: UIApplication) {
        let alarmShortcut = UIMutableApplicationShortcutItem(type: "SetAlarm", localizedTitle: "Set Alarm".localized, localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: .alarm), userInfo: nil)

        application.shortcutItems = [alarmShortcut]
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {

    }
}
