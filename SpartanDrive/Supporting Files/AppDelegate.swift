//
//  AppDelegate.swift
//  SpartanDrive
//
//  Created by Spencer on 2/25/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import GoogleSignIn
<<<<<<< HEAD
=======
import UserNotifications
>>>>>>> 68ff8320d4f01097fbb7c506dac314760266eef0

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
<<<<<<< HEAD

=======
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    
        print("token: \(token)")
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    
>>>>>>> 68ff8320d4f01097fbb7c506dac314760266eef0
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        let _ = Firestore.firestore()
        // Google Sign In
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
<<<<<<< HEAD
=======
        
        
        // Push Notifications
       
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()

        
        
>>>>>>> 68ff8320d4f01097fbb7c506dac314760266eef0
        return true
    }
    
    // Google Sign In
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
<<<<<<< HEAD
=======
        
>>>>>>> 68ff8320d4f01097fbb7c506dac314760266eef0
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
<<<<<<< HEAD


}

=======
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
}
>>>>>>> 68ff8320d4f01097fbb7c506dac314760266eef0
