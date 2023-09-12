//
//  AlertManager.swift
//  Howl
//
//  Created by apple on 12/09/23.
//

import Foundation
import UIKit

class AlertManager{
    static let sharedInstance: AlertManager = {
        
        let instance = AlertManager()
        return instance
    }()
    
    init() {
        
    }
    
    //MARK: STANDARD ALERT WITH PASSED TITLE AND MESSAGE
    func triggerAlertTypeWarning(warningTitle: String, warningMessage: String, initialiser: UIViewController) {
        
        let alert = UIAlertController(title: warningTitle,
                                      message: warningMessage,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        initialiser.present(alert, animated: true)
        
//        if Helpers().returnSpeechOutputState() == true {
//            
//            kSoundManager.addTextToBeSpokenNext(warningTitle)
//        }
    }
}
