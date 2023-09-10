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
    case vc = "ViewController"
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
}


