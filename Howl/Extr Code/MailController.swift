//
//  MailController.swift
//  Howl
//
//  Created by Peter Farrell on 02/12/2021.
//  Copyright © 2021 App Intelligence Ltd. All rights reserved.
//

import UIKit
import Foundation
import MessageUI

class MailController: NSObject, MFMailComposeViewControllerDelegate {
    
    func shareDog(initialiser: UIViewController, dogIndex: Int) {
        
        // Set dog to data
        do {
            
            let dogData = try PropertyListEncoder().encode(DogDataManager.shared.dogs[kDataManager.selectedIndex])
            let dogString = dogData.base64EncodedString()
            let fileName = "dogshare.txt"
            
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

                let fileURL = dir.appendingPathComponent(fileName)

                do {
                    // Write the dog string to a file on disc
                    try dogString.write(to: fileURL, atomically: false, encoding: .utf8)
                    
                    
                    if  MFMailComposeViewController.canSendMail() {
                        
                        let mailComposer: MFMailComposeViewController! = MFMailComposeViewController() // set the mail controller
                        mailComposer.mailComposeDelegate = self
                        
                        if let attachment = try? Data(contentsOf: fileURL) {
                            
                            mailComposer.addAttachmentData(attachment, mimeType: "text", fileName: "dog.howlshare")
                        }
                        
                        mailComposer.setSubject("HOWL - Dog Share")
                        mailComposer.setMessageBody("Please find attached a dog shared for the HOWL app.  To use ensure you have the HOWL for help app installed then:\n\nhold your finger on the attached file\nselect share from the pop-up menu\nselect the HOWL app icon to import\nvisit the My Pack menu to finalise the import", isHTML: false)
                        
                        initialiser.present(mailComposer, animated: true, completion: nil)
                    } else {
                        kAlertManager.triggerAlertTypeWarning(warningTitle: "MAIL COMPOSER FAILED",
                                                              warningMessage: "Device is not capable of sending email.",
                                                              initialiser: initialiser)
                    }
                    
                } catch {
                    
                    kAlertManager.triggerAlertTypeWarning(warningTitle: "DATA ERROR",
                                                          warningMessage: "Dog data failed to generate.  Please try again or contact the developer to review",
                                                          initialiser: initialiser)
                }
            }
            
        } catch {
            
            kAlertManager.triggerAlertTypeWarning(warningTitle: "DATA ERROR",
                                                  warningMessage: "Dog data failed to generate.  Please try again or contact the developer to review",
                                                  initialiser: initialiser)
        }
    }
    
//    func sendIncident(initialiser: UIViewController, dogIndex: Int) {
//
//        var csvArray = Array<[String]>()
//
//        // Available Data
//        /*
//        [
//         "course": "-1.0",
//         "date": "17/03/2021",
//         "battery": "39.0",
//         "speed": "0.0",
//         "time": "13:18:24",
//         "longitude": "-1.6085460479354947",
//         "output": "1",
//         "id": "",
//         "latitude": "52.27189386945288",
//         "status": "Auto-Update"
//         ]
//        */
//
//        csvArray.append(["ID","DATE","TIME","LONGITUDE","LATITUDE","SPEED","COURSE","BATTERY","STATUS","W3W","W3WURL"])
//
//        for walk in DogDataManager.shared.dogs[dogIndex].dogIncident {
//
//            let row = [
//                "\(String(describing: walk.id!))",
//                "\(String(describing: walk.date!))",
//                "\(String(describing: walk.time!))",
//                "\(String(describing: walk.longitude!))",
//                "\(String(describing: walk.latitude!))",
//                "\(String(describing: walk.speed!))",
//                "\(String(describing: walk.course!))",
//                "\(String(describing: walk.battery!))",
//                "\(String(describing: walk.status!))",
//                "\(String(describing: walk.w3wWords!))",
//                "\(String(describing: walk.w3wURL!))"
//            ]
//            csvArray.append(row)
//        }
//
//        if  MFMailComposeViewController.canSendMail() {
//
//            let filePath = kDocumentsDirectory + "/incident.csv"
//
//            if FileManager().fileExists(atPath: filePath) {
//
//                guard let _ = try? FileManager().removeItem(atPath: filePath) else {
//
//                    kAlertManager.triggerAlertTypeWarning(warningTitle: "FILE ERROR",
//                                                          warningMessage: "Failed to remove monitor output file",
//                                                          initialiser: initialiser)
//                    return
//                }
//            }
//
//            let stream = OutputStream(toFileAtPath: filePath, append: false)!
//            let csv = try! CSVWriter(stream: stream)
//
//            for row in csvArray {
//
//                guard let _ = try? csv.write(row: row) else {
//
//                    kAlertManager.triggerAlertTypeWarning(warningTitle: "DATA CREATION ERROR",
//                                                          warningMessage: "Crashed at row: \(row)",
//                                                          initialiser: initialiser)
//                    return
//                }
//            }
//
//            csv.stream.close()
//
//            let mailComposer: MFMailComposeViewController! = MFMailComposeViewController() // set the mail controller
//            mailComposer.mailComposeDelegate = self
//
//            if let csvData = try? Data(contentsOf: URL(fileURLWithPath: filePath)) {
//
//                mailComposer.addAttachmentData(csvData, mimeType: "text/csv", fileName: "incident.csv")
//            }
//
//            mailComposer.setSubject("HOWL - Dog Walk Incident Details")
//            mailComposer.setMessageBody("Please find attached monitoring output from the HOWL app.", isHTML: false) // set name
//
//            initialiser.present(mailComposer, animated: true, completion: nil)
//        } else {
//            kAlertManager.triggerAlertTypeWarning(warningTitle: "MAIL COMPOSER FAILED",
//                                                  warningMessage: "Device is not capable of sending email.",
//                                                  initialiser: initialiser)
//        }
//    }
//
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//
//        switch result.rawValue {
//
//        case MFMailComposeResult.cancelled.rawValue:
//            ()
//        case MFMailComposeResult.saved.rawValue:
//            ()
//        case MFMailComposeResult.sent.rawValue:
//            ()
//        case MFMailComposeResult.failed.rawValue:
//            ()
//        default:
//            break
//        }
//
//        controller.dismiss(animated: true, completion: nil)
//    }
    
    func sendIncident(initialiser: UIViewController, dogIndex: Int, dogCSV: [String]) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            var csvArray = dogCSV
            print(csvArray)
            //["ID,DATE,TIME,LONGITUDE,LATITUDE,SPEED,COURSE,BATTERY,STATUS,W3W,W3WURL"]
            
//            for walk in DogDataManager.shared.dogs[dogIndex].dogIncident {
//                let row = "\(walk.walkID ),\(walk.walkDate ),\(walk.walkTime ),\(walk.walkLongitude ),\(walk.walkLatitude ),\(walk.walkSpeed ),\(walk.walkCourse ),\(walk.walkBattery ),\(walk.walkStatus ),\(walk.walkW3WWords ),\(walk.walkW3WURL )\n"
//                csvArray.append(row)
//            }
            print("csvArray", csvArray)
           
            let csvString = csvArray.joined(separator: "\n")
            if let csvData = csvString.data(using: .utf8) {
                mailComposer.addAttachmentData(csvData, mimeType: "text/csv", fileName: "incident.csv")
            }
            
            mailComposer.setSubject("HOWL - Dog Walk Incident Details")
            mailComposer.setMessageBody("Please find attached monitoring output from the HOWL app.", isHTML: false)
            
            initialiser.present(mailComposer, animated: true, completion: nil)
        } else {
            kAlertManager.triggerAlertTypeWarning(warningTitle: "MAIL COMPOSER FAILED",
                                                  warningMessage: "Device is not capable of sending email.",
                                                  initialiser: initialiser)
        }
    }

    // MARK: - MFMailComposeViewControllerDelegate

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        if result == .sent {
            // Handle the email sent successfully
        } else if result == .failed && error != nil {
            // Handle the email sending failure
        }
    }
}
