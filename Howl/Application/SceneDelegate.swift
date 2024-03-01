//
//  SceneDelegate.swift
//  Howl
//
//  Created by apple on 16/08/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        // Capture the HOWL monitor me ID and save for use in the monitoring menu
        
        if let userActivity = connectionOptions.userActivities.first, let url = userActivity.webpageURL {
               // Handle the universal link here
            if userActivity.activityType == NSUserActivityTypeBrowsingWeb{
                print("Universal Link: \(url)")
                let lastPathComponenets = url.pathComponents.last
                print("lastPath",lastPathComponenets ?? "")
                kDataManager.walkId = lastPathComponenets
                print(kDataManager.walkId ?? "")
                UserDefaults.standard.set(lastPathComponenets, forKey: "MonitorOutPut")

                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "monitoring"), object: nil)
                
            }
           }
        
        if let url = connectionOptions.urlContexts.first?.url {
            
            let checkType = String(url.absoluteString.prefix(4))
            
            switch checkType {
                
            case "howl":
                
                let howlID = String(url.absoluteString.dropFirst(7))
                print("HowlId____", howlID)
                kDataManager.setMonitorYouID(id: howlID)
                kDataManager.setMonitorYouStatus(status: true)
                kDataManager.monitorYouNullDataCounter = 0
                kMonitorYouLocationManager.monitorYou()
                
                // Update the labels on the walker status page
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "monitoryouupdate"), object: nil)
                
            case "file":
                
                // Save the URL to datamanager and confirm imported is true
                kDataManager.sharedDogURL = url
                kDataManager.sharedDogImport = true
                
            default: break
                
                // Facebook SDK requirements
                //                ApplicationDelegate.shared.application(
                //                    UIApplication.shared,
                //                    open: url,
                //                    sourceApplication: nil,
                //                    annotation: [UIApplication.OpenURLOptionsKey.annotation]
                //                )
            }
        }
        
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL {
            // Handle the Universal Link URL here
            print("Universal Link: \(url)")
            let lastPathComponenets = url.pathComponents.last
            print("lastPath",lastPathComponenets ?? "")
            kDataManager.walkId = lastPathComponenets
            print(kDataManager.walkId ?? "")
            UserDefaults.standard.set(lastPathComponenets, forKey: "MonitorOutPut")

            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "monitoring"), object: nil)
            
        }
        
        
        // Perform the necessary actions based on the URL
    }
    
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        // Capture the HOWL monitor me ID and save for use in the monitoring menu
        if let url = URLContexts.first?.url {
            
            let checkType = String(url.absoluteString.prefix(4))
            
            switch checkType {
                
            case "howl":
                
                let howlID = String(url.absoluteString.dropFirst(7))
                kDataManager.setMonitorYouID(id: howlID)
                kDataManager.setMonitorYouStatus(status: true)
                kDataManager.monitorYouNullDataCounter = 0
                kMonitorYouLocationManager.monitorYou()
                
                // Update the labels on the walker status page
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "monitoryouupdate"), object: nil)
                
            case "file":
                
                // Save the URL to datamanager and confirm imported is true
                kDataManager.sharedDogURL = url
                kDataManager.sharedDogImport = true
                
            default: break
                
                // Facebook SDK requirements
                //                ApplicationDelegate.shared.application(
                //                    UIApplication.shared,
                //                    open: url,
                //                    sourceApplication: nil,
                //                    annotation: [UIApplication.OpenURLOptionsKey.annotation]
                //                )
            }
        }
    }
    
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard let url = userActivity.webpageURL else { return false }
        print("Universal Link---- \(url)")
        return true
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        if kDataManager.monitorMeLocal.count > 0 && kDataManager.monitorMeStatus == true {
            
            _ = kDataManager.saveMonitorMeLocal()
        }
        
        if kDataManager.monitorYouOutput.count > 0 && kDataManager.monitorYouStatus == true {
            
            kDataManager.saveMonitorYouData()
        }
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        if kDataManager.onScreenViewController is WalkerStatusVc {
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "monitoring"), object: nil)
        }
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
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
}

