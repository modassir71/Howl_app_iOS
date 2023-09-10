//
//  PermissionViewController.swift
//  Howl
//
//  Created by apple on 08/09/23.
//

import UIKit

class PermissionViewController: UIViewController {
//MARK: - Outlet
    @IBOutlet weak var navigationView: UIView!
    
    @IBOutlet weak var setPermissionBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var microphoneBtn: UIButton!
    
//    MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _setUpUI()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
    }
 
//    MARK: - Add shadow and corner Radius
    func addShadow(to Button: UIButton){
        Button.layer.shadowColor = UIColor.red.cgColor
        Button.layer.shadowOpacity = 0.2
        Button.layer.shadowOffset = CGSize(width: 0, height: 5)
        Button.layer.shadowRadius = 2
        Button.layer.cornerRadius = 15
    }
//    MARK: - SetUp Ui
    func _setUpUI(){
        navigationView.layer.shadowColor = UIColor.black.cgColor
        navigationView.layer.shadowOpacity = 0.2
        navigationView.layer.shadowOffset = CGSize(width: 0, height: 5)
        navigationView.layer.shadowRadius = 2
        addShadow(to: microphoneBtn)
        addShadow(to: cameraBtn)
        addShadow(to: locationBtn)
        addShadow(to: notificationBtn)
        addShadow(to: setPermissionBtn)
        
    }

//    MARK: - Button Action
    @IBAction func microphoneBtnPress(_ sender: UIButton) {
    }
    
    @IBAction func cameraBtnPress(_ sender: UIButton) {
    }
    
    @IBAction func locationBtnPress(_ sender: UIButton) {
    }
    
    
    @IBAction func notificationsBtnPress(_ sender: UIButton) {
    }
    
    
    @IBAction func setPermissionBtnPress(_ sender: UIButton) {
    }
    
    @IBAction func backBtnPress(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
