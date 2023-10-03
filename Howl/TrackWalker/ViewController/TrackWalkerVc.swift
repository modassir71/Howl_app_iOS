//
//  TrackWalkerVc.swift
//  Howl
//
//  Created by apple on 01/10/23.
//

import UIKit
import CarbonKit

class TrackWalkerVc: UIViewController, CarbonTabSwipeNavigationDelegate {

//  MARK: - Outlet
    @IBOutlet weak var navigationView: UIView!
    
    @IBOutlet weak var carbonKitView: UIView!
    
    
    var carbonTabSwipeNavigation: CarbonTabSwipeNavigation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: ["Walker Status", "Walker Map"], delegate: self)
        carbonTabSwipeNavigation.setTabExtraWidth(90)
        self.carbonKitView.addSubview(carbonTabSwipeNavigation.view)
        carbonTabSwipeNavigation.setIndicatorColor(UIColor(displayP3Red: 222.0/255.0, green: 0/255.0, blue: 68.0/255.0, alpha: 1.0))
        carbonTabSwipeNavigation.setSelectedColor(.black, font: UIFont.boldSystemFont(ofSize: 14))
        carbonTabSwipeNavigation.setNormalColor(.gray, font: UIFont.systemFont(ofSize: 13))
        navigationView.layer.shadowColor = UIColor.black.cgColor
        navigationView.layer.shadowOpacity = 0.2
        navigationView.layer.shadowOffset = CGSize(width: 0, height: 5)
        navigationView.layer.shadowRadius = 2
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    
    @IBAction func backBtnPress(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        var selectedViewController = UIViewController()
        let storyboard = AppStoryboard.Main.instance
        if index == 0{
            selectedViewController = storyboard.instantiateViewController(withIdentifier: "WalkerStatusVc") as! WalkerStatusVc
        }else{
            selectedViewController = storyboard.instantiateViewController(withIdentifier: "WalkerMapVc") as! WalkerMapVc
        }
        
        return selectedViewController
       }

    
    

}
