//
//  UIViewController.swift
//  Howl
//
//  Created by apple on 14/09/23.
//

import Foundation
import UIKit

extension UIViewController{
    
    func alert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)

        if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
            topViewController.present(alertController, animated: true, completion: nil)
        }
    }
}
extension String {
    func capitalizeFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
