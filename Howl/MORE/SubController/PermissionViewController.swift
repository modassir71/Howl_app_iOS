//
//  PermissionViewController.swift
//  Howl
//
//  Created by apple on 08/09/23.
//

import UIKit
import AVFoundation
import CoreLocation
import Photos

class PermissionViewController: UIViewController {
//MARK: - Outlet
    
    @IBOutlet weak var titleTxtView: UITextView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var setPermissionBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var microphoneBtn: UIButton!
    @IBOutlet weak var grantAllPermissionBtn: UIButton!
    
//    MARK: - Variable
    var enableBtnColor = UIColor(displayP3Red: 142.0/255.0, green: 209.0/255.0, blue: 181.0/255.0, alpha: 1.0)
    let locationManager = CLLocationManager()
    var fromFirstLoadToPermissions: Bool! = false
    var fromInfoToPermissions: Bool! = false
    var iscomeFromInstruction: Bool?
//    MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _setUpUI()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getSavedColor(key: "microphoneColor", color: &microphoneBtn.backgroundColor!)
        getSavedColor(key: "cameraBackgroudColor", color: &cameraBtn.backgroundColor!)
        getSavedColor(key: "LocationBackgroundColor", color: &locationBtn.backgroundColor!)
        getSavedColor(key: "notificationBackgroundColor", color: &notificationBtn.backgroundColor!)
        getSavedColor(key: "allPermissionEnable", color: &grantAllPermissionBtn.backgroundColor!)
        getSavedColor(key: "photoColor", color: &grantAllPermissionBtn.backgroundColor!)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
        let screenHeight = UIScreen.main.bounds.size.height
        let isiPhoneSE = screenHeight <= 667
        if isiPhoneSE {
           self.tabBarController?.tabBar.frame.size.height = 47
        }else{
            self.tabBarController?.tabBar.frame.size.height = 100
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let hasAppLaunchedBefore = UserDefaults.standard.bool(forKey: StringConstant.hasAppLaunchedBeforeKey)
        if !hasAppLaunchedBefore == true {
            let alert = UIAlertController(title: DogConstantString.setPermisionTitle, message: DogConstantString.permissionMsg, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            }
            alert.addAction(okAction)
            UserDefaults.standard.set(true, forKey: StringConstant.hasAppLaunchedBeforeKey)
            self.present(alert, animated: true, completion: nil)
        }
        if iscomeFromInstruction == true{
            let alert = UIAlertController(title: DogConstantString.setPermisionTitle, message: DogConstantString.permissionMsgAlert, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
 
//   MARK: - Retrive button bg color
    func getSavedColor(key: String, color: inout UIColor){
        if let colorData = UserDefaults.standard.data(forKey: key),
           let loadedColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData) {
            color = loadedColor
        }
    }
//    MARK: - Add shadow and corner Radius
    func addShadow(to Button: UIButton){
        Button.layer.shadowColor = UIColor.gray.cgColor
        Button.layer.shadowOpacity = 0.2
        Button.layer.shadowOffset = CGSize(width: 0, height: 5)
        Button.layer.shadowRadius = 2
        Button.layer.cornerRadius = 15
    }
//    MARK: - SetUp Ui
    func _setUpUI(){
        navigationView.layer.shadowColor = UIColor.black.cgColor
        navigationView.layer.shadowOpacity = 0.2
        navigationView.layer.shadowOffset = CGSize(width: 0, height: 5)
        navigationView.layer.shadowRadius = 2
        titleTxtView.isEditable = false
        setPermissionBtn.backgroundColor = enableBtnColor
        addShadow(to: microphoneBtn)
        addShadow(to: cameraBtn)
        addShadow(to: locationBtn)
        addShadow(to: notificationBtn)
        addShadow(to: setPermissionBtn)
        addShadow(to: grantAllPermissionBtn)
    }

//    MARK: - Button Action
    
    @IBAction func allPermissionBtnPress(_ sender: UIButton) {
        PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                  
                    DispatchQueue.main.async {
                        self.grantAllPermissionBtn.backgroundColor = self.enableBtnColor
                        self.saveColor(color: self.grantAllPermissionBtn.backgroundColor ?? UIColor(), key: "photoColor")
                        // Your code to save the image here
                    }
                case .denied, .restricted:
                    // User denied or restricted access, show an alert or guide the user on how to enable it in settings.
                    DispatchQueue.main.async {
                        // Show an alert or guide the user to settings
                    }
                case .notDetermined:
                    // User hasn't made a decision yet, do nothing.
                    break
                case .limited:
                    break
                @unknown default:
                    break
                }
            }
    }
    
    @IBAction func microphoneBtnPress(_ sender: UIButton) {
        requestMicrophonePermission { granted in
                if granted {
                    // Microphone permission granted
                    // Perform actions for granted permission
                    print("Microphone permission granted")
                } else {
                    // Microphone permission denied
                    // Handle the denial or take appropriate action
                    print("Microphone permission denied")
                }
            }
    }
    
    @IBAction func cameraBtnPress(_ sender: UIButton) {
        setCameraPermission { granted in
                if granted {
                    // Camera permission granted
                    // Perform actions for granted permission
                    print("Camera permission granted")
                } else {
                    // Camera permission denied
                    // Handle the denial or take appropriate action
                    print("Camera permission denied")
                }
            }
    }
    
    @IBAction func locationBtnPress(_ sender: UIButton) {
        setLocationPermission { granted in
                if granted {
                    // Location permission granted
                    // Perform actions for granted permission
                    print("Location permission granted")
                } else {
                    // Location permission denied
                    // Handle the denial or take appropriate action
                    print("Location permission denied")
                }
            }
        }
    
    
    @IBAction func notificationsBtnPress(_ sender: UIButton) {
        setNotificationPermission { granted in
               if granted {
                   // Notification permission granted
                   // Perform actions for granted permission
                   print("Notification permission granted")
               } else {
                   // Notification permission denied
                   // Handle the denial or take appropriate action
                   print("Notification permission denied")
               }
           }
    }
    
    
    @IBAction func setPermissionBtnPress(_ sender: UIButton) {
        if locationBtn.backgroundColor == enableBtnColor || microphoneBtn.backgroundColor == enableBtnColor || cameraBtn.backgroundColor == enableBtnColor || notificationBtn.backgroundColor == enableBtnColor || grantAllPermissionBtn.backgroundColor == enableBtnColor {
            let alert = UIAlertController(title: StringConstant.congrulationTitle, message: StringConstant.setupMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                alert.dismiss(animated: true) {
                    self.confirmedSetup()
                }
            }))
            self.present(alert, animated: true)
        }else{
            let alert = UIAlertController(title: StringConstant.permissionTitle,
                                          message: StringConstant.permissionMsg,
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {_ in }))
            
            alert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: {_ in
                
                alert.dismiss(animated: true, completion: {
                    
                    self.confirmedSetup()
                    
                })
            }))
            
            self.present(alert, animated: true)
        }

    }
//    MARK: - Save button background color
    func saveColor(color: UIColor, key: String){
        if let colorData = try? NSKeyedArchiver.archivedData(withRootObject: color , requiringSecureCoding: false) {
            UserDefaults.standard.set(colorData, forKey: key)
        }
    }
//    MARK: - Microphone access Method
    func requestMicrophonePermission(completion: @escaping (Bool) -> Void) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        
        switch cameraAuthorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .audio) { accessGranted in
                DispatchQueue.main.async {
                    if accessGranted {
                        self.microphoneBtn.backgroundColor = self.enableBtnColor
                        self.saveColor(color: self.microphoneBtn.backgroundColor ?? UIColor(), key: "microphoneColor")
                    }
                    completion(accessGranted)
                }
            }
            
        case .authorized:
            // Microphone permission already granted
            DispatchQueue.main.async {
                self.microphoneBtn.backgroundColor = self.enableBtnColor
                self.saveColor(color: self.microphoneBtn.backgroundColor ?? UIColor(), key: "microphoneColor")
            }
            completion(true)
            
        case .restricted, .denied:
            let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
            
            let alert = UIAlertController(title: StringConstant.microphoneAccessTitle,
                                          message: StringConstant.microphoneAccessMsg,
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default) { _ in
                completion(false)
            })
            alert.addAction(UIAlertAction(title: "Allow", style: .default) { _ in
                UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
            })
            
            present(alert, animated: true, completion: nil)
            completion(false)
            
        @unknown default:
            completion(false)
        }
    }

//    MARK: - Camera Permission Method
    func setCameraPermission(completion: @escaping (Bool) -> Void) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { accessGranted in
                DispatchQueue.main.async {
                    if accessGranted {
                        self.cameraBtn.backgroundColor = self.enableBtnColor
                        self.saveColor(color: self.cameraBtn.backgroundColor ?? UIColor(), key: "cameraBackgroudColor")
                    }
                    completion(accessGranted)
                }
            }
            
        case .authorized:
            // Camera permission already granted
            DispatchQueue.main.async {
                self.cameraBtn.backgroundColor = self.enableBtnColor
                self.saveColor(color: self.cameraBtn.backgroundColor ?? UIColor(), key: "cameraBackgroudColor")
            }
            completion(true)
            
        case .restricted, .denied:
            // Camera permission denied
            DispatchQueue.main.async {
                completion(false)
            }
            
            let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
            let alert = UIAlertController(title: StringConstant.cameraAccessTitle,
                                          message: StringConstant.cameraAccessMsg,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default))
            alert.addAction(UIAlertAction(title: "Allow", style: .default) { _ in
                UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
            })
            present(alert, animated: true, completion: nil)
            
        @unknown default:
            completion(false)
        }
    }

    
//    MARK: - Notification Permission Method
    func setNotificationPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                DispatchQueue.main.async {
                    self.notificationBtn.backgroundColor = self.enableBtnColor
                    self.saveColor(color: self.notificationBtn.backgroundColor ?? UIColor(), key: "notificationBackgroundColor")
                }
                completion(true)
            } else if let error = error {
                let alert = UIAlertController(title: StringConstant.notificationAccessTitle,
                                              message: StringConstant.notificationAccessMsg,
                                              preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                completion(false)
            }
        }
    }

    
//    MARK: - Location Permission Method
    func setLocationPermission(completion: @escaping (Bool) -> Void) {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            // Location permission already granted
            locationBtn.backgroundColor = enableBtnColor
            self.saveColor(color: self.locationBtn.backgroundColor ?? UIColor(), key: "LocationBackgroundColor")
            completion(true)

        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()

        case .denied, .restricted:
            locationManager.requestWhenInUseAuthorization()
            completion(false)

        default:
            locationManager.requestWhenInUseAuthorization()
            completion(false)
        }
    }

    
    func confirmedSetup() {
        
        if fromFirstLoadToPermissions == true {
            
            // now head back to the load page
            fromFirstLoadToPermissions = false
            UIApplication.shared.windows.first!.rootViewController?.dismiss(animated: true, completion: {})
        } else if fromInfoToPermissions == true {
            
            // Just go back to the info page
            fromInfoToPermissions = false
            self.dismiss(animated: true, completion: {})
        } else {
            
            // Initial setup so follow completion process
            UserDefaults.standard.setValue(true, forKey: "firstloadcompleted")
            if let navigationController = self.navigationController {
                navigationController.popToRootViewController(animated: true)
            }
        }
    }

    
    @IBAction func backBtnPress(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
