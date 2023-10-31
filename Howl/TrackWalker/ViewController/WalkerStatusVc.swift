//
//  WalkerStatusVc.swift
//  Howl
//
//  Created by apple on 03/10/23.
//

import UIKit
import W3WSwiftApi
import what3words


class WalkerStatusVc: UIViewController {
//MARK: - Oultets
    @IBOutlet weak var walkerListTbLview: UITableView!
    
    var liveIDSet = true
    var idLabel = String()
    var processLabel = String()
    var walkUpdates = [WalkFetch]()
//    MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        kMonitorMeLocationManager.fetchWalkUpdatesFromFirebase { [weak self] walkUpdates in
                    if let walkUpdates = walkUpdates {
                        self?.walkUpdates = walkUpdates
                        print(walkUpdates)
                        self?.walkerListTbLview.reloadData()
                    }
                }
        liveIDSet = true
        _delegatesMethod()
        _registerCell()
        _setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        kDataManager.setOnscreenViewController(onscreenView: self)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTableView),
                                               name: NSNotification.Name(rawValue: "monitoring"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateMonitorYouLabels),
                                               name: NSNotification.Name(rawValue: "monitoryouupdate"),
                                               object: nil)
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
        cell.w3wLbl.text = walkUpdates[indexPath.row].walkW3WURL
        cell.statusLbl.text = walkUpdates[indexPath.row].walkStatus
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
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
    
    
