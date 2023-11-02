//
//  DogListingViewController.swift
//  Howl
//
//  Created by apple on 20/09/23.
//

import UIKit
import Lottie
import Social
import CoreAudio
import FBSDKShareKit

class DogListingViewController: UIViewController, SharingDelegate {
   
    

//  MARK:- Outlet
    @IBOutlet weak var importBtn: UIButton!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var dogTblView: UITableView!
    @IBOutlet weak var addDogBtn: UIButton!
    @IBOutlet weak var animationContainer: UIView!
    //    MARK: - Variable
        var animationView = LottieAnimationView()
        var instance  = DogDataManager.shared
         let emptyLbl = UILabel()
    var emailController: MailController!
    var walkUpdates = [WalkFetch]()
    //    MARK: - Life cycle
        override func viewDidLoad() {
            super.viewDidLoad()
            _setUI()
            _delegateMethod()
            registerCell()
            print(kMonitorMeLocationManager.lastUpdatesArray)
//            for i in walkUpdates{
//               print("dddddd",i.flag)
//            }
//            print(walkUpdates)
        }
        
        override func viewWillAppear(_ animated: Bool) {
            tabBarController?.tabBar.isHidden = true
            dogTblView.reloadData()
            floatingBtn()
            //updateView()
        }
        
    //    MARK: - Floating Buttton
        func floatingBtn(){
            let floatingButton = UIButton(type: .custom)
            floatingButton.setTitle("Tap", for: .normal)
            floatingButton.setImage(UIImage(named: "Plus_Img"), for: .normal)
            floatingButton.setTitleColor(.white, for: .normal)
            floatingButton.backgroundColor = UIColor(displayP3Red: 221.0/255.0, green: 0/255.0, blue: 65.0/255.0, alpha: 1.0)
            floatingButton.layer.cornerRadius = 30
            if isiPhoneSE(){
                floatingButton.frame = CGRect(x: 295, y: 570, width: 60, height: 60)
            }else{
                floatingButton.frame = CGRect(x: 300, y: 700, width: 60, height: 60)
            }
            floatingButton.layer.shadowColor = UIColor.black.cgColor
            floatingButton.layer.shadowOffset = CGSize(width: 0, height: 4)
            floatingButton.layer.shadowOpacity = 0.3
            floatingButton.layer.shadowRadius = 4
            floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
            view.addSubview(floatingButton)
        }
        
        @objc func floatingButtonTapped() {
            let storyboard = AppStoryboard.Main.instance
            let addNewDogVc = storyboard.instantiateViewController(withIdentifier: "AddDogViewController") as! AddDogViewController
            self.navigationController?.pushViewController(addNewDogVc, animated: true)
            }
    //MARK: - Delegates confirm
        func _delegateMethod(){
            dogTblView.delegate = self
            dogTblView.dataSource = self
        }
        
        //    MARK: - Register cell
            func registerCell(){
                dogTblView.registerNib(of: PersonListingTableViewCell.self)
            }
        
    //    MARK: - SetUp UI
        func _setUI(){
            navigationView.layer.shadowColor = UIColor.black.cgColor
            navigationView.layer.shadowOpacity = 0.2
            navigationView.layer.shadowOffset = CGSize(width: 0, height: 5)
            navigationView.layer.shadowRadius = 2
            addDogBtn.isHidden = true
            importBtn.layer.cornerRadius = 5.0
            importBtn.clipsToBounds = true
            
        }
    //MARK: - Button Action
        @IBAction func backBtnPress(_ sender: UIButton) {
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        @IBAction func addDogBtnPress(_ sender: Any) {
            let storyboard = AppStoryboard.Main.instance
            let addNewDogVc = storyboard.instantiateViewController(withIdentifier: "AddDogViewController") as! AddDogViewController
            self.navigationController?.pushViewController(addNewDogVc, animated: true)
        }
    
    
    @IBAction func importBtnPress(_ sender: Any) {
        if kDataManager.sharedDogImport == true {
            
            let alert = UIAlertController(title: "DOG IMPORT",
                                          message: "A shared dog file was imported.  Would you like to add this dog to your pack?",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: {_ in
                
                kDataManager.sharedDogImport = false
            }))
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ in
                
                kDataManager.importDogShare()
            }))
            
            kDataManager.onScreenViewController.present(alert, animated: true)
        } else {
            
            kAlertManager.triggerAlertTypeWarning(warningTitle: "NO DATA FOUND",
                                                  warningMessage: "No shared dog data was imported.  Please import a dog via the shared email and try again",
                                                  initialiser: self)
        }
        
    }
    
    }

    //MARK: - Delegates and datsource method
    extension DogListingViewController: UITableViewDelegate, UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if instance.dogs.count == 0{
                animationViewStart()
                animationContainer.isHidden = false
                emptyLbl.isHidden = false
            }else{
                emptyLbl.removeFromSuperview()
                emptyLbl.isHidden = true
                animationView.removeFromSuperview()
                animationContainer.isHidden = true
            }
            return instance.dogs.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.getCell() as PersonListingTableViewCell
            let items = instance.dogs[indexPath.row]
            self.animationView.isHidden = true
           // self.emptyLbl.isHidden = true
            cell.nameTitle.text = DogConstantString.breedName
            cell.nickNameTitle.text = DogConstantString.dog
            cell.nickNameLbl.text = items.dogName
            cell.nameLbl.text = items.dogBreed
            if let dogImageData = items.dogImage {
                if let dogImage = UIImage(data: dogImageData) {
                    cell.profileImg.image = dogImage
                }
            }
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let items = self.instance.dogs[indexPath.row]

            // Present an alert to confirm the edit action
            let alert = UIAlertController(title: DogConstantString.warningTitle,
                                          message: DogConstantString.editMsg,
                                          preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            alert.addAction(UIAlertAction(title: DogConstantString.proceedTitle, style: .default) { [weak self] _ in
                guard let self = self else { return }

                let storyBoard = AppStoryboard.Main.instance
                let editDogVc = storyBoard.instantiateViewController(withIdentifier: "AddDogViewController") as! AddDogViewController
                self.instance.selectedIndex = indexPath.row
                editDogVc.isUpdate = true
                editDogVc.dogName = items.dogName
                editDogVc.profileImage = items.dogImage
                editDogVc.breed = items.dogBreed
                editDogVc.color = items.dogColour
                editDogVc.dob = items.dogDOB
                editDogVc.microchipDb = items.dogMicrochipSupplier
                editDogVc.microchipNumber = items.dogMicrochipNumber
                editDogVc.feature = items.dogDistinctiveFeatures
                editDogVc.genderType = items.dogSex
                editDogVc.type = true
                editDogVc.dogType = items.dogNeuteredOrSpayed

                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(editDogVc, animated: true)
                }
            })

            self.present(alert, animated: true, completion: nil)
        }

        
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
           // var delete: UIContextualAction!
            var swipeActions = [UIContextualAction]()
            var status: UIContextualAction!
            //var status: UIContextualAction!
            if let dogStolen = instance.dogs[indexPath.row].dogStolen {
                
                switch dogStolen {
                    
                case true:
                    
                    status = UIContextualAction(style: .normal, title: "Safe") {  (contextualAction, view, boolValue) in
                        
                        self.instance.dogs[indexPath.row].dogStolen = false
                        _ = self.instance.saveDogs()
                        self.dogTblView.setEditing(false, animated: true)
                    }
                    status.backgroundColor = ColorConstant.greenColor//buttonGreen.colorWithHexString()
                case false:
                    
                    status = UIContextualAction(style: .normal, title: "Incident") {  (contextualAction, view, boolValue) in
                        
                        // Choose who should monitor you
                        let alert = UIAlertController(title: "SET INCIDENT",
                                                      message: "Select an incident that relates to this theft",
                                                      preferredStyle: .actionSheet)
                        
//                        for (index, walk) in kDataManager.monitorMeLocalHistoric.enumerated() {
//
//                            print(String(describing: walk))
//
//                            alert.addAction(UIAlertAction(title: walk[0].date + "-" + walk[0].time,
//                                                          style: .default,
//                                                          handler: { _ in
//
//                                self.setStolen(indexOfDog: indexPath.row, indexOfIncident: index)
//                            }))
//                        }
                        
                        for (index, walk) in kMonitorMeLocationManager.lastUpdatesArray.enumerated(){
                            alert.addAction(UIAlertAction(title: walk.walkDate + "-" + walk.walkTime,
                                                          style: .default,
                                                          handler: { _ in

                                self.setStolen(indexOfDog: indexPath.row, indexOfIncident: index)
                            }))
                            
                        }
                        
                        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    status.backgroundColor = .black
                }
            }
            
            // If the dog is stolen allow email of incident data
            var email: UIContextualAction!
            
            if instance.dogs[indexPath.row].dogStolen == true {
                
                email = UIContextualAction(style: .normal, title: "Email") {  (contextualAction, view, boolValue) in
                    
                    self.emailController = MailController()
                    self.emailController.sendIncident(initialiser: self, dogIndex: indexPath.row)
                    self.dogTblView.setEditing(false, animated: true)
                }
                
                email.backgroundColor = .cyan//buttonTurqoise.colorWithHexString()
            }
            
//            // If the dog is stolen allow archiving
//            var archive: UIContextualAction!
//
//            if instance.dogs[indexPath.row].dogStolen == true {
//
//                archive = UIContextualAction(style: .normal, title: "Archive") {  (contextualAction, view, boolValue) in
//
//                    self.dogTblView.setEditing(false, animated: true)
//
//                    // Copy the dog to the archive
//                    self.instance.dogsArchive.append(self.instance.dogs[indexPath.row])
//
//                    if self.instance.saveDogsArchive() == true {
//
//                        self.instance.dogs.remove(at: indexPath.row)
//                        _ = self.instance.saveDogs()
//
//                        kAlertManager.triggerAlertTypeWarning(warningTitle: "SUCCESS",
//                                                              warningMessage: "Dog archived - see the info menu to unarchive if required",
//                                                              initialiser: self)
//
//                        self.dogTblView.reloadData()
//
//                    } else {
//
//                        kAlertManager.triggerAlertTypeWarning(warningTitle: "ARCHIVE ERROR",
//                                                              warningMessage: "System error - please try again or contact support to review",
//                                                              initialiser: self)
//                    }
//                }
//
//                archive.backgroundColor = .darkGray
//            }
            
            // if the dog is stolen allow social posting
            var social: UIContextualAction!
            
            if instance.dogs[indexPath.row].dogStolen == true {
                
                social = UIContextualAction(style: .normal, title: "Social") {  (contextualAction, view, boolValue) in
                    
                    self.dogTblView.setEditing(false, animated: true)
                    self.createAndShareCSV(dogIndex: indexPath.row)
                }
                
                social.backgroundColor = .lightGray
            }
            
            
            var delete: UIContextualAction!
            
            delete = UIContextualAction(style: .normal, title: "Delete") {  (contextualAction, view, boolValue) in
                
                let alert = UIAlertController(title: "Warning",
                                              message: "You are about to delete from your pack.  Do you wish to proceed?",
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
                
                alert.addAction(UIAlertAction(title: "Proceed",
                                              style: .default,
                                              handler: { _ in
                    
                   // self.deleteFromPack(type: "dogs", index: indexPath.row)
                    self.deleteDog(index: indexPath.row)
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
            delete.backgroundColor = .red//buttonRed.colorWithHexString()
            
            if instance.dogs[indexPath.row].dogStolen == true {
                
                swipeActions = [delete, status, email, social]
            } else {
                swipeActions = [delete, status]
            }
            return UISwipeActionsConfiguration(actions: swipeActions)
        }
        
        func createAndShareCSV(dogIndex: Int) {
            // Create the CSV data
            var csvString = "ID,DATE,TIME,LONGITUDE,LATITUDE,SPEED,COURSE,BATTERY,STATUS,W3W,W3WURL\n"
            
//            for walk in DogDataManager.shared.dogs[dogIndex].dogIncident {
//                let row = "\(walk.walkID ),\(walk.walkDate ),\(walk.walkTime ),\(walk.walkLongitude ),\(walk.walkLatitude ),\(walk.walkSpeed ),\(walk.walkCourse ),\(walk.walkBattery ),\(walk.walkStatus ),\(walk.walkW3WWords ),\(walk.walkW3WURL )\n"
//                csvString += row
//            }
            print("CSV string", csvString)
            for walk in kMonitorMeLocationManager.lastUpdatesArray{
                let row = "\(walk.walkID ),\(walk.walkDate ),\(walk.walkTime ),\(walk.walkLongitude ),\(walk.walkLatitude ),\(walk.walkSpeed ),\(walk.walkCourse ),\(walk.walkBattery ),\(walk.walkStatus ),\(walk.walkW3WWords ),\(walk.walkW3WURL )\n"
                csvString += row
            }
            
            if let data = csvString.data(using: .utf8) {
                let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("incident.csv")
                
                do {
                    try data.write(to: fileURL)
                } catch {
                    print("Error writing CSV file: \(error)")
                    return
                }
                
                // Share the CSV file
                let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
                activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
                
                // Find the most appropriate view controller to present the activity view controller
                if let presentingViewController = UIApplication.shared.windows.first?.rootViewController {
                    presentingViewController.present(activityViewController, animated: true, completion: nil)
                }
            }
        }
        
        func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
            // print("Conmpleted: \(results)")
        }
        
        func sharer(_ sharer: Sharing, didFailWithError error: Error) {
            // print("Error: \(error)")
        }
        
        func sharerDidCancel(_ sharer: Sharing) {
            // print("Cancelled: \(sharer)")
        }
        
        func setStolen(indexOfDog: Int, indexOfIncident: Int) {
            
            instance.dogs[indexOfDog].dogStolen = true
            instance.dogs[indexOfDog].dogIncident = kDataManager.monitorMeLocalHistoric[indexOfIncident]
            _ = instance.saveDogs()
            self.dogTblView.setEditing(false, animated: true)
        }
        
        func deleteDog(index: Int!){
            instance.dogs.remove(at: index)
            if !instance.saveDogs() == true {
                let alert = UIAlertController(title: DogConstantString.peopleDeleteErrorTitle, message: DogConstantString.peopleDeleteError, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            dogTblView.reloadData()
        }
        
        func animationViewStart(){
            let jsonName = "dogData"
            let animation = LottieAnimation.named(jsonName)
            animationView = LottieAnimationView(animation: animation)
            let centerX = view.bounds.width / 2.0
            let centerY = view.bounds.height / 2.0
            let viewWidth: CGFloat = 225
            let viewHeight: CGFloat = 225
            animationView.frame = CGRect(x: centerX - viewWidth / 2.0, y: centerY - viewHeight / 2.0, width: viewWidth, height: viewHeight)
            animationView.contentMode = .scaleAspectFill
            animationView.backgroundColor = .white
            animationView.loopMode = .loop
            animationView.animationSpeed = 1
            self.animationContainer.addSubview(animationView)
            emptyLblMsg()
            animationView.play()
        }
        
        func emptyLblMsg(){
            emptyLbl.text = "This part of your pack is empty.\nAdd a dog"
            emptyLbl.textColor = UIColor.gray
            emptyLbl.numberOfLines = 2
            emptyLbl.font = UIFont.systemFont(ofSize: 18)
           // label.backgroundColor = .red
            emptyLbl.textAlignment = .center
            let centerX = view.bounds.width / 2.0
            let centerY = view.bounds.height / 2.0
            let viewWidth: CGFloat = 284
            let viewHeight: CGFloat = 60
            emptyLbl.frame = CGRect(x: centerX - viewWidth / 2.0, y: centerY - viewHeight / 2.0 - 120, width: viewWidth, height: viewHeight)
            view.addSubview(emptyLbl)
        }
        
    }
