//
//  System Log.swift
//  Just Move Simple
//
//  Created by Peter Farrell on 02/05/2020.
//  Copyright © 2020 App Intelligence Ltd. All rights reserved.
//

import UIKit
import Foundation

private var once = Int()

class SystemLog {
    
    // MARK: VARIABLES
    let filePath = kDocumentsDirectory + "/DataLog"
    var dataLog: [[String:String]]!
    
    static let sharedInstance: SystemLog = {
        
        let instance = SystemLog()
        return instance
    }()
    
    init() {
        
        // If a log is saved to file load it else create an empty log
        if let log = loadDataLog() {
            
            dataLog = log
        } else {
            dataLog = []
        }
    }
    
    //MARK: SAVE & LOAD
    func saveDataLog() {
        
        do {
            
            let data = try NSKeyedArchiver.archivedData(withRootObject: dataLog!, requiringSecureCoding: false)
            try data.write(to: URL(fileURLWithPath: filePath))
            
            if kDataLoggingIsActive {
                
                print("SYSTEM LOG SUCCESSFULLY WRITTEN TO DISC")
            }
        } catch {
            
            if kDataLoggingIsActive {
                
                print("SYSTEM LOG FAILED TO WRITE TO DISC")
            }
        }
    }
    
    func loadDataLog() -> [[String:String]]? {
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            let log = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [[String:String]]
            
            if kDataLoggingIsActive {
                
                print("SYSTEM LOG LOADED WITH: \(String(describing: log?.count)) ENTRIES")
            }
            
            return log
            
        } catch {
            
            if kDataLoggingIsActive {
                
                print("SYSTEM LOG FAILED TO LOAD")
            }
            return nil
        }
    }
    
    //MARK: UPDATE
    func updateLog(logEntry: String!) {
        
        // A maximum log record count can be set in the options menus.
        // If set use this as the max and remove any aged logs or if not set assume a max of 100,000 records
        var maxLogCount: Int!
        
        if UserDefaults.standard.integer(forKey: "MaxLogCount") == 0 {
            
            maxLogCount = 10000
        } else {
            
            maxLogCount = UserDefaults.standard.integer(forKey: "MaxLogCount")
        }
        
        if dataLog.count >= maxLogCount {
            
            dataLog.removeSubrange(ClosedRange(uncheckedBounds: (lower: maxLogCount - 1,upper:dataLog.count - 1)))
        }
        
        let logEntry: [String:String] = [
            "DATE":Helpers().returnTodaysDate() ,
            "TIME":Helpers().returnTheTimeNow() ,
            "ENTRY":logEntry
        ]
        
        dataLog.insert(logEntry, at: 0)
        
        // Save the log to file on a background thread so as not to disrupt the main app's functionality
        DispatchQueue.global(qos: .background).async {
            
            self.saveDataLog()
        }
    }
}
