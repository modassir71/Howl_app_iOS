//
//  AppStoryboard.swift
//  Howl
//
//  Created by apple on 20/08/23.
//

import Foundation
import UIKit

enum AppStoryboard : String {
    case Main = "Main"
    case DialogePopUp = "CustomPopUp"
    //case vc = "ViewController"
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
}
let kResetTheApp = false
let kGodMode = false
let kDataLoggingIsActive = true // Basic data logging for testing
let kDeepDataLogging = false // Detailed data logging for extensive testing and visualisation
let kPrePopulateFields = true // Prepopulate fields for testing



