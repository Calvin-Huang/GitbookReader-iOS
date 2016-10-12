//
//  AppDelegate.swift
//  GitbookReader
//
//  Created by Calvin on 6/19/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = BooksViewController()
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            let webpageURL = userActivity.webpageURL! // Always exists
            if let components = getValidatedURLComponent(URL: webpageURL) {
                
                handleURLComponenst(components)
                
            } else {
                UIApplication.shared.openURL(webpageURL)
            }
        }
        return true
    }
    
    private func getValidatedURLComponent(URL url: URL) -> URLComponents? {
        guard
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            "\(components.scheme!)://\(components.host!)" == Application.AssociatedDomain.production.value,
            Application.isAllowed(path: components.path)
        else {
            return nil
        }
        
        return components
    }
    
    private func handleURLComponenst(_ components: URLComponents) {
        switch components.path {
        case "/users":
            guard
                let queryItem = components.queryItems?.first,
                queryItem.name == "token",
                let token = queryItem.value,
                let booksViewController = window?.rootViewController as? BooksViewController
            else {
                return
            }
            
            UserViewModel.sharedInstance.token = token
            
            booksViewController.queuedAction?()
        default:
            break
        }
    }
}
