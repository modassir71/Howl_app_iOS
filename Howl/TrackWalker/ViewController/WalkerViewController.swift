//
//  WalkerViewController.swift
//  Howl
//
//  Created by apple on 31/10/23.
//

import UIKit
import Foundation
import MapKit

class WalkerViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var monitorYouMap: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(addAnnotations(_:)),
                                               name: NSNotification.Name(rawValue: "mapupdate"),
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if kDataManager.monitorYouOutput.count <= 0 {
            
            monitorYouMap.removeAnnotations(monitorYouMap.annotations)
            monitorYouMap.reloadInputViews()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if kDataManager.monitorId.count <= 0 {
            
            kAlertManager.triggerAlertTypeWarning(warningTitle: "NO OUTPUT",
                                                  warningMessage: "Location data will output when you are monitoring and data is available",
                                                  initialiser: self)
        } else {
            
            loadAgedAllocations()
        }
    }
    
    func loadAgedAllocations() {
        
        monitorYouMap.removeAnnotations(monitorYouMap.annotations)
        
        if kDataManager.monitorId.count > 0 {
            
            // add initial annotations
            for location in kDataManager.monitorYouOutput {
            
                // Available Data
                /*
                [
                 "course": "-1.0",
                 "date": "17/03/2021",
                 "battery": "39.0",
                 "speed": "0.0",
                 "time": "13:18:24",
                 "longitude": "-1.6085460479354947",
                 "output": "1",
                 "id": "",
                 "latitude": "52.27189386945288",
                 "status": "Auto-Update"
                 ]
                */
                
                if let latitude = CLLocationDegrees(location["latitude"]!) {
                    
                    if let longitude = CLLocationDegrees(location["longitude"]!) {
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate.latitude = latitude
                        annotation.coordinate.longitude = longitude
                        annotation.title = location["status"]!
                        monitorYouMap.addAnnotation(annotation)
                        
                        monitorYouMap.showAnnotations(monitorYouMap.annotations, animated: true)
                    }
                }
            }
        }
    }
    
    @objc func addAnnotations(_ notification: NSNotification) {
        
        if let location = notification.object as? [String:String] {
            
            if let latitude = CLLocationDegrees(location["latitude"]!) {
                
                if let longitude = CLLocationDegrees(location["longitude"]!) {
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate.latitude = latitude
                    annotation.coordinate.longitude = longitude
                    annotation.title = location["status"]!
                    monitorYouMap.addAnnotation(annotation)
                    
                    monitorYouMap.showAnnotations(monitorYouMap.annotations, animated: true)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        
        switch annotation.title {
        
        case "Start Session":
            
            //annotationView.pinTintColor = .white
            annotationView.markerTintColor = .white
            
        case "Auto-Update":
            
            annotationView.markerTintColor = .lightGray
            
        case "Im Safe":
            
            annotationView.markerTintColor =  .green
                
        case "Concerned":
            
            annotationView.markerTintColor = .orange
            
        case "End Session":
            
            annotationView.markerTintColor = .green
            
        default:
            annotationView.markerTintColor = .lightGray
        }
        
        return annotationView
    }
    deinit {
        NotificationCenter.default.removeObserver("mapupdate")
    }

}
