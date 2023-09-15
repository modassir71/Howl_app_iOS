//
//  AddPeopleDataManager.swift
//  Howl
//
//  Created by apple on 15/09/23.
//

import Foundation

class AddPeopleDataManager{
    static let sharedInstance: AddPeopleDataManager = {
        
        let instance = AddPeopleDataManager()
        return instance
    }()
    
    var people: [Person]! = []
    init() {
        if let loaded = loadPeople() {
            
            people = loaded
        } else {
            people = []
        }
    }
    let kDocumentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    func savePeople() -> Bool {
        
        var filePath = kDocumentsDirectory
        filePath = kDocumentsDirectory + "/howlpeople"
        
        let fileURL = URL(fileURLWithPath: filePath)
        
        do {
            
            let data = try PropertyListEncoder().encode(people)
            let archiveData = try NSKeyedArchiver.archivedData(withRootObject: data,
                                                               requiringSecureCoding: false)
            try archiveData.write(to: fileURL)
            return true
            
        } catch {
            return false
        }
    }
    
    func loadPeople() -> [Person]? {
        
        var filePath = kDocumentsDirectory
        filePath = kDocumentsDirectory + "/howlpeople"
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            if let loadedInfo = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Data? {

                let loadedHumans = try PropertyListDecoder().decode([Person].self, from: loadedInfo!)
                return loadedHumans
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
}
