//
//  SoundDataManager.swift
//  Howl
//
//  Created by apple on 12/09/23.
//

import Foundation
class SoundDataManager{
    static let sharedInstance: SoundDataManager  = {
        let instance = SoundDataManager()
        return instance
    }()
    
    var sirenID:Int = 0 // Holds the siren index for HOWL
    
    func saveSiren(index: Int!) {
        
        sirenID = index
        UserDefaults.standard.set(sirenID, forKey: "siren")
    }
}
