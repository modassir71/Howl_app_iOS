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
                    self.addMarkersInBatch(walkUpdates)
                    self.walkUpdated = walkUpdates ?? []
                    if let walkUpdates = walkUpdates {
                        for walkUpdate in walkUpdates {
                            if walkUpdate.walkStatus == "End Session" {
                                self.apiRequestsEnabled = false // Disable API requests
                            }
                        }
                    }
                }
            }
        }
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
        var newMarkers = [GMSMarker]()
        var existingMarkers = [GMSMarker]()
        var isFirstAutoUpdateMarker = true

        for walkUpdate in walkUpdates ?? [] {
            guard let latitude = Double(walkUpdate.walkLatitude ?? "0.0"),
                  let longitude = Double(walkUpdate.walkLongitude ?? "0.0") else {
                continue
            }

            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))

            switch walkUpdate.walkStatus {
            case "Start Session":
                marker.icon = GMSMarker.markerImage(with: .red)
            case "HOWL":
                marker.icon = GMSMarker.markerImage(with: .systemPink)
            case "Auto-Update":
                if isFirstAutoUpdateMarker {
                    // First "Auto-Update" marker, set to green
                    marker.icon = GMSMarker.markerImage(with: .green)
                    isFirstAutoUpdateMarker = false
                } else {
                    // Existing "Auto-Update" marker, set to light gray
                    marker.icon = GMSMarker.markerImage(with: .lightGray)
                }
            case "Im Safe":
                marker.icon = GMSMarker.markerImage(with: .yellow)
            case "Safety Concern":
                marker.icon = GMSMarker.markerImage(with: .orange)
            case "Illness/Injury":
                marker.icon = GMSMarker.markerImage(with: .yellow)
            case "End Session":
                marker.icon = GMSMarker.markerImage(with: .lightGray)
            default:
                marker.icon = GMSMarker.markerImage(with: .gray)
            }

            if markers.contains(where: { $0.position == marker.position }) {
                existingMarkers.append(marker)
            } else {
                newMarkers.append(marker)
            }
        }

        // Set all markers on the map
        markers.forEach { $0.map = mapView }

        markers.append(contentsOf: newMarkers)
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
}
extension CLLocationCoordinate2D: Equatable {
    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
