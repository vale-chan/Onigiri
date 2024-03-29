//
//  AppDelegate.swift
//  Onigiri
//
//  Created by Vale-chan on 16.06.19.
//  Copyright © 2019 Vale-chan. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //Notifications
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.sound, .alert, .badge]
        
        center.requestAuthorization(options: options) { (allowed, error) in
            if error != nil {
                print(error)
            }
        }
        
        center.delegate = self
        
        //Tastatur verschiwnden lassen
        IQKeyboardManager.shared.enable = true
        
        //App-Colours
        UITabBar.appearance().tintColor = UIColor(red: 1, green: 0.4627, blue: 0.5333, alpha: 1)
        UITabBar.appearance().backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1)

        UINavigationBar.appearance().barTintColor = UIColor(red: 0, green: 0.5373, blue: 0.3059, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor(red: 242.0, green: 242.0, blue: 242.0, alpha: 1.0)
        let color = UIColor(red: 242.0, green: 242.0, blue: 242.0, alpha: 1.0)
        let font = UIFont(name: "Helvetica Neue", size: 18)!
        
        let attributes: [NSAttributedString.Key: AnyObject] = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): color,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font
        ]
        
        UINavigationBar.appearance().titleTextAttributes = attributes
        UIApplication.shared.statusBarStyle = .lightContent
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Onigiri")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext
