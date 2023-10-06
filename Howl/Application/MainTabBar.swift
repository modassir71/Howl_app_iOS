//
//  CustomTabBar.swift
//  Howl
//
//  Created by apple on 24/09/23.
//

import UIKit

class MainTabBar: UITabBarController, UITabBarControllerDelegate {

    let screenHeight = UIScreen.main.bounds.size.height
   // let hasAppLaunchedBeforeKey = "HasAppLaunchedBefore"

    override func viewDidLoad() {
        super.viewDidLoad()
//        let hasAppLaunchedBefore = UserDefaults.standard.bool(forKey: hasAppLaunchedBeforeKey)
        let isiPhoneSE = screenHeight <= 667 
        print("ScreenHeight", screenHeight)
        self.delegate = self
        setTabBar()
        tabBar.backgroundColor = .white
    }
    
    private func createTabBarItem(title: String, imageName: String) -> UITabBarItem {
            let tabBarItem = UITabBarItem(title: title, image: UIImage(named: imageName), selectedImage: nil)
            return tabBarItem
        }
    
    func setTabBar(){
        tabBar.items?[0].title = StringConstant.mypack_Tab
        tabBar.items?[1].title = StringConstant.howl_Tab
        tabBar.items?[2].title = StringConstant.more_Tab
        if isiPhoneSE() {
            tabBar.items?[0].selectedImage = UIImage(named: ImageStringConstant.myPackSelectable)
            tabBar.items?[0].image = UIImage(named: ImageStringConstant.myPackUnselectable)
            
            tabBar.items?[1].selectedImage = UIImage(named: ImageStringConstant.howlSelectable)
            tabBar.items?[1].image = UIImage(named: ImageStringConstant.howlUnselectable)
            
            tabBar.items?[2].selectedImage = UIImage(named: ImageStringConstant.moreSelectable)
            tabBar.items?[2].image = UIImage(named: ImageStringConstant.moreUnselectable)
        } else{
            tabBar.items?[0].selectedImage = UIImage(named: ImageStringConstant.myPackSelectable_Icon)
            tabBar.items?[0].image = UIImage(named: ImageStringConstant.myPackUnselectable_Icon)
            
            tabBar.items?[1].selectedImage = UIImage(named: ImageStringConstant.howlSelectable_Icon)
            tabBar.items?[1].image = UIImage(named: ImageStringConstant.howlUnselectable_Icon)
            
            tabBar.items?[2].selectedImage = UIImage(named: ImageStringConstant.moreSelectable_Icon)
            tabBar.items?[2].image = UIImage(named: ImageStringConstant.moreUnselectable_Icon)
        }
        tabBar.tintColor = .black
    }
    


}
extension UITabBarItem {
    func setCustomTitlePosition(offset: UIOffset) {
        titlePositionAdjustment = offset
    }
}
