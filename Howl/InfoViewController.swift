//
//  InfoViewController.swift
//  Howl
//
//  Created by apple on 07/09/23.
//

import UIKit

class InfoViewController: UIViewController {
//MARK: - Outlet
    @IBOutlet weak var navigationView: UIView!
    
//    MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _setUi()
    }
    
//    MARK: - SetUp UI
    func _setUi(){
        navigationView.layer.shadowColor = UIColor.black.cgColor
        navigationView.layer.shadowOpacity = 0.2
        navigationView.layer.shadowOffset = CGSize(width: 0, height: 5)
        navigationView.layer.shadowRadius = 2
    }

 

}
