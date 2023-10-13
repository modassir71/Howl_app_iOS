//
//  NetworkManager.swift
//  Just Move Simple
//
//  Created by Peter Farrell on 02/05/2020.
//  Copyright © 2020 App Intelligence Ltd. All rights reserved.
//

import UIKit
import Foundation

class NetworkManager: NSObject, URLSessionDelegate {
    
    // MARK: NetworkManager Variables
    private var JSONData: Data!
    private var base64String: String!
    private var base64Data: Data!
    private var requestType: String!
    
    func performNetworkOperation(uploadAttachments: [String:String],
                                 url: String!,
                                 request: String!) {
        
        // Set the request type so we know if monitor Me or You
        requestType = request
        
        if kDataLoggingIsActive {
            
            print("***** NETWORK LOGGING UPLOADS *****")
            print("ATTACHMENTS: \(uploadAttachments)")
        }
        
        let operationUrl = URL(string: url)
        var request = URLRequest(url: operationUrl!)
        request.httpMethod = "POST"
        request.timeoutInterval = 30
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Set any attachments if available
        do {
            JSONData = try JSONSerialization.data(withJSONObject: uploadAttachments, options: .prettyPrinted)
            
            base64String = JSONData!.base64EncodedString(options: NSData.Base64EncodingOptions()) // Set as base64 string
            base64String = "json=" + base64String
            base64Data = base64String.data(using: String.Encoding.utf8, allowLossyConversion: true) // Convert to NSData
            request.setValue("\(base64Data!.count)", forHTTPHeaderField: "Content-Length") // Confirm data length
            
            // Set as the body of the request
            request.httpBody = base64Data
        } catch _ {
            // ********** DO SOMETHING HERE WITH DATA FAILS IF ANY ****************
        }
        
        if kDeepDataLogging {
            
            print("JSON: \(String(data: JSONData, encoding: .utf8)!)")
        }
        
        // Set standard configuration and create session on main queue
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            if kDeepDataLogging {
                
                print("NETWORK TASK PROCESSED...")
                print("RESPONSE: \(String(describing: response))")
            }
            
            if error != nil {
                
                // Process error
                self.processNSURLSessionFailure(error as NSError?)
                
            } else {
                
                // Process data
                self.processNSURLSessionSuccess(data)
            }
        })
        
        print("NETWORK TASK HAS BEGUN...")
        
        task.resume() // Resume the task
    }
    
    private func processNSURLSessionFailure(_ error: NSError!) {
        
        if kDataLoggingIsActive {
            
            print("NETWORK TASK ERROR...")
            print("ERROR: \(error!)")
        }
    }
    
    private func processNSURLSessionSuccess(_ data: Data!) {
        
        if data != nil {
            
            if kDataLoggingIsActive {
                
                print("RETURNED DATA IS:")
                if let printData = String(data: data, encoding: .utf8)!.base64Decoded() {
                    
                    print(printData)
                } else {
                    print(String(data: data, encoding: .utf8)!)
                }
                
            }
            
            switch requestType {
                
            case "monitorme": // MONITOR ME
                ()
                // Nothinhg to do, just outputting data
                
            case "monitoryou": // MONITOR YOU
                
                // Standard response required to add a session object
                if let upperDictionary = data.jsonDataToDictionary() {
                    
                    if let innerData = upperDictionary["data"]?.convertStringtoDatatoArray() {
                        
                        for instance in innerData {
                            
                            kDataManager.monitorYouNullDataCounter = 0
                            kDataManager.updateMonitorYouOutput(output: instance)
                        }
                    } else {
                        
                        if kDataManager.monitorYouNullDataCounter == 360 {
                            
                            kDataManager.monitorYouNullDataCounter = 0
                            kMonitorYouLocationManager.stopMonitoringYou()
                            
                            // Confirm if in background and if so post a notification
                            let state = UIApplication.shared.applicationState
                            if state == .background {
                                
                                let content = UNMutableNotificationContent()
                                content.title = "HOWL - Stopped"
                                content.subtitle = "An hour has passed with no data for this ID"
                                content.sound = UNNotificationSound.default
                                
                                let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                                    content: content,
                                                                    trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false))

                                // add our notification request
                                UNUserNotificationCenter.current().add(request)
                            } else {
                                
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stoppedmonitoringyou"), object: nil)
                            }
                        
                        } else {
                            kDataManager.monitorYouNullDataCounter += 1
                        }
                    }
                } else {
                    
                    if kDataManager.monitorYouNullDataCounter == 360 {
                        
                        kDataManager.monitorYouNullDataCounter = 0
                        kMonitorYouLocationManager.stopMonitoringYou()
                        
                        // Confirm if in background and if so post a notification
                        let state = UIApplication.shared.applicationState
                        if state == .background {
                            
                            let content = UNMutableNotificationContent()
                            content.title = "HOWL - Stopped"
                            content.subtitle = "An hour has passed with no data for this ID"
                            content.sound = UNNotificationSound.default
                            
                            let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                                content: content,
                                                                trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false))

                            // add our notification request
                            UNUserNotificationCenter.current().add(request)
                        } else {
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stoppedmonitoringyou"), object: nil)
                        }
                    } else {
                        kDataManager.monitorYouNullDataCounter += 1
                    }
                }
                
                // Update the labels on the walker status page
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "monitoryouupdate"), object: nil)
                
            default: // IMPOSSIBLE
                ()
            }
        }
    }
}
