//
//  WalkerStatusVc.swift
//  Howl
//
//  Created by apple on 03/10/23.
//

import UIKit
import W3WSwiftApi
import what3words
import SVProgressHUD

class WalkerStatusVc: UIViewController {
//MARK: - Oultets
    @IBOutlet weak var walkerListTbLview: UITableView!
    
    var liveIDSet = true
    var idLabel = String()
    var processLabel = String()
    var walkUpdates = [WalkFetch]()
    var refreshTimer: Timer?
    var endsession = String()
    var status: Bool!
//    MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        walkerListTbLview.separatorColor = .clear
        fetchAndReloadData()
        let refreshControl = UIRefreshControl()
           refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
           
//            Add the refresh control to your table view
           walkerListTbLview.refreshControl = refreshControl
        liveIDSet = true
        _delegatesMethod()
        _registerCell()
        _setUI()
    }
    
    @objc func handleRefresh(_ sender: UIRefreshControl) {
        fetchAndReloadData()
//        if endsession == "End Session"{
//            let alertController = UIAlertController(title: "Session Expired", message: "Your Session is expired", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
//                self.navigationController?.popViewController(animated: true)
//                    })
//            alertController.addAction(okAction)
//            present(alertController, animated: true, completion: nil)
//
//        }
        sender.endRefreshing() // End the refresh animation when done
    }
    
    func fetchAndReloadData() {
        kMonitorMeLocationManager.fetchWalkUpdatesFromFirebase { [weak self] walkUpdates in
            if let walkUpdates = walkUpdates {
                self?.walkUpdates = walkUpdates
                print(walkUpdates)
//                for i in walkUpdates{
//                    if i.walkStatus == "End Session"{
//                       //
//                        self?.status = true
//                        let alertController = UIAlertController(title: "Session Expired", message: "Your Session is expired", preferredStyle: .alert)
//                        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
//                            UserDefaults.standard.removeObject(forKey: "MonitorOutPut")
//                            self?.navigationController?.popViewController(animated: true)
//
//                                })
//                        alertController.addAction(okAction)
//                        self?.present(alertController, animated: true, completion: nil)
//                    }
//                }
                self?.walkerListTbLview.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        walkerListTbLview.separatorColor = .clear
        kDataManager.setOnscreenViewController(onscreenView: self)
        SVProgressHUD.show()
        kMonitorMeLocationManager.fetchWalkUpdatesFromFirebase { [weak self] walkUpdates in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                  }
                    if let walkUpdates = walkUpdates {
                        self?.walkUpdates = walkUpdates
//                        for i in walkUpdates{
//                            if i.walkStatus == "End Session"{
//                               //
//                                self?.status = true
//                                let alertController = UIAlertController(title: "Session Expired", message: "Your Session is expired", preferredStyle: .alert)
//                                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
//                                    UserDefaults.standard.removeObject(forKey: "MonitorOutPut")
//                                    self?.navigationController?.popViewController(animated: true)
//                                        })
//                                alertController.addAction(okAction)
//                                self?.present(alertController, animated: true, completion: nil)
//                            }
//                        }
                        self?.walkerListTbLview.reloadData()
                    }
                }
        updateTableView()
        updateMonitorYouLabels()
    }
    
    @objc func updateMonitorYouLabels() {
        
        idLabel = "\(kDataManager.monitorYouID!)"
        print(kDataManager.monitorYouID!)
        
        if kMonitorYouLocationManager.isUpdating {
            
            switch kDataManager.monitorYouNullDataCounter {
                
            case 0:
                processLabel = "Active Monitoring"
                print("processLabel1", processLabel)
            default:
                
                let counter = kDataManager.monitorYouNullDataCounter + 1
                
                if counter == 360 {
                    
                    processLabel = "Inactive: No Data After One Hour"
                    print("processLabel2", processLabel)
                } else {
                    processLabel = "Active: No Data Attempt \(String(describing: counter)) of 360"
                    print("processLabel3", processLabel)
                }
            }
        } else {
            processLabel = "Monitoring Inactive"
            print("processLabel4", processLabel)
        }
    }
    
    @objc func updateTableView() {
        
        walkerListTbLview.reloadData()
    }
//    MARK: - Tbl view Delegates
    func _delegatesMethod(){
        walkerListTbLview.delegate = self
        walkerListTbLview.dataSource = self
    }
    
//    MARK: - Register cell
    func _registerCell(){
        walkerListTbLview.registerNib(of: WalkerStatusCell.self)
    }
    
//    MARK: - Set UI
    func _setUI(){
        walkerListTbLview.separatorColor = UIColor(cgColor: .init(red: 255.0/255.0, green: 0/255.0, blue: 68.0/255.0, alpha: 1.0))
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: "monitoring"),
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: "monitoryouupdate"),
                                                  object: nil)
    }
}

//MARK: - Extension of Tableview

extension WalkerStatusVc: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      //  print("Count",kDataManager.monitorYouOutput.count)
        //return kDataManager.monitorYouOutput.count
        return walkUpdates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.getCell() as WalkerStatusCell
        cell.batteryLbl.text = walkUpdates[indexPath.row].walkBattery
        cell.timeLbl.text = walkUpdates[indexPath.row].walkTime
        cell.dateLbl.text = walkUpdates[indexPath.row].walkDate
        let fullURL = walkUpdates[indexPath.row].walkW3WURL
        let desiredPart = fullURL.replacingOccurrences(of: "https://what3words.com/", with: "")
        cell.w3wLbl.text = desiredPart
        cell.statusLbl.text = walkUpdates[indexPath.row].walkStatus
        cell.monitorId.text = walkUpdates[indexPath.row].walkID
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if kDataManager.monitorYouOutput.count > 0 {
//            
//            // Hyperlink to W3W
//            let data: [String:String] = kDataManager.monitorYouOutput[indexPath.row]
//            let w3wLoc = data["w3w"]!
//            
//            // Set the W3W url if set
//            if w3wLoc != "NOT SET" {
//                
//                if let url = URL(string: "w3w://show?threewords=" + w3wLoc) {
//                    // Attempt to open the W3W app via URL scheme
//                    UIApplication.shared.open(url, options: [:]) {(success) in
//                        // Or open locally to the app in the web viewer
//                        if success != true {
//                            kDataManager.webURL = WebURLs.what3wordsURL + w3wLoc
//                            self.performSegue(withIdentifier: "ToW3W", sender: self)
//                            
//                        }
//                    }
//                }
//            }
//        }
    }
    
   
    }
    
    
