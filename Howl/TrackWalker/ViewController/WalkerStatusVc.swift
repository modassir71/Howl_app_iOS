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
//    MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        print("Count",kDataManager.monitorYouOutput.count)
        return kDataManager.monitorYouOutput.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.getCell() as WalkerStatusCell
        let data: [String:String] = kDataManager.monitorYouOutput[indexPath.row]
        
        // Available Data
        /*
        [
         "course": "-1.0",
         "date": "17/03/2021",
         "battery": "39.0",
         "speed": "0.0",
         "time": "13:18:24",
         "longitude": "-1.6085460479354947",
         "output": "1",
         "id": "",
         "latitude": "52.27189386945288",
         "status": "Auto-Update"
         ]
        */
        
        cell.statusLbl.text = data["status"]!
        cell.dateLbl.text = data["date"]!
        cell.timeLbl.text = data["time"]!
        cell.batteryLbl.text = data["battery"]! + "%"
        
        //What 3 Words
        let w3wText = "W3W:"
        let w3w = data["w3w"]!
        cell.w3wLbl.text = w3wText + " " + w3w
        
        switch data["status"]! {
        
        case "Start Session":
            cell.backgroundColor = .white
        case "Auto-Update":
            cell.backgroundColor = .lightGray
        case "Im Safe":
            cell.backgroundColor = ColorConstant.greenColor
        case "Concerned":
            cell.backgroundColor = ColorConstant.amberColor
        case "HOWL":
            cell.backgroundColor = ColorConstant.pinkColor
        case "End Session":
            cell.backgroundColor = .white
            kMonitorYouLocationManager.stopMonitoringYou()
        default:
            cell.backgroundColor = .lightGray
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if kDataManager.monitorYouOutput.count > 0 {
            
            // Hyperlink to W3W
            let data: [String:String] = kDataManager.monitorYouOutput[indexPath.row]
            let w3wLoc = data["w3w"]!
            
            // Set the W3W url if set
            if w3wLoc != "NOT SET" {
                
                if let url = URL(string: "w3w://show?threewords=" + w3wLoc) {
                    // Attempt to open the W3W app via URL scheme
                    UIApplication.shared.open(url, options: [:]) {(success) in
                        // Or open locally to the app in the web viewer
                        if success != true {
                            kDataManager.webURL = WebURLs.what3wordsURL + w3wLoc
                            self.performSegue(withIdentifier: "ToW3W", sender: self)
                            
                        }
                    }
                }
            }
        }
    }
    
   
    }
    
    
