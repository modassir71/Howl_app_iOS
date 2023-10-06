//
//  StringConstant.swift
//  Howl
//
//  Created by apple on 12/09/23.
//

import Foundation
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
