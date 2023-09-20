//
//  InstructionViewController.swift
//  Howl
//
//  Created by apple on 20/09/23.
//

import UIKit

class InstructionViewController: UIViewController {
//MARK: - Outlet
    
    @IBOutlet weak var navigationView: UIView!
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
