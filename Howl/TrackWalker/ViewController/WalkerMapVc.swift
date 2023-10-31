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
    
    

    override func viewDidLoad() {
            super.viewDidLoad()
            // Initialize Google Maps
            mapView = GMSMapView(frame: .zero)
            mapView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(mapView)
            // Location manager setup
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            mapView.settings.myLocationButton = true
            mapView.isMyLocationEnabled = true
            locationManager.startUpdatingLocation()
            // Add constraints to fill the entire view
            NSLayoutConstraint.activate([
                mapView.topAnchor.constraint(equalTo: view.topAnchor),
                mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(addAnnotations(_:)),
                                               name: NSNotification.Name(rawValue: "mapupdate"),
                                               object: nil)
        setupMapView()
        }
    
    override func viewDidAppear(_ animated: Bool) {
     //   loadAgedAllocations()
    }

    
    @objc func addAnnotations(_ notification: NSNotification) {
            if let location = notification.object as? [String: String] {
                if let latitude = CLLocationDegrees(location["latitude"]!),
                   let longitude = CLLocationDegrees(location["longitude"]!) {
                    let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    let marker = GMSMarker(position: position)
                    marker.title = location["status"]!
                    
                    // Customize the marker icon based on your requirements
                    marker.icon = GMSMarker.markerImage(with: .blue)
                    
                    marker.map = mapView
                }
            }
        }
    
    func setupMapView() {
            let camera = GMSCameraPosition.camera(withLatitude: 52.27189386945288, longitude: -1.6085460479354947, zoom: 15.0)
            mapView = GMSMapView.map(withFrame: .zero, camera: camera)
            mapView.delegate = self
            view = mapView

            // Add a background layer for visual effect
        //    interactionLayer = prepareViewBackground(initialiser: self)

            // Customize your map as needed, e.g., set map settings, markers, etc.
            loadAgedAllocations()
        }

        func loadAgedAllocations() {
            mapView.clear() // Clear existing markers

            if kDataManager.monitorYouOutput.count > 0 {
                for location in kDataManager.monitorYouOutput {
                    if let latitude = CLLocationDegrees(location["latitude"]!),
                       let longitude = CLLocationDegrees(location["longitude"]!) {
                        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        let marker = GMSMarker(position: position)
                        marker.title = location["status"]!
                        
                        // Customize the marker icon based on your requirements
                        marker.icon = GMSMarker.markerImage(with: .green)
                        
                        marker.map = mapView
                    }
                }
            }
        }

      // MARK: - CLLocationManagerDelegate

//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//            if let location = locations.last {
//                // Update the map's camera to the current location
//                let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
//                                                      longitude: location.coordinate.longitude,
//                                                      zoom: 15.0)
//                mapView.animate(to: camera)
//            }
//        locationManager.stopUpdatingLocation()
//        }
//
//      func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//          print("Location Manager Error: \(error.localizedDescription)")
//      }
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//            if status == .authorizedWhenInUse {
//                locationManager.startUpdatingLocation()
//            }
//        }
    deinit {
            NotificationCenter.default.removeObserver("mapupdate")
        }
}
