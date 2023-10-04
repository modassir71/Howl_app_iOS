//
//  WalkerMapVc.swift
//  Howl
//
//  Created by apple on 03/10/23.
//
import UIKit
import GoogleMaps
import CoreLocation

class WalkerMapVc: UIViewController, CLLocationManagerDelegate {
    
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
        }


      // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last {
                // Update the map's camera to the current location
                let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                      longitude: location.coordinate.longitude,
                                                      zoom: 15.0)
                mapView.animate(to: camera)
            }
        locationManager.startUpdatingLocation()
        }

      func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
          print("Location Manager Error: \(error.localizedDescription)")
      }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedWhenInUse {
                locationManager.startUpdatingLocation()
            }
        }
}
