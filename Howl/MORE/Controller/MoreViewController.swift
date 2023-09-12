//
//  MoreViewController.swift
//  Howl
//
//  Created by apple on 16/08/23.
//

import UIKit

class MoreViewController: UIViewController {

//    MARK: - Outlet
    
    @IBOutlet weak var privacyBtn: UIButton!
    @IBOutlet weak var eulaBtn: UIButton!
    @IBOutlet weak var workBtn: UIButton!
    @IBOutlet weak var unarchiveBtn: UIButton!
    @IBOutlet weak var configureBtn: UIButton!
    @IBOutlet weak var permissionBtn: UIButton!
    @IBOutlet weak var howlSirenBtn: UIButton!
    @IBOutlet weak var infoTxtView: UITextView!
    @IBOutlet weak var navigationView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarItem.selectedImage = UIImage(named: "More_Selectable")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.image = UIImage(named: "More_Selectable")
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
//    MARK: - setUp Ui
    func setUpUI(){
        navigationView.layer.shadowColor = UIColor.black.cgColor
        navigationView.layer.shadowOpacity = 0.2
        navigationView.layer.shadowOffset = CGSize(width: 0, height: 5)
        navigationView.layer.shadowRadius = 2
        infoTxtView.isEditable = false
        addShadow(to: privacyBtn, cornerRadius: 10.0)
        addShadow(to: eulaBtn, cornerRadius: 10.0)
        addShadow(to: unarchiveBtn, cornerRadius: 10.0)
        addShadow(to: configureBtn, cornerRadius: 10.0)
        addShadow(to: permissionBtn, cornerRadius: 10.0)
        addShadow(to: howlSirenBtn, cornerRadius: 10.0)
        addShadow(to: workBtn, cornerRadius: 10.0)
    }
    
//    MARK: - Add shadow
    func addShadow(to Button: UIButton, cornerRadius: CGFloat){
        Button.layer.cornerRadius = cornerRadius
        Button.layer.shadowColor = UIColor.black.cgColor
        Button.layer.shadowOpacity = 0.5
        Button.layer.shadowOffset = CGSize(width: 0, height: 2)
        Button.layer.shadowRadius = 3
        Button.layer.cornerRadius = 10.0
    }

//    MARK: - Button Action
    
    @IBAction func privacyBtnPress(_ sender: UIButton) {
        let storyboard = AppStoryboard.Main.instance
        let workVc = storyboard.instantiateViewController(withIdentifier: "PolicyViewController") as! PolicyViewController
        self.navigationController?.pushViewController(workVc, animated: true)
    }
    
    @IBAction func eulaBtnPress(_ sender: UIButton) {
        let storyboard = AppStoryboard.Main.instance
        let workVc = storyboard.instantiateViewController(withIdentifier: "EulaViewController") as! EulaViewController
        self.navigationController?.pushViewController(workVc, animated: true)
    }
    
    @IBAction func workBtnPress(_ sender: UIButton) {
        let storyboard = AppStoryboard.Main.instance
        let workVc = storyboard.instantiateViewController(withIdentifier: "WorkViewController") as! WorkViewController
        self.navigationController?.pushViewController(workVc, animated: true)
    }
    
    @IBAction func unarchiveBtnPress(_ sender: UIButton) {
    }
    
    
    @IBAction func accessBtnPress(_ sender: UIButton) {
    }
    
    
    @IBAction func selectHowlSirenBtnPress(_ sender: UIButton) {
        let storyboard = AppStoryboard.Main.instance
        let workVc = storyboard.instantiateViewController(withIdentifier: "SirenViewController") as! SirenViewController
        self.navigationController?.pushViewController(workVc, animated: true)
    }
    
    @IBAction func permissonBtnPress(_ sender: UIButton) {
        let storyboard = AppStoryboard.Main.instance
        let workVc = storyboard.instantiateViewController(withIdentifier: "PermissionViewController") as! PermissionViewController
        self.navigationController?.pushViewController(workVc, animated: true)
    }
}
