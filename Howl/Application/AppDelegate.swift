//
//  AppDelegate.swift
//  Howl
//
//  Created by apple on 16/08/23.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import GoogleMaps
import Firebase
import FirebaseMessaging
import AVKit
import SVProgressHUD
import UserNotifications
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate, NSUserActivityDelegate {
    
    var window: UIWindow?
    var databaseRef: DatabaseReference!
    let gcmMessageIDKey = "gcm.Message_ID"
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SVProgressHUD.setImageViewSize(CGSize(width: 60, height: 60))
           SVProgressHUD.setOffsetFromCenter(UIOffset(horizontal: 200, vertical: 400))
        Thread.sleep(forTimeInterval: 1.0)
        print("retriveValue", UserDefaults.standard.string(forKey: "MonitorIds") ?? "")
        print("outputvalue", UserDefaults.standard.string(forKey: "MonitorOutPut") ?? "")
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        } catch {
            print("AVAudioSessionCategoryPlayback not work")
        }
        
        if #available(iOS 13.0, *) {
            for windowScene in UIApplication.shared.connectedScenes {
                if let windowScene = windowScene as? UIWindowScene {
                    for window in windowScene.windows {
                        window.overrideUserInterfaceStyle = .light
                    }
                }
            }
        }
        _ = DataManager.sharedInstance
        UIDevice.current.isBatteryMonitoringEnabled = true
        IQKeyboardManager.shared.enable = true
        GMSServices.provideAPIKey("AIzaSyAA7uG3pNZSYY5-nW3pa9QqO4SXelAGSoE")
        FirebaseApp.configure()
        databaseRef = Database.database().reference().child("your_data_node")
        databaseRef.observe(.childAdded) { snapshot in
            if let data = snapshot.value as? [String: Any],
               let walkID = data["walkID"] as? String {
                // Handle the "walkID" you fetched from Firebase
                // You can use 'walkID' in your app as needed
                print("Walk ID: \(walkID)")
                kDataManager.walkId = walkID
            }
        }
        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        }else{
//            let setting: UIUserNotificationType = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(setting)
        }
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        return true
    }
    
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Handle the URL here
        print("Received URL: \(url)")
        return true
    }
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
   

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Howl")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
extension AppDelegate: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
      let userInfo = notification.request.content.userInfo
      print(userInfo)
      completionHandler([[.alert, .sound]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
      let userInfo = response.notification.request.content.userInfo
      print(userInfo)
      
      completionHandler()
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult)
                       -> Void) {
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
}
extension AppDelegate: MessagingDelegate{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase Registration token: \(String(describing: fcmToken))")
        UserDefaults.standard.set(fcmToken, forKey: "FirebaseToken")
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMTOKEN"), object: nil, userInfo: dataDict)
    }
}
