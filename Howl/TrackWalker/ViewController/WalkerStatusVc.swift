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
    var timerRunning = true
    
//    MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        walkerListTbLview.separatorColor = .clear
        fetchAndReloadData()
        liveIDSet = true
        _delegatesMethod()
        _registerCell()
        _setUI()
        refreshTimer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(fetchAndReloadData), userInfo: nil, repeats: true)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(fetchAndReloadData),
                                               name: NSNotification.Name(rawValue: "monitoring"),
                                               object: nil)
    }
    
   @objc func fetchAndReloadData() {
//           guard !walkUpdates.contains(where: { $0.walkStatus.contains("End Session") }) else {
//               stopRefreshTimer()
//               return
//           }

           kMonitorMeLocationManager.fetchWalkUpdatesFromFirebase { [weak self] walkUpdates in
               if let walkUpdates = walkUpdates {
//                    Sort the walkUpdates array based on a different criteria
                   let sortedWalkUpdates = walkUpdates.sorted { $0.walkTime > $1.walkTime }
                   DispatchQueue.main.async { [weak self] in
                       self?.walkUpdates = sortedWalkUpdates

                       if !(self?.timerRunning ?? true) {
                           self?.refreshTimer = Timer.scheduledTimer(timeInterval: 15, target: self!, selector: #selector(self?.fetchAndReloadData), userInfo: nil, repeats: true)
                           self?.timerRunning = true
                       }
                       
                       for i in sortedWalkUpdates {
                           let status = i.walkStatus
                           if status.contains("End Session") {
                               self?.stopRefreshTimer()
                               self?.timerRunning = false
                           }
                       }

                       self?.walkerListTbLview.reloadData()
                   }
               }
           }
       }
    
    func stopRefreshTimer() {
           refreshTimer?.invalidate()
//           refreshTimer = nil
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
                self?.walkUpdates = walkUpdates.sorted { $0.walkTime > $1.walkTime }
                self?.walkerListTbLview.reloadData()
            }
        }
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
        refreshTimer?.invalidate()
        refreshTimer = nil
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
        return walkUpdates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.getCell() as WalkerStatusCell
        if let batteryValue = Double(walkUpdates[indexPath.row].walkBattery) {
            cell.batteryLbl.text = String(format: "%.1f%%", batteryValue + 0.01)
        } else {
            // Handle the case when the value could not be converted to a double
        }
        cell.timeLbl.text = walkUpdates[indexPath.row].walkTime
        cell.dateLbl.text = walkUpdates[indexPath.row].walkDate
        let fullURL = walkUpdates[indexPath.row].walkW3WURL
        let desiredPart = fullURL.replacingOccurrences(of: "https://what3words.com/", with: "")
        cell.w3wLbl.text = desiredPart
        cell.statusLbl.text = walkUpdates[indexPath.row].walkStatus
        cell.monitorId.text = walkUpdates[indexPath.row].walkID
        let status = walkUpdates[indexPath.row].walkStatus
        switch status {
        case "Start Session":
            cell.containerView.backgroundColor = .white
        case "Auto-Update":
            cell.containerView.backgroundColor = .lightGray
        case "Im Safe":
            cell.containerView.backgroundColor = ColorConstant.greenColor
        case "Illness/Injury":
            cell.containerView.backgroundColor = ColorConstant.amberColor
        case "HOWL":
            cell.containerView.backgroundColor = ColorConstant.pinkColor
        case "End Session":
            cell.containerView.backgroundColor = .lightGray
        default:
            cell.containerView.backgroundColor = .lightGray
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = walkUpdates[indexPath.row].walkW3WURL
        print(data)
        if let url = URL(string: data), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Invalid URL or unable to open URL")
        }
        
    }
    
   
    }
    
    
