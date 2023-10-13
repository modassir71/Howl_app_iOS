//
//  DataManager.swift
//  Just Move Simple
//
//  Created by Peter Farrell on 02/05/2020.
//  Copyright © 2020 App Intelligence Ltd. All rights reserved.
//

import UIKit
import Foundation

class DataManager {
    
    static let sharedInstance: DataManager = {
        
        let instance = DataManager()
        return instance
    }()
    
    // MARK: VARIABLES - GENERAL
    var onScreenViewController: UIViewController! // Store the current onscreen view controller
    var currentNetworkRequest: String! = "" // Passed from all views that use the NetworkManager to confirm the request type
    var webURL: String! = "" // Pass to hold the web URL when loading the WebViewer class
    var dogs: [Dog]! = [] // To hold your dogs
    var dogsArchive: [Dog]! = [] // To hold stolen / archived dogs
    var people: [Person]! = [] // to hold your humans // emergency contacts
    var updating: Bool! = false // to confirm if updating an active DOG or PEOPLE
    var selectedIndex: Int! = 0 // to hold a dog or people index when loading from table view
    var sharedDogURL: URL! // Holds the passed URL from a file share
    var sharedDogImport: Bool! = false // To confirm if a dog was passed
    var fromInfoToPermissions: Bool! = false // To confirm you went to the permissions menu from info
    var fromFirstLoadToPermissions: Bool! = false // To confirm if user skipped setup
    var sirenID:Int = 0 // Holds the siren index for HOWL
    var apnsToken: String! = "X" // Holds the token for receiving APNS notifications
    
    // MARK: VARIABLES - MONITORING
    var monitorMeStatus: Bool! = false // to hold the statur or your walk / monitoring request
    var monitorMeID: String! // to hold the unique monitor me ID for the monitoring session
    var monitorYouStatus: Bool! = false // to confirm if you have monitored someone
    var monitorYouID: String! // to hold the unique monitor me ID of someone you may monitor
    var monitorYouNullDataCounter: Int! = 0 // to vlidate if an old ID is used by counting the number of times no data is returned
    var indexOfPersonMonitoring: Int = 0 // to hold the position in people of who you wis hto monitor you
    var monitorYouOutput: [[String:String]]! = []
    var monitorMeLocal: [WalkUpdate]! = [] // to hold the walk you are currently on
    var monitorMeLocalHistoric: [[WalkUpdate]]! = [] // to save walk from previous so they can be applied to missing dogs as evidence
    
    init() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(stoppedMonitoring),
                                               name: NSNotification.Name(rawValue: "stoppedmonitoringyou"),
                                               object: nil)
        
        monitorYouNullDataCounter = 0
        
        // On load, load dogs
        if let loaded = loadDogs() {
            
            dogs = loaded
        } else {
            dogs = []
        }
        
        // On load, load dogs archive
        if let loaded = loadDogsArchive() {
            
            dogsArchive = loaded
        } else {
            dogsArchive = []
        }
        
        // On load, load humans
        if let loaded = loadPeople() {
            
            people = loaded
        } else {
            people = []
        }
        
        // On load, load monitor me status and ID
        if let loaded = UserDefaults.standard.value(forKey: "monitormestatus") as? Bool {
            
            monitorMeStatus = loaded
            
            if let secondLoad = UserDefaults.standard.value(forKey: "monitormeid") as? String {
                
                monitorMeID = "A5BI4CG4QIF24RUCADCPXMA62MC8M2"//secondLoad
            } else {
                monitorMeID = "X"
            }
        } else {
            monitorMeStatus = false
            monitorMeID = "X"
        }
        
        // On load, load monitor me
        if let loaded = loadMonitorMeLocal() {
            
            monitorMeLocal = loaded
        } else {
            monitorMeLocal = []
        }
        
        // On load, load monitor me saved
        if let loaded = loadMonitorMeLocalHistoric() {
            
            monitorMeLocalHistoric = loaded
        } else {
            monitorMeLocalHistoric = []
        }
        
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
        
        if let loaded = UserDefaults.standard.value(forKey: "siren") as? Int {
            
            sirenID = loaded
        } else {
            sirenID = 0
        }
    }
    
    func setAPNSToken(token: String!) {
        
        apnsToken = token
    }
    
    func setCurrentNetworkRequest(networkRequest: String!) {
        
        currentNetworkRequest = networkRequest
    }
    
    func setOnscreenViewController(onscreenView: UIViewController!) {
        
        onScreenViewController = onscreenView
    }
    
    func setWebUrl(url: String!) {
        
        webURL = url
    }
    
    // MARK: MONITOR ME
    func setMonitorMeStatus(status: Bool!) {
        
        monitorMeStatus = status
        UserDefaults.standard.set(monitorMeStatus, forKey: "monitormestatus")
        
        // If a new session started ensure you also save the monitor me ID
        if status == true {
            
            UserDefaults.standard.set(monitorMeID, forKey: "monitormeid")
        } else {
            monitorMeID = "X"
            UserDefaults.standard.set(monitorMeID, forKey: "monitormeid")
        }
    }
    
    // MARK: MONITORING YOU
    func setMonitorYouStatus(status: Bool!) {
        
        monitorYouStatus = status
        UserDefaults.standard.set(monitorYouStatus, forKey: "monitoryoustatus")
    }
    
    func setMonitorYouID(id: String!) {
        
        monitorYouID = id
        UserDefaults.standard.set(monitorYouID, forKey: "monitoryouid")
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
                
                kAlertManager.triggerAlertTypeWarning(warningTitle: "HOWL - Concerned",
                                                      warningMessage: "Walker is concerned",
                                                      initialiser: onScreenViewController)
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
                
                kAlertManager.triggerAlertTypeWarning(warningTitle: "HOWL",
                                                      warningMessage: "Walker has triggered a HOWL for help",
                                                      initialiser: onScreenViewController)
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
            
            kMonitorYouLocationManager.stopMonitoringYou()
            
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
                
                kAlertManager.triggerAlertTypeWarning(warningTitle: "HOWL",
                                                      warningMessage: "Walker has ended their dog walking session",
                                                      initialiser: onScreenViewController)
            }
            
        default: // IMPOSSIBLE
            ()
        }
        
        monitorYouOutput.insert(output, at: 0)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "monitoring"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mapupdate"), object: output)
        UserDefaults.standard.setValue(monitorYouOutput, forKey: "monitoryououtput")
    }
    
    func saveMonitorYouData() {
        
        UserDefaults.standard.setValue(monitorYouOutput, forKey: "monitoryououtput")
    }
    
    @objc func stoppedMonitoring() {
        
        kAlertManager.triggerAlertTypeWarning(warningTitle: "STOPPED MONITORING",
                                              warningMessage: "HOWL has stopped monitoring the ID passed as no data was returned",
                                              initialiser: onScreenViewController)
    }
    
    // MARK: IMPORT DOG SHARE
    func importDogShare() {
        
        // Confirm share is requested to process so no need to raise again
        sharedDogImport = false
        
        var outputError = false
        
        do {
            let data = try Data(contentsOf: sharedDogURL)
            
            if let dataToString = String(data: data, encoding: .utf8) {
                
                if let base64ToData = Data(base64Encoded: dataToString) {
                    
                    let dog = try PropertyListDecoder().decode(Dog.self, from: base64ToData)
                    
                    kDataManager.dogs.append(dog)
                    
                    if kDataManager.saveDogs() == true {
                        
                        kAlertManager.triggerAlertTypeWarning(warningTitle: "IMPORT SUCCESS",
                                                              warningMessage: "The dog has been imported to your pack",
                                                              initialiser: onScreenViewController)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dogimported"), object: nil)
                    
                        
                    } else {
                        outputError = true
                    }
                } else {
                    outputError = false
                }
            } else {
                outputError = true
            }
        } catch {
            
            kAlertManager.triggerAlertTypeWarning(warningTitle: "IMPORT ERROR",
                                                  warningMessage: "There was an error importing the shared dog.  Please try again or contat the developer to review",
                                                  initialiser: onScreenViewController)
        }
        
        if outputError == true {
            kAlertManager.triggerAlertTypeWarning(warningTitle: "IMPORT ERROR",
                                                  warningMessage: "There was an error importing the shared dog.  Please try again or contat the developer to review",
                                                  initialiser: onScreenViewController)
        }
    }
    
    // MARK: SAVE AND LOAD
    func saveSiren(index: Int!) {
        
        sirenID = index
        UserDefaults.standard.set(sirenID, forKey: "siren")
    }
    
    func saveDogs() -> Bool {
        
        var filePath = kDocumentsDirectory
        filePath = kDocumentsDirectory + "/howldogs"
        
        let fileURL = URL(fileURLWithPath: filePath)
        
        do {
            
            let data = try PropertyListEncoder().encode(dogs)
            let archiveData = try NSKeyedArchiver.archivedData(withRootObject: data,
                                                               requiringSecureCoding: false)
            try archiveData.write(to: fileURL)
            return true
            
        } catch {
            return false
        }
    }
    
    func loadDogs() -> [Dog]? {
        
        var filePath = kDocumentsDirectory
        filePath = kDocumentsDirectory + "/howldogs"
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            if let loadedInfo = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Data? {

                let loadedDogs = try PropertyListDecoder().decode([Dog].self, from: loadedInfo!)
                return loadedDogs
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    func saveDogsArchive() -> Bool {
        
        var filePath = kDocumentsDirectory
        filePath = kDocumentsDirectory + "/howldogsarchive"
        
        let fileURL = URL(fileURLWithPath: filePath)
        
        do {
            
            let data = try PropertyListEncoder().encode(dogsArchive)
            let archiveData = try NSKeyedArchiver.archivedData(withRootObject: data,
                                                               requiringSecureCoding: false)
            try archiveData.write(to: fileURL)
            return true
            
        } catch {
            return false
        }
    }
    
    func loadDogsArchive() -> [Dog]? {
        
        var filePath = kDocumentsDirectory
        filePath = kDocumentsDirectory + "/howldogsarchive"
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            if let loadedInfo = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Data? {

                let loadedDogs = try PropertyListDecoder().decode([Dog].self, from: loadedInfo!)
                return loadedDogs
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    func savePeople() -> Bool {
        
        var filePath = kDocumentsDirectory
        filePath = kDocumentsDirectory + "/howlpeople"
        
        let fileURL = URL(fileURLWithPath: filePath)
        
        do {
            
            let data = try PropertyListEncoder().encode(people)
            let archiveData = try NSKeyedArchiver.archivedData(withRootObject: data,
                                                               requiringSecureCoding: false)
            try archiveData.write(to: fileURL)
            return true
            
        } catch {
            return false
        }
    }
    
    func loadPeople() -> [Person]? {
        
        var filePath = kDocumentsDirectory
        filePath = kDocumentsDirectory + "/howlpeople"
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            if let loadedInfo = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Data? {
                var lo_adedHumans = try PropertyListDecoder().decode([Person].self, from: loadedInfo!)
                let loadedHumans = try PropertyListDecoder().decode([Person].self, from: loadedInfo!)
                return loadedHumans
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    func saveMonitorMeLocal() -> Bool {
        
        var filePath = kDocumentsDirectory
        filePath = kDocumentsDirectory + "/howlmonitormelocal"
        
        let fileURL = URL(fileURLWithPath: filePath)
        
        do {
            
            let data = try PropertyListEncoder().encode(monitorMeLocal)
            let archiveData = try NSKeyedArchiver.archivedData(withRootObject: data,
                                                               requiringSecureCoding: false)
            try archiveData.write(to: fileURL)
            return true
            
        } catch {
            return false
        }
    }
    
    func loadMonitorMeLocal() -> [WalkUpdate]? {
        
        var filePath = kDocumentsDirectory
        filePath = kDocumentsDirectory + "/howlmonitormelocal"
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            if let loadedInfo = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Data? {

                let loadedMonitorMeLocal = try PropertyListDecoder().decode([WalkUpdate].self, from: loadedInfo!)
                return loadedMonitorMeLocal
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    func saveMonitorMeLocalHistoric() -> Bool {
        
        var filePath = kDocumentsDirectory
        filePath = kDocumentsDirectory + "/howlmonitormelocalhistoric"
        
        let fileURL = URL(fileURLWithPath: filePath)
        
        do {
            
            let data = try PropertyListEncoder().encode(monitorMeLocalHistoric)
            let archiveData = try NSKeyedArchiver.archivedData(withRootObject: data,
                                                               requiringSecureCoding: false)
            try archiveData.write(to: fileURL)
            return true
            
        } catch {
            return false
        }
    }
    
    func loadMonitorMeLocalHistoric() -> [[WalkUpdate]]? {
        
        var filePath = kDocumentsDirectory
        filePath = kDocumentsDirectory + "/howlmonitormelocalhistoric"
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            if let loadedInfo = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Data? {

                let loadedMonitorMeLocalSaved = try PropertyListDecoder().decode([[WalkUpdate]].self, from: loadedInfo!)
                return loadedMonitorMeLocalSaved
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: "stoppedmonitoringyou"),
                                                  object: nil)
    }
}
