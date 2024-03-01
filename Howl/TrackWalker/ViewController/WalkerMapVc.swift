import UIKit
import GoogleMaps
import CoreLocation
import Firebase
import SVProgressHUD

class WalkerMapVc: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    private var mapView: GMSMapView!
    private var timer: Timer?
    private var markers = [GMSMarker]()
    private var apiRequestsEnabled = true
    var walkUpdated = [WalkFetch]()
    var isSessionEnded = false

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = GMSMapView(frame: view.bounds)
        mapView.delegate = self
        view.addSubview(mapView)
        fetchAndUpdateMarkers()
        timer = Timer.scheduledTimer(withTimeInterval: 7.0, repeats: true) { timer in
            if self.apiRequestsEnabled {
                SVProgressHUD.show()
                self.fetchWalkUpdatesFromFirebase { walkUpdates in
                    SVProgressHUD.dismiss()
                    self.walkUpdated = walkUpdates ?? []
                    if let walkUpdates = walkUpdates {
                        for walkUpdate in walkUpdates {
                            if walkUpdate.walkStatus == "End Session" {
                                self.apiRequestsEnabled = false // Disable API requests
                                self.isSessionEnded = true
                            }
                        }
                    }
                    self.addMarkersInBatch(walkUpdates)
                }
            }
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(callFetchAndUpdateMarkers),
                                               name: NSNotification.Name(rawValue: "monitoring"),
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       fetchAndUpdateMarkers()
    }

    func showSessionExpiredAlert() {
        let alertController = UIAlertController(title: "Session Expired", message: "Your Session is expired", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] (action) in
            UserDefaults.standard.removeObject(forKey: "MonitorOutPut")
            self?.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func addMarkersInBatch(_ walkUpdates: [WalkFetch]?) {
        mapView.clear()
        var existingMarkers = Set([GMSMarker]())
        var lastAutoUpdateMarker: GMSMarker?

        markers.removeAll()
//        markers.forEach { $0.map = nil }
        let sortedWalkUpdates = walkUpdates?.sorted { $0.walkTime > $1.walkTime }
        
        for walkUpdate in sortedWalkUpdates ?? [] {
            guard let latitude = Double(walkUpdate.walkLatitude ?? "0.0"),
                  let longitude = Double(walkUpdate.walkLongitude ?? "0.0") else {
                continue
            }

            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
//            marker.map = nil
            marker.userData = UUID().uuidString // Store unique identifier for collision handling

            switch walkUpdate.walkStatus {
            case "Start Session":
                marker.icon = GMSMarker.markerImage(with: .red)
            case "HOWL":
                marker.icon = GMSMarker.markerImage(with: .systemPink)
            case "Auto-Update":
                if lastAutoUpdateMarker == nil {
                    // First "Auto-Update" marker, set to green
                    if !isSessionEnded {
                        marker.icon = GMSMarker.markerImage(with: .green)
                    } else {
                        marker.icon = GMSMarker.markerImage(with: .lightGray)
                    }
                    lastAutoUpdateMarker = marker
                } else {
                    // Existing "Auto-Update" marker, set to light gray
                    marker.icon = GMSMarker.markerImage(with: .lightGray)
                }
            case "Im Safe":
                let markerPin = UIImage(named: "safePin")
                let size = CGSize(width: 55, height: 55) // Specify the size you want
                UIGraphicsBeginImageContext(size)
                markerPin?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()

                marker.icon = resizedImage
            case "Safety Concern":
                let markerPin = UIImage(named: "amberPinFinal")
                let size = CGSize(width: 55, height: 55) // Specify the size you want
                UIGraphicsBeginImageContext(size)
                markerPin?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()

                marker.icon = resizedImage
            case "Illness/Injury":
                let markerPin = UIImage(named: "amberPinFinal")
                let size = CGSize(width: 55, height: 55) // Specify the size you want
                UIGraphicsBeginImageContext(size)
                markerPin?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()

                marker.icon = resizedImage
            case "End Session":
                marker.icon = GMSMarker.markerImage(with: .lightGray)
            default:
                marker.icon = GMSMarker.markerImage(with: .gray)
            }
            handleMarkerOverlap(marker: marker)
            if let existingMarker = markers.first(where: { $0.position == marker.position }) {
                        existingMarker.icon = marker.icon
                        existingMarker.map = mapView
                    } else {
                        marker.map = mapView
                        markers.append(marker)
                    }
        }

        // Set all markers on the map
        markers.forEach { $0.map = mapView }

        markers.append(contentsOf: existingMarkers)

        if let lastMarker = markers.last {
            // Set the camera position to the last added marker
            let cameraUpdate = GMSCameraUpdate.setCamera(GMSCameraPosition.camera(
                withTarget: lastMarker.position,
                zoom: 20.0
            ))
            mapView.animate(with: cameraUpdate)
        }
    }
    
    func handleMarkerOverlap(marker: GMSMarker){
        // 1. Slightly offset new marker (less preferred for dense data):
        let offset = 0.00001 // Adjust as needed
        var newLatitude = marker.position.latitude
        var newLongitude = marker.position.longitude

        // Check against all markers
        for existingMarker in markers {
            while abs(existingMarker.position.latitude - newLatitude) < 0.000001 &&
                  abs(existingMarker.position.longitude - newLongitude) < 0.000001 {
                // Randomize the direction of the offset
                let latOffset = Double.random(in: -1...1) * offset
                let lonOffset = Double.random(in: -1...1) * offset
                newLatitude += latOffset
                newLongitude += lonOffset
            }
        }
        marker.position = CLLocationCoordinate2D(latitude: newLatitude, longitude: newLongitude)
    }


    func fetchWalkUpdatesFromFirebase(completion: @escaping ([WalkFetch]?) -> Void) {
        let databaseReference = Database.database().reference()
        let monitorMeID = UserDefaults.standard.string(forKey: "MonitorOutPut") ?? ""
        print("monitorIds", monitorMeID)
        databaseReference.child(monitorMeID ?? "").observeSingleEvent(of: .value) { snapshot, _ in
            guard let dataDict = snapshot.value as? [String: [String: Any]] else {
                completion(nil)
                return
            }
            var walkUpdates = [WalkFetch]()
            for (_, value) in dataDict {
                if let walkID = value["randomId"] as? String,
                   let walkLongitude = value["lon"] as? String,
                   let walkLatitude = value["lat"] as? String,
                   let walkSpeed = value["speed"] as? String,
                   let walkCourse = value["course"] as? String,
                   let walkDate = value["date"] as? String,
                   let walkTime = value["time"] as? String,
                   let walkBattery = value["battery"] as? String,
                   let walkStatus = value["state"] as? String,
                   let walkW3WWords = value["w3w"] as? String,
                   let walkW3WURL = value["w3wurl"] as? String,
                   let flag = value["flag"] as? String,
                   let device = value["device"] as? String {
                    let walkUpdate = WalkFetch(
                        walkID: walkID,
                        walkLatitude: walkLatitude, walkLongitude: walkLongitude,
                        walkSpeed: walkSpeed,
                        walkCourse: walkCourse,
                        walkDate: walkDate,
                        walkTime: walkTime,
                        walkBattery: walkBattery,
                        walkStatus: walkStatus,
                        walkW3WWords: walkW3WWords,
                        walkW3WURL: walkW3WURL, flag: flag,
                        device: device
                    )
                    walkUpdates.append(walkUpdate)
                }
            }
            completion(walkUpdates)
        }
    }
    
    private func fetchAndUpdateMarkers() {
            SVProgressHUD.show()
            fetchWalkUpdatesFromFirebase { walkUpdates in
                SVProgressHUD.dismiss()
                self.addMarkersInBatch(walkUpdates)
            }
        }
    
    @objc func callFetchAndUpdateMarkers(){
        for marker in self.markers {
            marker.map = nil
        }
        self.markers.removeAll()
        self.apiRequestsEnabled = true
        self.isSessionEnded = false
    }
}
extension CLLocationCoordinate2D: Equatable {
    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
