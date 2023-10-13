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
            
            let coord = locationObj.coordinate
            
            longitude = String(describing: coord.longitude)
            latitude = String(describing: coord.latitude)
            speed = String(describing: locationObj.speed)
            course = String(describing: locationObj.course)
            
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
                forceUpdateToMonitorMeServerWithState(state: "Start Session")
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
                    
                    forceUpdateToMonitorMeServerWithState(state: "Auto-Update")
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
    
    func forceUpdateToMonitorMeServerWithState(state: String!) {
        
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
    }
    
    func stopMonitoringMe() {
        forceUpdateToMonitorMeServerWithState(state: "End Session")
        
        // Confirm you will stop being monitored
        kDataManager.setMonitorMeStatus(status: false)
        
        locationManager.stopUpdatingLocation()
        
        kDataManager.monitorMeLocal.removeAll()
    }
    
    func stopMonitoringMeWithIncident() {
        
        // Confirm session ended
        forceUpdateToMonitorMeServerWithState(state: "End Session")
        
        // Confirm you will stop being monitored
        kDataManager.setMonitorMeStatus(status: false)
        
        locationManager.stopUpdatingLocation()
        
        // Save your last walk to file for selection
        if kDataManager.monitorMeLocalHistoric.count > 7 {
            kDataManager.monitorMeLocalHistoric.insert(kDataManager.monitorMeLocal, at: 0)
            kDataManager.monitorMeLocalHistoric.removeLast()
            kDataManager.monitorMeLocal.removeAll()
            
        } else {
            
            kDataManager.monitorMeLocalHistoric.insert(kDataManager.monitorMeLocal, at: 0)
            kDataManager.monitorMeLocal.removeAll()
        }
        _ = kDataManager.saveMonitorMeLocalHistoric()
    }
    
    deinit {
        
    }
}
