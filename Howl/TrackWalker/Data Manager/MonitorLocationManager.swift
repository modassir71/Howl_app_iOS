//
//  MonitorLocationManager.swift
//  Howl
//
//  Created by apple on 10/10/23.
//

import Foundation
import UIKit
import CoreLocation

class MonitorLocationManager: NSObject, CLLocationManagerDelegate{
    static let sharedInstance: MonitorLocationManager = {
        let instance = MonitorLocationManager()
        return instance
    }()
//    Variabble
    var walkStatusManager = WalkStatusManager.sharedInstance
    var locationManager: CLLocationManager!
    var startDate: Date!
    var startDateSet: Bool! = false
    let differenceInSeconds: Double! = 10
    var timer: Timer! = Timer()
    var isUpdating: Bool = false
    var requestCounter: Int = 0
   
    
    override init() {
        
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        stopMonitoringYou()
    }
    
    // MARK: MONITOR YOU
    func testToStartMonitoringOnLoad() {
        
        // Check if monitor you is already active from previous crashed session
        if walkStatusManager.monitorYouStatus == true && walkStatusManager.monitorYouID != "X" {
            
            // Is an active monitor you in place?
            if walkStatusManager.monitorYouOutput.count > 0 {
                
                // Check if same ID
                if let status = walkStatusManager.monitorYouOutput.last?["status"] {
                    
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
            if walkStatusManager.monitorYouOutput.count > 0 {
                
                // Check if same ID
                if let id = walkStatusManager.monitorYouOutput[0]["id"] {
                    
                    print("IMPORTED ID's:")
                    print("ID: \(id)")
                    print("NEW ID: \(walkStatusManager.monitorYouID!)")
                    
                    // Same ID / session
                    if id != walkStatusManager.monitorYouID! {
                        // New ID / session - clear session output
                        walkStatusManager.monitorYouOutput.removeAll()
                        walkStatusManager.saveMonitorYouData()
                        
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
            
          //  if Reachability.isConnectedToNetwork() {
                
                // prepare the upload attachments
                var uploadAttachments: [String:String] = Dictionary()
                
                uploadAttachments["access"] = WebURLs.accessid
                uploadAttachments["id"] = walkStatusManager.monitorYouID
                
                NetworkManager().performNetworkOperation(uploadAttachments: uploadAttachments,
                                                         url: WebURLs.monitoryou,
                                                         request: "monitoryou")
          //  }
        } else {
            requestCounter = 0
        }
    }
    
    // MARK: STOP MONITORING
    func stopMonitoringYou() {
        
        isUpdating = false
        // Removed as user wanted to retain info
        walkStatusManager.setMonitorYouStatus(status: false)
        //kDataManager.setMonitorYouID(id: "X")
        //kDataManager.monitorYouOutput.removeAll()
        walkStatusManager.saveMonitorYouData()
        locationManager.stopUpdatingLocation()
        
        // Update the labels on the walker status page
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "monitoryouupdate"), object: nil)
    }
    
    deinit {
        
    }
    
}
