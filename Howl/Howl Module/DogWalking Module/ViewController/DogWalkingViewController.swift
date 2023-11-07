//
//  DogWalkingViewController.swift
//  Howl
//
//  Created by apple on 20/08/23.
//

import UIKit
import Lottie
import CoreLocation
import Firebase
import MessageUI

class DogWalkingViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
//MARK: - Outlet
    
    @IBOutlet weak var tapLabel: UILabel!
    @IBOutlet weak var concernBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var concernBtnTop: NSLayoutConstraint!
    @IBOutlet weak var redBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var redBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var concernBtn: UIButton!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var redBtn: UIButton!
    @IBOutlet weak var dogAnimationView: UIImageView!
    @IBOutlet weak var streetImg: UIImageView!
    @IBOutlet weak var dogStopImg: UIImageView!
    @IBOutlet weak var dogAnimateView: UIImageView!
    @IBOutlet weak var swipeSlider: DSSlider!
    @IBOutlet weak var startWalkBtn: TGFlingActionButton!
    @IBOutlet weak var backAction: UIButton!
    @IBOutlet weak var dogOwnerName: UILabel!
    @IBOutlet weak var dogName: UILabel!
    @IBOutlet weak var titleImg: UIImageView!
    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var crossBtn: UIButton!
    
    //MARK: - Variable
    var locationEnabled: Bool?
      var dogNameLbl = String()
      var dogOwnerNameLbl = String()
      var dogImgItem: Data?
      private let locationManager = CLLocationManager()
    var tapsToHOWL: Int! = 0
    var tapTimer: Timer!
    var lat: String?
    var long: String?
    
      //MARK: - Life Cycle
      
      override func viewDidLoad() {
          super.viewDidLoad()
          
//          locationManager.delegate = self
//          locationManager.requestWhenInUseAuthorization()
          setUi()
          DispatchQueue.main.async {
              self._setupSliderView()
          }
          locationManager.delegate = self
          locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
          locationManager.requestWhenInUseAuthorization()
          locationManager.startUpdatingLocation()
      }
      
      override func viewWillAppear(_ animated: Bool) {
          self.navigationController?.setNavigationBarHidden(true, animated: animated)
          self.tabBarController?.tabBar.isHidden = true
//          DispatchQueue.main.async {
//              self._setupSliderView()
//          }
      }
      
      //MARK: - SetUi
      func setUi(){
          navigationView.layer.shadowColor = UIColor.black.cgColor
          navigationView.layer.shadowOpacity = 0.2
          navigationView.layer.shadowOffset = CGSize(width: 0, height: 5)
          navigationView.layer.shadowRadius = 2
          dogImage.layer.borderWidth = 1.0
          dogImage.layer.borderColor = UIColor(displayP3Red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1).cgColor
          dogImage.layer.cornerRadius = dogImage.frame.width/2
          dogImage.clipsToBounds = true
          dogImage.contentMode = .scaleAspectFill
          dogName.text = dogNameLbl.capitalizeFirstLetter()
          if let imageData = dogImgItem {
              let image = UIImage(data: imageData)
              dogImage.image = image
          }
          dogImage.contentMode = .scaleAspectFit
          streetImg.isHidden = true
          redBtn.layer.cornerRadius = redBtn.frame.width/2
          redBtn.clipsToBounds = true
          shadowView.layer.cornerRadius = shadowView.frame.width/2
          shadowView.clipsToBounds = true
          shadowView.isHidden = true
          redBtn.isHidden = true
          concernBtn.layer.cornerRadius = 20.0
          concernBtn.clipsToBounds = true
          concernBtn.isHidden = true
          concernBtn.layer.borderColor = UIColor(displayP3Red: 31/255, green: 31/255, blue: 31/255, alpha: 1.0).cgColor
          concernBtn.layer.borderWidth = 2.0
          concernBtn.setTitle(DogConstantString.raiseConcern, for: .normal)
          concernBtn.setTitleColor(.black, for: .normal)
          concernBtn.titleLabel?.font = .appFont(.AileronBold, size: 20)
          dogName.font = .appFont(.AileronBold, size: 20.0)
          if isiPhoneSE(){
              concernBtnTop.constant = 10
              concernBtnHeight.constant = 44
              
          }else{
              concernBtnTop.constant = 40
              concernBtnHeight.constant = 54
              
          }
          
      }
    
    func startTapTimer() {
        
        if tapTimer == nil || !(tapTimer?.isValid)! {
            
            tapTimer = Timer.scheduledTimer(timeInterval: 10,
                                         target: self,
                                         selector: #selector(resetHOWLTap),
                                         userInfo: nil,
                                         repeats: false)
        }
    }
    
    @objc func resetHOWLTap() {
        
        if tapTimer != nil && (tapTimer?.isValid)! {
            
            tapTimer.invalidate()
            tapTimer = nil
            tapsToHOWL = 0
            tapLabel.text = "Tap 3 Times To"
           // howlForHelpImageView.image = UIImage(named: "howl_tap_1.jpg")
        }
    }
      //MARK: - Action
      
      @IBAction func crossBtnPress(_ sender: UIButton) {
          self.navigationController?.popViewController(animated: true)
      }
      
      
      @IBAction func backPress(_ sender: UIButton) {
          self.navigationController?.popViewController(animated: true)
      }
      //MARK: - Setup Swipe Button
      private func _setupSliderView() {
          let sliderButtonColor = UIColor(red: 255/255, green: 36/255, blue: 109/255, alpha: 1)
          let sliderDragedColor = UIColor(red: 31/255, green: 29/255, blue: 23/255, alpha: 1)
          swipeSlider.layer.cornerRadius = 10.0
          swipeSlider.clipsToBounds = true
          swipeSlider.comeFromStartRide = ""
          swipeSlider.isDoubleSideEnabled = true
          swipeSlider.isImageViewRotating = true
          swipeSlider.isTextChangeAnimating = true
          swipeSlider.isDebugPrintEnabled = false
          swipeSlider.isShowSliderText = true
          swipeSlider.isEnabled = true
          swipeSlider.sliderAnimationVelocity = 0.2
          swipeSlider.sliderViewTopDistance = 0.0
          swipeSlider.sliderImageViewTopDistance = 5
         // UserDefaults.standard.set(swipeSlider.sliderPosition.rawValue, forKey: "sliderPosition")
          swipeSlider.sliderImageViewStartingDistance = 5
          swipeSlider.sliderTextLabelLeadingDistance = 0
          swipeSlider.sliderCornerRadius = swipeSlider.frame.height / 2
          swipeSlider.sliderBackgroundColor = sliderButtonColor
          swipeSlider.sliderBackgroundViewTextColor = .white
          swipeSlider.sliderDraggedViewTextColor = .white
          swipeSlider.sliderDraggedViewBackgroundColor = sliderDragedColor
          if swipeSlider.sliderPosition == .left{
              swipeSlider.sliderImageViewBackgroundColor = sliderButtonColor
          }
          if swipeSlider.sliderPosition == .rigth{
              swipeSlider.sliderImageViewBackgroundColor = sliderDragedColor
          }
          swipeSlider.delegate = self
          swipeSlider.sliderTextFont = .appFont(.AileronBold, size: 25)
          swipeSlider.sliderBackgroundViewTextLabel.text = DogConstantString.startWalk
          swipeSlider.sliderDraggedViewTextLabel.text = DogConstantString.stopWalk
          if let positionValue = UserDefaults.standard.value(forKey: "SliderPosition") as? Int {
              var position: DSSliderPosition
              if positionValue == 0 {
                  position = .left
                  print("1")
                    
                  swipeSlider.slideToEndLft()
                  
              } else {
                  position = .rigth
                  print("2")
                  dogStopImg.isHidden = true
                  streetImg.isHidden = false
                  swipeSlider.slideToEnd()
                  DispatchQueue.main.async {
                      self.animationView()
                      self.dogAnimationView.isHidden = false
                      self.tabBarController?.tabBar.isHidden = true
                      self.shadowView.isHidden = false
                      self.redBtn.isHidden = false
                      self.concernBtn.isHidden = false
                  }
                  

              }
              print("Position: \(position)")
          } else {
              // Handle the case when the position is not found in UserDefaults
              print("Position not found")
          }

      }
      
      //MARK: - Button Action
      
      @IBAction func concernBtnPress(_ sender: UIButton) {
          let storyboard = AppStoryboard.Main.instance
          let concernVc = storyboard.instantiateViewController(withIdentifier: "ConcernViewController") as! ConcernViewController
          //  concernVc.modalPresentationStyle = .fullScreen
          self.navigationController?.present(concernVc, animated: true)
      }
      
    
    @IBAction func tap3TimesBtnPress(_ sender: UIButton) {
        if kDataManager.walkId != nil{
            switch tapsToHOWL {
                
            case 0:
                
                tapsToHOWL += 1
                startTapTimer()
                tapLabel.text = "Tap 2 Times To"
                
            case 1:
                tapsToHOWL += 1
                tapLabel.text = "Tap 1 Times To"
                
            case 2:
                let customViewController = RecordViewController()
                customViewController.executeCodeBlock = { [weak self] in
                    self?.resetHOWLTap()
                    DispatchQueue.main.async {
                        for subview in self!.dogAnimationView.subviews {
                            subview.removeFromSuperview()
                        }
                        self!.dogAnimationView.isHidden = true
                        self!.dogStopImg.isHidden = false
                        self!.streetImg.isHidden = true
                        self!.tabBarController?.tabBar.isHidden = false
                        self!.shadowView.isHidden = true
                        self!.redBtn.isHidden = true
                        self!.concernBtn.isHidden = true
                        
                    }
                    print("Slider position",self?.swipeSlider.sliderPosition)
                    self?.swipeSlider.sliderPosition = .left
                    self?.swipeSlider.slideToEndLft()
                    print("Slider position",self?.swipeSlider.sliderPosition)
                }
                
                kMonitorMeLocationManager.forceUpdateToMonitorMeServerWithState(state: "HOWL", latitude: lat ?? "", longitude: long ?? "")
                UserDefaults.standard.set(0, forKey: "SliderPosition")
                navigationController?.pushViewController(customViewController, animated: true)
                
                resetHOWLTap()
                
            default:
                ()
            }
        }else{

        }
        
    }
    
      
      
  }
  //MARK: - Swipe Button
  extension DogWalkingViewController: DSSliderDelegate{
      func sliderDidFinishSliding(_ slider: DSSlider, at position: DSSliderPosition) {
          var positionValue: Int = 0
          if position == .left{
             print("position1", position)
              AlertManager.sharedInstance.triggerAlertTypeWarningWithAction(warningTitle: "Stop Walking", warningMessage: "Do You Want to Stop Walking", initialiser: self, okClosure: {
                  DispatchQueue.main.async {
                      for subview in self.dogAnimationView.subviews {
                          subview.removeFromSuperview()
                      }
                      self.dogAnimationView.isHidden = true
                  }
                 
                  UserDefaults.standard.removeObject(forKey: "DogMonitorId")
                  self.dogStopImg.isHidden = false
                  self.streetImg.isHidden = true
                  self.tabBarController?.tabBar.isHidden = false
                  self.shadowView.isHidden = true
                  self.redBtn.isHidden = true
                  self.concernBtn.isHidden = true
                  print("position2", position)
                  kMonitorMeLocationManager.stopMonitoringMe()
                  DogDataManager.shared.walkMonitor = ""
              }, cancelClosure: {
                  print("position3", position)
                  self.swipeSlider.slideToEnd()
              })
             // UserDefaults.standard.set(position, forKey: "SliderPosition")
              positionValue = 0
          }else{
              print("position4", position)
              if AddPeopleDataManager.sharedInstance.people.isEmpty{
                  let alert = UIAlertController(title: DogConstantString.noPeopleTitle, message: DogConstantString.noPeopleMsg, preferredStyle: .alert)
                  
                  let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                      self.swipeSlider.slideToEndLft()
                      print("position5", position)
                  }
                  
                  alert.addAction(okAction)
                  
                  present(alert, animated: true, completion: nil)
              }else if AddPeopleDataManager.sharedInstance.people.count == 1{
                  checkLocationPermission()
                  dogStopImg.isHidden = true
                  streetImg.isHidden = false
                  DispatchQueue.main.async {
                      self.animationView()
                      self.dogAnimationView.isHidden = false
                      self.tabBarController?.tabBar.isHidden = true
                      self.shadowView.isHidden = false
                      self.redBtn.isHidden = false
                      self.concernBtn.isHidden = false
                      self.startWalk(indexOfEmergencyContact: 0)
                      print("position6", position)
                  }

              }else{
              checkLocationPermission()
               let alert = UIAlertController(title: "Choose Emergency Contact",
                                                message: nil,
                                                preferredStyle: .actionSheet)
                  for (index, person) in AddPeopleDataManager.sharedInstance.people.enumerated() {
                      
                      alert.addAction(UIAlertAction(title: person.personName,
                                                    style: .default,
                                                    handler: { _ in
                          self.dogStopImg.isHidden = true
                          self.streetImg.isHidden = false
                          DispatchQueue.main.async {
                              self.animationView()
                              self.dogAnimationView.isHidden = false
                              self.tabBarController?.tabBar.isHidden = true
                              self.shadowView.isHidden = false
                              self.redBtn.isHidden = false
                              self.concernBtn.isHidden = false
                              print("position6", position)
                          }
                         print("indexxx", index)
                          self.startWalk(indexOfEmergencyContact: index)
                      }))
                  }
//                  alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
                  alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { _ in
                      self.swipeSlider.slideToEndLft()
                  }))
                  self.present(alert, animated: true, completion: nil)
             // if locationEnabled == true{
              }
              positionValue = 1
          }
          UserDefaults.standard.set(positionValue, forKey: "SliderPosition")
      }
      
      func startWalk(indexOfEmergencyContact: Int){
          kDataManager.walkId = generateRandomString(length: 30)//String().randomString(length: 30)
          print("Monitor ID", kDataManager.walkId!)
          UserDefaults.standard.set(kDataManager.walkId, forKey: "MonitorIds")
          kDataManager.indexOfPersonMonitoring = indexOfEmergencyContact
          kMonitorMeLocationManager.monitorMe()
          sendWalkIDToEmergencyContact()
          print("lattt",lat ?? "")
          print("lngg",long ?? "")
          kMonitorMeLocationManager.forceUpdateToMonitorMeServerWithState(state: "HOWL", latitude: lat ?? "", longitude: long ?? "")
      }
      
    
      func sendWalkIDToEmergencyContact() {
          var notificationType = ""
          var mobileNo = ""
          let message = "Hello, please follow my walk on HOWL:"+base_url+kDataManager.walkId
          for person in AddPeopleDataManager.sharedInstance.people{
              notificationType = person.personNotificationType
              mobileNo = person.personCountryCode+person.personMobileNumber
              print("MobileNo", mobileNo)
              print("notifiiiii",notificationType)
          }
          if notificationType == "WHATSAPP"{
              if let mobileNoEncoded = mobileNo.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                 let messageEncoded = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                  let urlWhats = "whatsapp://send?phone=\(mobileNoEncoded)&text=\(messageEncoded)"
                  
                  if let whatsappURL = URL(string: urlWhats) {
                      if UIApplication.shared.canOpenURL(whatsappURL) {
                          UIApplication.shared.open(whatsappURL)
                      } else {
                          print("Install WhatsApp")
                      }
                  }
              }
              
          }else{
              if (MFMessageComposeViewController.canSendText()) {
                          let controller = MFMessageComposeViewController()
                          controller.body = message
                          controller.recipients = [mobileNo]
                          controller.messageComposeDelegate = self
                  self.present(controller, animated: true, completion: nil)
                      }
//              let urlSMS = "sms://" + mobileNo + "&body=" + message
//              if let urlString = urlSMS.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
//
//                  if let smsURL = URL(string: urlString) {
//
//                      if UIApplication.shared.canOpenURL(smsURL){
//
//                          UIApplication.shared.open(smsURL, options: [:], completionHandler: nil)
//                      } else {
//                          kAlertManager.triggerAlertTypeWarning(warningTitle: "INSTALL MESSAGES",
//                                                                warningMessage: "You do not have the messages app installed on your device",
//                                                                initialiser: self)
//                      }
//                  }
//              }
          }
          
      }
      
      func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
              switch (result) {
              case .cancelled:
                  print("Message was cancelled")
              case .failed:
                  print("Message failed")
              case .sent:
                  print("Message was sent")
              default:
                  return
              }
              dismiss(animated: true, completion: nil)
          }
      
      func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
              //... handle sms screen actions
          self.dismiss(animated: true, completion: nil)
          }
      // MARK: - Animation View
      func animationView(){
          let jsonName = "animation_dogWalk"
          let animation = LottieAnimation.named(jsonName)
          let animationView = LottieAnimationView(animation: animation)
          animationView.frame = CGRect(x: 30, y: 0, width: 225, height: 225)
          animationView.contentMode = .scaleAspectFill
          animationView.loopMode = .loop
          animationView.animationSpeed = 2
          dogAnimationView.addSubview(animationView)
          animationView.play()
      }
  }

extension DogWalkingViewController: CLLocationManagerDelegate {
    @objc func checkLocationPermission() {
            let authorizationStatus = locationManager.authorizationStatus

            switch authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                // Location permission is enabled
                print("Location permission is enabled")
                locationEnabled = true
            case .denied, .restricted:
                // Location permission is disabled
                print("Location permission is disabled")

                // Show an alert to the user informing them that they need to enable location permission
                let alert = UIAlertController(title: "Location Permission Disabled", message: "Please enable location permission in order to use this feature.", preferredStyle: .alert)

                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    // Open the Settings app so the user can enable location permission
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    self.locationEnabled = true
                }

                alert.addAction(okAction)
                locationEnabled = false
                present(alert, animated: true, completion: nil)
            case .notDetermined:
                // Location permission has not been requested yet
                locationManager.requestWhenInUseAuthorization()
            @unknown default:
                print("error")
            }
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
                let latitude = String(location.coordinate.latitude)
                let longitude = String(location.coordinate.longitude)
                print("Latitude: \(latitude), Longitude: \(longitude)")
                lat = latitude
                long = longitude
                // Now, you have latitude and longitude as strings in the "latitude" and "longitude" variables.
                // You can use them as needed.
            }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }

}

