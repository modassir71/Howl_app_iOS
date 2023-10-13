//
//  WalkStatusManager.swift
//  Howl
//
//  Created by apple on 10/10/23.
//
/*
import Foundation
import UserNotifications
import UIKit

class WalkStatusManager{
    static let sharedInstance: WalkStatusManager = {
        
        let instance = WalkStatusManager()
        return instance
    }()
//    Variable
    var onScreenViewController: UIViewController!
    var monitorYouID: String!
    var monitorYouStatus: Bool! = false
    var monitorYouOutput: [[String:String]]! = []
    var monitorYouNullDataCounter: Int! = 0 // to vlidate if an old ID is used by counting the number of times no data is returned
    var webURL: String! = "" // Pass to hold the web URL when loading the WebViewer class
    
    init() {
        monitorYouNullDataCounter = 0
        setMonitorYouStatus(status: false)
        setMonitorYouID(id: "Q9DTPVCFNKSFH5WKTEMSNLK87GZ9AH")
        // On load, load monitor you
        if let loaded = UserDefaults.standard.value(forKey: "monitoryoustatus") as? Bool {
            
            monitorYouStatus = loaded
            
            if let secondLoad = UserDefaults.standard.value(forKey: "monitoryouid") as? String {
                
                monitorYouID = secondLoad
            } else {
                monitorYouID = "X"
            }
        } else {
            monitorYouStatus = false
            monitorYouID = "X"
        }
        
        if let loaded = UserDefaults.standard.value(forKey: "monitoryououtput") as? [[String:String]] {
            monitorYouOutput = loaded
        } else {
            monitorYouOutput = []
            monitorYouOutput.removeAll()
        }
    }
    
    func setWebUrl(url: String!) {
        
        webURL = url
    }
    
    func setOnscreenViewController(onscreenView: UIViewController!) {
        
        onScreenViewController = onscreenView
    }
    
    
    func setMonitorYouStatus(status: Bool!) {
        
        monitorYouStatus = status
        UserDefaults.standard.set(monitorYouStatus, forKey: "monitoryoustatus")
    }
    
    func setMonitorYouID(id: String!) {
        monitorYouID = id
        UserDefaults.standard.set(monitorYouID, forKey: "monitoryouid")
    }
    
    func saveMonitorYouData() {
        
        UserDefaults.standard.setValue(monitorYouOutput, forKey: "monitoryououtput")
    }
    
    
    
    
    
    func updateMonitorYouOutput(output: [String:String]!) {
        
        switch output["status"] {
            
        case "Concerned":
            
            let content = UNMutableNotificationContent()
            content.title = "HOWL - Concerned"
            content.subtitle = "Walker is concerned"
            content.sound = UNNotificationSound.default
            
            let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                content: content,
                                                trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false))
            
            let state = UIApplication.shared.applicationState
            if state == .background {
                
                // add our notification request
                UNUserNotificationCenter.current().add(request)
            } else {
                print("Walker is concerned")
//                kAlertManager.triggerAlertTypeWarning(warningTitle: "HOWL - Concerned",
//                                                      warningMessage: "Walker is concerned",
//                                                      initialiser: onScreenViewController)
            }
            
        case "HOWL":
            
            let content = UNMutableNotificationContent()
            content.title = "HOWL for help"
            content.subtitle = "Walker has triggered a HOWL for help"
            content.sound = UNNotificationSound.defaultCritical
            
            let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                content: content,
                                                trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false))
            
            let state = UIApplication.shared.applicationState
            if state == .background {
                
                // add our notification request
                UNUserNotificationCenter.current().add(request)
            } else {
                print("Walker has triggered a HOWL for help")
//                kAlertManager.triggerAlertTypeWarning(warningTitle: "HOWL",
//                                                      warningMessage: "Walker has triggered a HOWL for help",
//                                                      initialiser: onScreenViewController)
            }
            
        case "Im Safe":
            
            let content = UNMutableNotificationContent()
            content.title = "HOWL - Safe"
            content.subtitle = "Walker is safe"
            content.sound = UNNotificationSound.defaultCritical
            
            let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                content: content,
                                                trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false))

            // add our notification request
            UNUserNotificationCenter.current().add(request)
            
        case "End Session":
            
            MonitorLocationManager.sharedInstance.stopMonitoringYou()
            
            let content = UNMutableNotificationContent()
            content.title = "HOWL - Ended"
            content.subtitle = "Walker has ended their dog walking session"
            content.sound = UNNotificationSound.default
            
            let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                content: content,
                                                trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false))
            
            
            let state = UIApplication.shared.applicationState
            if state == .background {
                
                // add our notification request
                UNUserNotificationCenter.current().add(request)
            } else {
                print("Walker has ended their dog walking session")
//                kAlertManager.triggerAlertTypeWarning(warningTitle: "HOWL",
//                                                      warningMessage: "Walker has ended their dog walking session",
//                                                      initialiser: onScreenViewController)
            }
            
        default: // IMPOSSIBLE
            ()
        }
        
        monitorYouOutput.insert(output, at: 0)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "monitoring"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mapupdate"), object: output)
        UserDefaults.standard.setValue(monitorYouOutput, forKey: "monitoryououtput")
    }
}
*/
