//
//  PermissionViewController.swift
//  Howl
//
//  Created by apple on 08/09/23.
//

import UIKit
import AVFoundation
import CoreLocation

class PermissionViewController: UIViewController {
//MARK: - Outlet
    
    @IBOutlet weak var titleTxtView: UITextView!
    @IBOutlet weak var navigationView: UIView!
    
    @IBOutlet weak var setPermissionBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var microphoneBtn: UIButton!
    
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
        
    }

//    MARK: - Button Action
    @IBAction func microphoneBtnPress(_ sender: UIButton) {
        requestMicrophonePermission()
    }
    
    @IBAction func cameraBtnPress(_ sender: UIButton) {
        setCameraPermission()
    }
    
    @IBAction func locationBtnPress(_ sender: UIButton) {
        setLocationPermission()
    }
    
    
    @IBAction func notificationsBtnPress(_ sender: UIButton) {
        setNotificationPermission()
    }
    
    
    @IBAction func setPermissionBtnPress(_ sender: UIButton) {
        if locationBtn.backgroundColor == enableBtnColor || microphoneBtn.backgroundColor == enableBtnColor || cameraBtn.backgroundColor == enableBtnColor || notificationBtn.backgroundColor == enableBtnColor {
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
   func requestMicrophonePermission() {
       let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .audio)
       
       switch cameraAuthorizationStatus {
       
       case .notDetermined:
           
           AVCaptureDevice.requestAccess(for: .audio, completionHandler: {accessGranted in
               if accessGranted == true{
                   DispatchQueue.main.async {
                       self.microphoneBtn.backgroundColor = self.enableBtnColor
                       self.saveColor(color: self.microphoneBtn.backgroundColor ?? UIColor(), key: "microphoneColor")
                   }
               }else{
                   return
               }
              
           })
           
       case .authorized:
           microphoneBtn.backgroundColor = enableBtnColor
           saveColor(color: microphoneBtn.backgroundColor ?? UIColor(), key: "microphoneColor")
           
       case .restricted, .denied:
           
           let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
           
           
           let alert = UIAlertController(title: StringConstant.microphoneAccessTitle,
                                         message: StringConstant.microphoneAccessMsg,
                                         preferredStyle: .alert)
           
           alert.addAction(UIAlertAction(title: "Cancel", style: .default))
           alert.addAction(UIAlertAction(title: "Allow", style: .default, handler: {_ in
               
               UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
           }))
           
           
       @unknown default:
           ()
       }
    }
//    MARK: - Camera Permission Method
    func setCameraPermission(){
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
        
        case .notDetermined:
            
            AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
                if accessGranted == true{
                    DispatchQueue.main.async {
                        self.cameraBtn.backgroundColor = self.enableBtnColor
                        self.saveColor(color: self.microphoneBtn.backgroundColor ?? UIColor(), key: "cameraBackgroudColor")
                    }
                }else{
                    return
                }
            })
            
        case .authorized:
            
            cameraBtn.backgroundColor = enableBtnColor
            saveColor(color: cameraBtn.backgroundColor ?? UIColor(), key: "cameraBackgroudColor")
            
        case .restricted, .denied:
            
            let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
            
            
            let alert = UIAlertController(title: StringConstant.cameraAccessTitle,
                                          message: StringConstant.cameraAccessMsg,
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default))
            alert.addAction(UIAlertAction(title: "Allow", style: .default, handler: {_ in
                
                UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
            }))
            
            
        @unknown default:
            ()
        }
    }
    
//    MARK: - Notification Permission Method
    func setNotificationPermission(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            
            if success {
                
                DispatchQueue.main.async {
                    self.notificationBtn.backgroundColor = self.enableBtnColor
                    self.saveColor(color: self.notificationBtn.backgroundColor ?? UIColor(), key: "notificationBackgroundColor")
                }
                
            } else if let error = error {
                let alert = UIAlertController(title: StringConstant.notificationAccessTitle,
                                              message: StringConstant.notificationAccessMsg,
                                              preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
            }
        }

    }
    
//    MARK: - Location Permission Method
    func setLocationPermission(){
        switch locationManager.authorizationStatus {
        
        case .authorizedAlways:
            
            locationBtn.backgroundColor = enableBtnColor
            self.saveColor(color: self.locationBtn.backgroundColor ?? UIColor(), key: "LocationBackgroundColor")
            
            
        case .authorizedWhenInUse:
            
            locationManager.requestAlwaysAuthorization()
            locationBtn.backgroundColor = enableBtnColor
            self.saveColor(color: self.locationBtn.backgroundColor ?? UIColor(), key: "LocationBackgroundColor")
            
            
        case .notDetermined:
            
            locationManager.requestWhenInUseAuthorization()
            
        case .denied:
            
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted:
            
            locationManager.requestWhenInUseAuthorization()
            
        default:
            
            locationManager.requestWhenInUseAuthorization()
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
