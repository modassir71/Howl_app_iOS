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
        DispatchQueue.main.async {
            self.setLayoutOfTopSegmentBar()
        }
        
    }
    
    fileprivate func setLayoutOfTopSegmentBar(){
        let items = ["Walker Status","Walker Map"]
        let carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items, delegate: self)
        carbonTabSwipeNavigation.setIndicatorColor(UIColor(displayP3Red: 222.0/255.0, green: 0/255.0, blue: 68.0/255.0, alpha: 1.0))
        carbonTabSwipeNavigation.setNormalColor(.gray, font: UIFont.systemFont(ofSize: 13))
        carbonTabSwipeNavigation.setSelectedColor(.black, font: UIFont.boldSystemFont(ofSize: 14))
      //  carbonTabSwipeNavigation.toolbar.barTintColor = UIColor.white//UIColor(rgb: 0xF8823C)
        carbonTabSwipeNavigation.setTabBarHeight(CGFloat(50))
        carbonTabSwipeNavigation.setIndicatorHeight(CGFloat(1.5))
        carbonTabSwipeNavigation.setNormalColor(UIColor.black, font: .boldSystemFont(ofSize: 13))
       // carbonTabSwipeNavigation.setTabExtraWidth(150)
        let width = UIScreen.main.bounds.size.width/2
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(width, forSegmentAt: 0)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(width, forSegmentAt: 1)
        carbonTabSwipeNavigation.insert(intoRootViewController: self, andTargetView: carbonKitView)
        _setUI()
       }
    
    func _setUI(){
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
