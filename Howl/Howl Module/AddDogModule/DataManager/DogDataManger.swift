//
//  DogDataManger.swift
//  Howl
//
//  Created by apple on 15/09/23.
//

import Foundation
 
class DogDataManager{
    static let shared: DogDataManager = {
        let instance = DogDataManager()
        return instance
    }()
//    MARK: - Variable
    var walkMonitor = ""
    var dogsArchive: [Dog]! = []
    var dogs: [Dog]! = []
    var walkUpdates: [WalkFetch] = []
    var selectedIndex: Int! = 0
    let kDocumentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    init(){
        if let loaded = loadDogs() {
            
            dogs = loaded
        } else {
            dogs = []
        }
        if let loaded = loadDogsArchive() {
            
            dogsArchive = loaded
        } else {
            dogsArchive = []
        }
    }
    
    func loadDogsArchive() -> [Dog]? {
        
        var filePath = kDocumentsDirectory
        filePath = kDocumentsDirectory + "/howldogsarchive"
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            if let loadedInfo = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Data? {

                let loadedDogs = try PropertyListDecoder().decode([Dog].self, from: loadedInfo!)
                return loadedDogs
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    func saveDogsArchive() -> Bool {
        
        var filePath = kDocumentsDirectory
        filePath = kDocumentsDirectory + "/howldogsarchive"
        
        let fileURL = URL(fileURLWithPath: filePath)
        
        do {
            
            let data = try PropertyListEncoder().encode(dogsArchive)
            let archiveData = try NSKeyedArchiver.archivedData(withRootObject: data,
                                                               requiringSecureCoding: false)
            try archiveData.write(to: fileURL)
            return true
            
        } catch {
            return false
        }
    }
    
    func saveDogs() -> Bool {
        
        var filePath = kDocumentsDirectory
        filePath = kDocumentsDirectory + "/howldogs"
        
        let fileURL = URL(fileURLWithPath: filePath)
        
        do {
            
            let data = try PropertyListEncoder().encode(dogs)
            let archiveData = try NSKeyedArchiver.archivedData(withRootObject: data,
                                                               requiringSecureCoding: false)
            try archiveData.write(to: fileURL)
            return true
            
        } catch {
            return false
        }
    }
    
    func loadDogs() -> [Dog]? {
        
        var filePath = kDocumentsDirectory
        filePath = kDocumentsDirectory + "/howldogs"
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            if let loadedInfo = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Data? {

                let loadedDogs = try PropertyListDecoder().decode([Dog].self, from: loadedInfo!)
                return loadedDogs
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
}
