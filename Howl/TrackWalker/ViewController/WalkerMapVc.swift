//
//  WalkerMapVc.swift
//  Howl
//
//  Created by apple on 03/10/23.
//
import UIKit
import GoogleMaps
import CoreLocation

class WalkerMapVc: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    private var mapView: GMSMapView!
      private let locationManager = CLLocationManager()
    var walkUpdates = [WalkFetch]()
    var latitude: String!
    var longitude: String!
    private var timer: Timer?
    var markers: [GMSMarker] = []
    

    override func viewDidLoad() {
            super.viewDidLoad()
        let timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(fetchData), userInfo: nil, repeats: true)
        self.timer = timer
        fetchData()
        if let latitudeStr = latitude, let longitudeStr = longitude,
                  let latitude = Double(latitudeStr), let longitude = Double(longitudeStr) {
                   let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15.0)
                   mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
                   mapView.delegate = self
                   view = mapView
               } else {
                   // Initialize Google Maps view
                          let camera = GMSCameraPosition.camera(withLatitude: 0.0, longitude: 0.0, zoom: 15.0)
                          mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
                          mapView.delegate = self
                          view = mapView
               }
          
        }
    
    @objc func fetchData() {
           if kDataManager.walkId != nil || kDataManager.walkId != "" {
               kMonitorMeLocationManager.fetchWalkUpdatesFromFirebase { [weak self] walkUpdates in
                   if let walkUpdates = walkUpdates {
                       self?.walkUpdates = walkUpdates
                       
                       // Remove existing markers before adding new ones
                    //   self?.clearMarkers()
                       
                       for walkUpdate in walkUpdates {
                           if let latitude = walkUpdate.walkLatitude,
                              let longitude = walkUpdate.walkLongitude,
                              let lat = Double(latitude),
                              let long = Double(longitude) {
                               // Create a marker and add it to the map
                               let marker = GMSMarker()
                               marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
                               marker.map = self?.mapView
                               self?.markers.append(marker)
                           }
                       }

                   }
               }
           } else {
               return
           }
       }
    
    func clearMarkers() {
           for marker in markers {
               marker.map = nil
           }
           markers.removeAll()
       }

    
  
}
