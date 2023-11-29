//
//  MoreViewController.swift
//  Howl
//
//  Created by apple on 16/08/23.
//

import UIKit

class MoreViewController: UIViewController {

//    MARK: - Outlet
    
    @IBOutlet weak var monitorLocationView: UIButton!
    @IBOutlet weak var privacyBtn: UIButton!
    @IBOutlet weak var eulaBtn: UIButton!
    //@IBOutlet weak var tipsBtn: UIButton!
    
   // @IBOutlet weak var shopBtn: UIButton!
    @IBOutlet weak var unarchiveBtn: UIButton!
    @IBOutlet weak var configureBtn: UIButton!
    @IBOutlet weak var permissionBtn: UIButton!
    @IBOutlet weak var howlSirenBtn: UIButton!
    @IBOutlet weak var infoTxtView: UITextView!
    @IBOutlet weak var navigationView: UIView!
    
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var profileView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tabBarItem.selectedImage = UIImage(named: "More_Selectable")?.withRenderingMode(.alwaysOriginal)
//        tabBarItem.image = UIImage(named: "More_Selectable")
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = false
        let retriveVlaue = UserDefaults.standard.string(forKey: "MonitorIds")
        if retriveVlaue != nil{
            monitorLocationView.isHidden = true
        }else{
            monitorLocationView.isHidden = false
        }
    }
    
//    MARK: - setUp Ui
    func setUpUI(){
        navigationView.layer.shadowColor = UIColor.black.cgColor
        navigationView.layer.shadowOpacity = 0.2
        navigationView.layer.shadowOffset = CGSize(width: 0, height: 5)
        navigationView.layer.shadowRadius = 2
        infoTxtView.isEditable = false
        let buttons: [UIButton] = [privacyBtn, eulaBtn, unarchiveBtn, configureBtn, permissionBtn, howlSirenBtn, profileBtn]
        for button in buttons {
            button.layer.cornerRadius = 10.0
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
            button.layer.shadowRadius = 4.0
            button.layer.shadowOpacity = 0.2
        }
        
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
    
    @IBAction func tipsBtnPress(_ sender: UIButton) {
        let newViewController = TipsViewController(nibName: "TipsViewController", bundle: nil)
               self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    
    @IBAction func shopBtnPress(_ sender: UIButton) {
        let newViewController = ShopVc(nibName: "ShopVc", bundle: nil)
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    
    @IBAction func accessBtnPress(_ sender: UIButton) {
        if let appSettingsURL = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(appSettingsURL) {
                UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
            }
        }
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
    
    
    @IBAction func monitorLocationBtnPress(_ sender: UIButton) {
        let monitorOutput = UserDefaults.standard.string(forKey: "MonitorOutPut")
        if monitorOutput != nil{
            let storyboard = AppStoryboard.Main.instance
            let trackerVc = storyboard.instantiateViewController(withIdentifier: "TrackWalkerVc") as! TrackWalkerVc
            self.navigationController?.pushViewController(trackerVc, animated: true)
        }else{
            AlertManager.sharedInstance.showAlert(title: "ID Required", message: "Set a monitoring ID by clicking the hyperlink passed to you by the dog walker when their walk began")
        }
    }
    
    @IBAction func profileBtnPress(_ sender: UIButton) {
        let storyboard = AppStoryboard.Main.instance
        let vc = storyboard.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
        vc.istrue = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
