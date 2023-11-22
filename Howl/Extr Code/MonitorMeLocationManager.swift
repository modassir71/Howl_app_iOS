//
//  LocationManager.swift
//  Howl
//
//  Created by Peter Farrell on 02/12/2021.
//  Copyright © 2021 App Intelligence Ltd. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation
import W3WSwiftApi
import Firebase
struct WalkModel: Codable {
    var battery: String
    var course: String
    var date: String
    var flag: String
    var id: Int
    var lat: String
    var lon: String
    var randomId: String
    var speed: String
    var state: String
    var time: String
    var w3w: String
    var w3wurl: String
}

class MonitorMeLocationManager: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var longitude: String! = "NOT SET"
    var latitude: String! = "NOT SET"
    var speed: String! = "NOT SET"
    var course: String! = "NOT SET"
    var startDate: Date!
    var startDateSet: Bool! = false
    let differenceInSeconds: Double! = 10
    var timer: Timer! = Timer()
    var firstOutput: Bool = true
    var w3wAPI: What3WordsV3!
    var w3wWords: String! = "NOT SET"
    var w3wURL: String! = "NOT SET"
    var lat: String?
    var lng: String?
    var flag: String?
    var lastUpdatesArray: [WalkFetch] = []
    
    
    static let sharedInstance: MonitorMeLocationManager = {
        
        let instance = MonitorMeLocationManager()
        return instance
    }()
    
    override init() {
        
        // Initialise What 3 Words
        w3wAPI = What3WordsV3(apiKey: WebURLs.what3wordsapikey)
        
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        switch locationManager.authorizationStatus {
        
        case .authorizedAlways:
            
            firstOutput = true
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.allowsBackgroundLocationUpdates = true
            
        case .authorizedWhenInUse:
            
            locationManager.requestAlwaysAuthorization()
            
        case .notDetermined:
            
            locationManager.requestWhenInUseAuthorization()
            
        case .denied:
            
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted:
            
            locationManager.requestWhenInUseAuthorization()
            
        @unknown default:
            
            locationManager.requestWhenInUseAuthorization()
        }
        
        print(String(describing: locationManager.authorizationStatus))
    }
    
    func forceUpdateToMonitorMeServer(with monitorID: String) {
        let databaseReference = Database.database().reference()

        databaseReference.child(kDataManager.monitorId).setValue(true) { (error, _) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                // Handle the error, you might want to show a message to the user
            } else {
                print("Monitor ID Updated Successfully")
                // You can put any code here that you want to execute on successful update
            }
        }
    }
    
    func monitorMe() {
        
        // Confirm you are being monitored
        kDataManager.monitorMeStatus = true
        
        switch locationManager.authorizationStatus {
        
        case .authorizedAlways:
            
            kDataManager.setMonitorMeStatus(status: true)
            firstOutput = true
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.allowsBackgroundLocationUpdates = true
            
        case .authorizedWhenInUse:
            
            locationManager.requestAlwaysAuthorization()
            
        case .notDetermined:
            
            locationManager.requestWhenInUseAuthorization()
            
        case .denied:
            
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted:
            
            locationManager.requestWhenInUseAuthorization()
            
        @unknown default:
            
            locationManager.requestWhenInUseAuthorization()
        }
        
        print(String(describing: locationManager.authorizationStatus))
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        
        case .authorizedAlways:
            
            firstOutput = true
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.allowsBackgroundLocationUpdates = true
            
        case .authorizedWhenInUse:
            
            locationManager.requestAlwaysAuthorization()
            
        case .notDetermined:
            
            locationManager.requestWhenInUseAuthorization()
            
        case .denied:
            
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted:
            
            locationManager.requestWhenInUseAuthorization()
            
        @unknown default:
            locationManager.requestWhenInUseAuthorization()
        }
        
        print(String(describing: locationManager.authorizationStatus))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        longitude = "UNAVAILABLE"
        latitude = "UNAVAILABLE"
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let locationObj = locations.last {
//            delegate?.didUpdateLocations(locations)
//            didUpdateLocationsCallback?(locationObj)
            let coord = locationObj.coordinate
            
            longitude = String(describing: coord.longitude)
            latitude = String(describing: coord.latitude)
            print("Lattituderr", latitude ?? "")
            print("Longituddde", longitude ?? "")
            speed = String(describing: locationObj.speed)
            course = String(describing: locationObj.course)
            lat = latitude
            lng = longitude
            
            if firstOutput == true {
                
                if Reachability.isConnectedToNetwork() {
                    
                    // What 3 words positioning output
                    w3wAPI.convertTo3wa(coordinates: coord, language: "en") { square, error in
                        
                        if square != nil {
                            
                            self.w3wWords = square?.words
                            self.w3wURL = "https://what3words.com/" + (square?.words)!
                        } else {
                            self.w3wWords = "NOT SET"
                            self.w3wURL = "NOT SET"
                        }
                    }
                }
                
                // First load confirm safe
                firstOutput = false
                forceUpdateToMonitorMeServerWithState(state: "Start Session", latitude: latitude, longitude: longitude)
            }
            
            // Set the start date and compare to current location update pinging data to the server at a given period
            switch startDateSet {
            
            case true:
                
                let elapseTimeInSeconds = locationObj.timestamp.timeIntervalSince(startDate)

                if elapseTimeInSeconds > differenceInSeconds {
                    
                    if Reachability.isConnectedToNetwork() {
                        
                        // What 3 words positioning output
                        w3wAPI.convertTo3wa(coordinates: coord, language: "en") { square, error in
                            
                            if square != nil {

                                self.w3wWords = square?.words
                                self.w3wURL = "https://what3words.com/" + (square?.words)!
                            } else {
                                self.w3wWords = "NOT SET"
                                self.w3wURL = "NOT SET"
                            }
                        }
                    }
                    
                   // forceUpdateToMonitorMeServerWithState(state: "Auto-Update")
                    forceUpdateToMonitorMeServerWithState(state: "Auto-Update", latitude: latitude, longitude: longitude)
                    startDateSet = false
                }
                
            case false:
                
                startDate = locationObj.timestamp
                startDateSet = true
                
            default:
                ()
            }
        }
    }
    
 /*func forceUpdateToMonitorMeServerWithState(state: String!) {
        
        if Reachability.isConnectedToNetwork() {
            
            // Check for nil on first load
            if kDataManager.monitorMeID != nil {
            
                // prepare the upload attachments
                var uploadAttachments: [String:String] = Dictionary()
                
                uploadAttachments["access"] = WebURLs.accessid
                uploadAttachments["id"] = kDataManager.monitorMeID
                uploadAttachments["long"] = longitude
                uploadAttachments["lat"] = latitude
                uploadAttachments["speed"] = speed
                uploadAttachments["course"] = course
                uploadAttachments["date"] = Helpers().returnTodaysDate()
                uploadAttachments["time"] = Helpers().returnTheTimeNow()
                uploadAttachments["battery"] = String(describing: UIDevice.current.batteryLevel * 100)
                uploadAttachments["status"] = state
                uploadAttachments["w3w"] = w3wWords
                uploadAttachments["w3wurl"] = w3wURL
                
                // Create a walk update for local monitor me storage
                let update = WalkUpdate(walkID: kDataManager.monitorMeID,
                                        walkLongitude: longitude,
                                        walkLatitude: latitude,
                                        walkSpeed: speed,
                                        walkCourse: course,
                                        walkDate: Helpers().returnTodaysDate(),
                                        walkTime: Helpers().returnTheTimeNow(),
                                        walkBattery: String(describing: UIDevice.current.batteryLevel * 100),
                                        walkStatus: state,
                                        walkW3WWords: w3wWords,
                                        walkW3WURL: w3wURL)
                
                kDataManager.monitorMeLocal.append(update)
                
                NetworkManager().performNetworkOperation(uploadAttachments: uploadAttachments,
                                                         url: WebURLs.monitorme,
                                                         request: "monitorme")
            }
        }
    }*/
    
    func forceUpdateToMonitorMeServerWithState(state: String, latitude: String, longitude: String) {
        if Reachability.isConnectedToNetwork() {
            // Check for nil on first load
            let monitorIds = UserDefaults.standard.string(forKey: "MonitorIds")
            print("MonitorIds", monitorIds ?? "")
            if let monitorMeID = monitorIds {
                let databaseReference = Database.database().reference()

                // Prepare the data to be stored in Firebase
                var monitorUpdateDictionary: [String: Any] = [
                    "randomId": monitorMeID,
                    "lon": longitude,
                    "lat": latitude,
                    "speed": speed ?? "",
                    "course": course ?? "",
                    "date": Helpers().returnTodaysDate(),
                    "time": Helpers().returnTheTimeNow(),
                    "battery": String(format: "%.2f", UIDevice.current.batteryLevel * 100),
                    "state": state,
                    "w3w": "", // Set default value to an empty string
                    "w3wurl": "", // Set default value to an empty string
                   // "state": state,
                    "device": "iOS",
                    "flag": "0"
                ]

                // Assuming 'monitorMeData' is the database node where you want to store this data
                let newChildRef = databaseReference.child(monitorIds ?? "").childByAutoId()

                // Conditionally update walkW3WWords and walkW3WURL if they are not nil
                if let w3wWords = w3wWords, let w3wURL = w3wURL {
                    monitorUpdateDictionary["w3w"] = w3wWords
                    monitorUpdateDictionary["w3wurl"] = w3wURL
                }

                // Store the data in Firebase
                newChildRef.setValue(monitorUpdateDictionary) { (error, _) in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    } else {
                        print("Data Inserted", monitorUpdateDictionary)
                        // Data inserted successfully
                        // You can add any handling or notifications you need here
                    }
                }
            }
        }
    }

    func fetchWalkUpdatesFromFirebase(completion: @escaping ([WalkFetch]?) -> Void) {
        let databaseReference = Database.database().reference()
//        let monitorMeID = kDataManager.walkId ?? ""
//        print("monitorIds", monitorMeID)
        let retriveValue = UserDefaults.standard.string(forKey: "MonitorOutPut") ?? ""
        print("retriveValue", retriveValue)
        databaseReference.child(retriveValue).observeSingleEvent(of: .value) { snapshot,ee  in
            guard let dataDict = snapshot.value as? [String: [String: Any]] else {
                completion(nil)
                return
            }
            
            var walkUpdates = [WalkFetch]()
            
            for (_, value) in dataDict {
                if let walkID = value["randomId"] as? String,
                   let walkLongitude = value["lon"] as? String,
                   let walkLatitude = value["lat"] as? String,
                   let walkSpeed = value["speed"] as? String,
                   let walkCourse = value["course"] as? String,
                   let walkDate = value["date"] as? String,
                   let walkTime = value["time"] as? String,
                   let walkBattery = value["battery"] as? String,
                   let walkStatus = value["state"] as? String,
                   let walkW3WWords = value["w3w"] as? String,
                   let walkW3WURL = value["w3wurl"] as? String,
                   let flag = value["flag"] as? String,
                   let device = value["device"] as? String{
                    let walkUpdate = WalkFetch(
                        walkID: walkID,
                        walkLatitude: walkLatitude, walkLongitude: walkLongitude,
                        walkSpeed: walkSpeed,
                        walkCourse: walkCourse,
                        walkDate: walkDate,
                        walkTime: walkTime,
                        walkBattery: walkBattery,
                        walkStatus: walkStatus,
                        walkW3WWords: walkW3WWords,
                        walkW3WURL: walkW3WURL, flag: flag,
                        device: device
                    )
                    walkUpdates.append(walkUpdate)
                }
            }
            
            completion(walkUpdates)
        }
    }
    
    func fetchDataForIncident(completion: @escaping ([WalkFetch]?) -> Void) {
        let databaseReference = Database.database().reference()
//        let monitorMeID = kDataManager.walkId ?? ""
//        print("monitorIds", monitorMeID)
        let retriveValue = UserDefaults.standard.string(forKey: "MonitorIds") ?? ""
        
        databaseReference.child(retriveValue).observeSingleEvent(of: .value) { snapshot,ee  in
            guard let dataDict = snapshot.value as? [String: [String: Any]] else {
                completion(nil)
                return
            }
            
            var walkUpdates = [WalkFetch]()
            
            for (_, value) in dataDict {
                if let walkID = value["randomId"] as? String,
                   let walkLongitude = value["lon"] as? String,
                   let walkLatitude = value["lat"] as? String,
                   let walkSpeed = value["speed"] as? String,
                   let walkCourse = value["course"] as? String,
                   let walkDate = value["date"] as? String,
                   let walkTime = value["time"] as? String,
                   let walkBattery = value["battery"] as? String,
                   let walkStatus = value["state"] as? String,
                   let walkW3WWords = value["w3w"] as? String,
                   let walkW3WURL = value["w3wurl"] as? String,
                   let flag = value["flag"] as? String,
                   let device = value["device"] as? String{
                    let walkUpdate = WalkFetch(
                        walkID: walkID,
                        walkLatitude: walkLatitude, walkLongitude: walkLongitude,
                        walkSpeed: walkSpeed,
                        walkCourse: walkCourse,
                        walkDate: walkDate,
                        walkTime: walkTime,
                        walkBattery: walkBattery,
                        walkStatus: walkStatus,
                        walkW3WWords: walkW3WWords,
                        walkW3WURL: walkW3WURL, flag: flag,
                        device: device
                    )
                    walkUpdates.append(walkUpdate)
                }
            }
            
            completion(walkUpdates)
        }
    }







    
//    func stopMonitoringMe() {
//
//        //forceUpdateToMonitorMeServerWithState(state: "End Session")
//        forceUpdateToMonitorMeServerWithState(state: "End Session", latitude: lat ?? "", longitude: lng ?? "")
//
//        // Confirm you will stop being monitored
//        kDataManager.setMonitorMeStatus(status: false)
//
//        locationManager.stopUpdatingLocation()
//
//        kDataManager.monitorMeLocal.removeAll()
//    }
    func stopMonitoringMe() {
        //forceUpdateToMonitorMeServerWithState(state: "End Session")
        forceUpdateToMonitorMeServerWithState(state: "End Session", latitude: lat ?? "", longitude: lng ?? "")

        // Confirm you will stop being monitored
        kDataManager.setMonitorMeStatus(status: false)
//        removeAllDataFromFirebase()
        DogDataManager.shared.walkMonitor = ""
        locationManager.stopUpdatingLocation()

        kDataManager.monitorMeLocal.removeAll()
        kDataManager.walkId = ""
        UserDefaults.standard.removeObject(forKey: "MonitorIds")
    }
    
    func removeAllDataFromFirebase() {
        if Reachability.isConnectedToNetwork() {
            let retriveVale =  UserDefaults.standard.string(forKey: "MonitorIds") ?? ""
            let databaseReference = Database.database().reference()
            let dataNodeReference = databaseReference.child(retriveVale)

            dataNodeReference.removeValue { error, _ in
                if let error = error {
                    print("Error removing data: \(error.localizedDescription)")
                } else {
                    print("All data removed successfully")
                }
            }
        }
        DogDataManager.shared.walkMonitor = ""
        UserDefaults.standard.removeObject(forKey: "MonitorIds")
    }
    
    
    func stopMonitoringMeWithIncident() {
        forceUpdateToMonitorMeServerWithState(state: "End Session with incident", latitude: lat ?? "", longitude: lng ?? "")
        
        // Confirm you will stop being monitored
        kDataManager.setMonitorMeStatus(status: false)
        
        locationManager.stopUpdatingLocation()
        
        // Save your last walk to file for selection
        if kDataManager.monitorMeLocalHistoric.count > 7 {
            
            kDataManager.monitorMeLocalHistoric.insert(kDataManager.monitorMeLocal, at: 0)
            kDataManager.monitorMeLocalHistoric.removeLast()
            kDataManager.monitorMeLocal.removeAll()
            
        } else {
            fetchDataForIncident { [weak self] walkUpdates in
                if let walkUpdates = walkUpdates {
                    if let lastData = walkUpdates.last {
                        // if lastData.walkStatus == "End Session"{
                        // Create a variable to hold the last object
                        let newWalkUpdate = WalkFetch(
                            walkID: lastData.walkID,
                            walkLatitude: lastData.walkLatitude, walkLongitude: lastData.walkLongitude,
                            walkSpeed: lastData.walkSpeed,
                            walkCourse: lastData.walkCourse,
                            walkDate: lastData.walkDate,
                            walkTime: lastData.walkTime,
                            walkBattery: lastData.walkBattery,
                            walkStatus: lastData.walkStatus,
                            walkW3WWords: lastData.walkW3WWords,
                            walkW3WURL: lastData.walkW3WURL,
                            flag: lastData.flag, device: lastData.device
                        )
                        
                        // Append the last object to lastUpdatesArray
                        self?.lastUpdatesArray.append(newWalkUpdate)

                    }
                }
            }

            kDataManager.monitorMeLocalHistoric.insert(kDataManager.monitorMeLocal, at: 0)
            kDataManager.monitorMeLocal.removeAll()
        }
        _ = kDataManager.saveMonitorMeLocalHistoric()
//        removeAllDataFromFirebase()
        kDataManager.walkId = ""
        UserDefaults.standard.removeObject(forKey: "MonitorIds")
    }
    
    deinit {
        
    }
}
