//
//  MonitorYouLocationManager.swift
//  Howl
//
//  Created by Peter Farrell on 02/01/2022.
//  Copyright © 2022 App Intelligence Ltd. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

class MonitorYouLocationManager: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var startDate: Date!
    var startDateSet: Bool! = false
    let differenceInSeconds: Double! = 10
    var timer: Timer! = Timer()
    var isUpdating: Bool = false
    var requestCounter: Int = 0
    
    static let sharedInstance: MonitorYouLocationManager = {
        
        let instance = MonitorYouLocationManager()
        return instance
    }()
    
    override init() {
        
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    // MARK: MONITOR YOU
    func testToStartMonitoringOnLoad() {
        
        // Check if monitor you is already active from previous crashed session
        if kDataManager.monitorYouStatus == true && kDataManager.walkId != "X" {
            
            // Is an active monitor you in place?
            if kDataManager.monitorYouOutput.count > 0 {
                
                // Check if same ID
                if let status = kDataManager.monitorYouOutput.last?["status"] {
                    
                    // Has the saved session ended
                    if status == "End Session" {
                        // Dont start monitoring if it has
                    } else {
                        monitorYou()
                    }
                }
            } else {
                monitorYou()
            }
        } else {
            // Overly cautious, likely impossible but just ensure all is reset correctly
            // kDataManager.monitorYouStatus = false
            // kDataManager.monitorYouID = "X"
        }
    }
    
    func monitorYou() {
        
        switch locationManager.authorizationStatus {
        
        case .authorizedAlways:
            
            // Is an active monitor you in place?
            if kDataManager.monitorYouOutput.count > 0 {
                
                // Check if same ID
                if let id = kDataManager.monitorYouOutput[0]["id"] {
                    
                    print("IMPORTED ID's:")
                    print("ID: \(id)")
                    print("NEW ID: \(kDataManager.walkId!)")
                    
                    // Same ID / session
                    if id != kDataManager.walkId! {
                        // New ID / session - clear session output
                        kDataManager.monitorYouOutput.removeAll()
                        kDataManager.saveMonitorYouData()
                        
                        // Update the labels on the walker status page
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "monitoryouupdate"), object: nil)
                    }
                }
            }
            
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.allowsBackgroundLocationUpdates = true
            // downloadLocationUpdate()
            
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
    
    // MARK: LOCATION MANAGER
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        
        case .authorizedAlways:
            
            testToStartMonitoringOnLoad()
            //locationManager.startUpdatingLocation()
            //locationManager.desiredAccuracy = kCLLocationAccuracyBest
            //locationManager.allowsBackgroundLocationUpdates = true
            
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
        
        isUpdating = false
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        isUpdating = true
        
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        
        // Set the start date and compare to current and download data based on time difference
        switch startDateSet {
        
        case true:
            
            let elapseTimeInSeconds = locationObj.timestamp.timeIntervalSince(startDate)

            if elapseTimeInSeconds > differenceInSeconds {
                
                downloadLocationUpdate()
                requestCounter += 1
                startDateSet = false
            }
            
        case false:
            
            startDate = locationObj.timestamp
            startDateSet = true
            downloadLocationUpdate()
            
        default:
            ()
        }
    }
    
    // MARK: DOWNLOAD UPDATES
    func downloadLocationUpdate() {
        
        // Ensure only 1 request at a time
        // Location calls can duplicate
        if requestCounter == 0 {
            
            if Reachability.isConnectedToNetwork() {
                
                // prepare the upload attachments
                var uploadAttachments: [String:String] = Dictionary()
                
                uploadAttachments["access"] = WebURLs.accessid
                uploadAttachments["id"] = kDataManager.monitorYouID
                
                NetworkManager().performNetworkOperation(uploadAttachments: uploadAttachments,
                                                         url: WebURLs.monitoryou,
                                                         request: "monitoryou")
            }
        } else {
            requestCounter = 0
        }
    }
    
    // MARK: STOP MONITORING
    func stopMonitoringYou() {
        
        isUpdating = false
        // Removed as user wanted to retain info
        kDataManager.setMonitorYouStatus(status: false)
        kDataManager.setMonitorYouID(id: "X")
        kDataManager.monitorYouOutput.removeAll()
        kDataManager.saveMonitorYouData()
        locationManager.stopUpdatingLocation()
        
        // Update the labels on the walker status page
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "monitoryouupdate"), object: nil)
    }
    
    deinit {
        
    }
}
