//
//  StringConstant.swift
//  Howl
//
//  Created by apple on 12/09/23.
//

import Foundation
import UIKit
struct StringConstant {
//  Microphone Access msg
    static let microphoneAccessTitle = "MIC ACCESS REQUIRED"
    static let microphoneAccessMsg = "HOWL requires camera and mic access"
//    Camera access msg
    static let cameraAccessTitle = "CAMERA ACCESS REQUIRED"
    static let cameraAccessMsg = "HOWL requires camera and mic access"
//   Notification msg
    static let notificationAccessTitle = "ERROR"
    static let notificationAccessMsg = "A system error has occured.  Please try again or contact the developer for support."
//   Set Permission Msg
    static let permissionTitle = "SETUP COMPLETE?"
    static let permissionMsg = "If any of the buttons here are red the HOWL app will not function as designed.  You can edit these settings again by visitng the info tab / access controls menu of the app.  Do you wish to proceed?"
//    Siren msg
    static let sirenTitle = "SELECT SIREN"
    static let sirenMsg = "Please select a siren to be played to deter any potential offender should you use the HOWL functionality of the app.  As a test menu the sirens will be played at 30% volume.  Please ensure your device is not in silent mode"
//    Archive msg
    static let archiveTitle = "No Data"
    static let archiveMsg = "There is no any data"
//    TABBAR
    static let mypack_Tab = "MY PACK"
    static let howl_Tab = "HOWL"
    static let more_Tab = "MORE"
    
//Paermission Msg
    static let congrulationTitle = "Congratulations!!"
    static let setupMsg = "You have set all the required permissions."
//    Userdefault key
     static let hasAppLaunchedBeforeKey = "HasAppLaunchedBefore"
    
    //Notification Msg
    static let HowlForHelp = "Howl for help"
    static let RaisedConcern = "Raised a Concern"
    static let ImSafe = "I am Safe"
}

struct ImageStringConstant{
    //    Iphone se
    static let myPackSelectable = "My_Pack_Selectable"
    static let myPackUnselectable = "My_Pack_Unslectable"
    static let howlSelectable = "Howl_Selectable"
    static let howlUnselectable = "Howl_Unslectable"
    static let moreSelectable = "More_Selectable"
    static let moreUnselectable = "More_Unselectable"
    
    //Normal iphone
    static let myPackSelectable_Icon = "MyPack_select"
    static let myPackUnselectable_Icon = "MyPack_unselect"
    static let howlSelectable_Icon = "Howl_select"
    static let howlUnselectable_Icon = "Howl_unselect"
    static let moreSelectable_Icon = "More_select"
    static let moreUnselectable_Icon = "More_unselect"
}

struct ColorConstant{
//    Color constant
    static let pinkColor = UIColor(red: 229.0/255.0, green: 6.0/255.0, blue: 82.0/255.0, alpha: 1.0)
    static let greenColor = UIColor(red: 142.0/255.0, green: 209.0/255.0, blue: 181.0/255.0, alpha: 1.0)
    static let amberColor = UIColor(red: 251.0/255.0, green: 189.0/255.0, blue: 87.0/255.0, alpha: 1.0)
    static let amber3Color = UIColor(red: 231.0/255.0, green: 189.0/255.0, blue: 87.0/255.0, alpha: 1.0)
    static let grayColor = UIColor(red: 0.8274509804, green: 0.8274509804, blue: 0.8274509804, alpha: 1)
    static let amber2Color = UIColor(red: 250.0/255.0, green: 220.0/255.0, blue: 100.0/255.0, alpha: 1.0)
    
}

