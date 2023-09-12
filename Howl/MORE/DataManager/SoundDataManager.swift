//
//  SoundDataManager.swift
//  Howl
//
//  Created by apple on 12/09/23.
//

import Foundation
class SoundDataManager{
    static let sharedInstance: SoundDataManager = {
        let instance = SoundDataManager()
        return instance
    }()
}
