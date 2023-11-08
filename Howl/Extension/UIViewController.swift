//
//  UIViewController.swift
//  Howl
//
//  Created by apple on 14/09/23.
//

import Foundation
import UIKit
let loaderView = UIView()
let activityIndicator = UIActivityIndicatorView(style: .large)
extension UIViewController{
    
    func alert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)

        if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
            topViewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    func isiPhoneSE() -> Bool {
        let screenHeight = UIScreen.main.bounds.height
        return screenHeight <= 667
    }
    
    
    func startLoader() {
            loaderView.frame = view.bounds
            loaderView.backgroundColor = UIColor(white: 0, alpha: 0.3)
            activityIndicator.center = loaderView.center
            activityIndicator.startAnimating()
            view.addSubview(loaderView)
        }
    
    func stopLoader() {
           activityIndicator.stopAnimating()
           loaderView.removeFromSuperview()
       }
    
}
extension String {
    func capitalizeFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
