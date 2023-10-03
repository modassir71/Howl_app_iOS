//
//  WalkerMapVc.swift
//  Howl
//
//  Created by apple on 03/10/23.
//
import UIKit
import GoogleMaps
import CoreLocation

class WalkerMapVc: UIViewController {
    
  //  @IBOutlet weak var mapView: GMSMapView!
    var mapView: GMSMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize Google Maps
        let camera = GMSCameraPosition.camera(withLatitude: 37.7749, longitude: -122.4194, zoom: 12.0)
        mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        mapView.isMyLocationEnabled = true
        self.view.addSubview(mapView)
        
        // Create GPS button
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        
        // Location manager setup
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @objc func showCurrentLocation() {
        locationManager.requestLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension WalkerMapVc: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 12.0)
            mapView.animate(to: camera)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
}
