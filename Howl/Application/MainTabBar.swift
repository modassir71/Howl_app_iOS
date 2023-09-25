//
//  CustomTabBar.swift
//  Howl
//
//  Created by apple on 24/09/23.
//

import UIKit

class MainTabBar: UITabBarController, UITabBarControllerDelegate {

    let screenHeight = UIScreen.main.bounds.size.height
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let isiPhoneSE = screenHeight <= 667 
        print("ScreenHeight", screenHeight)
        self.delegate = self
        tabBar.items?[0].title = "MY PACK"
        tabBar.items?[1].title = "HOWL"
        tabBar.items?[2].title = "MORE"
        if isiPhoneSE {
            tabBar.items?[0].selectedImage = UIImage(named: "My_Pack_Selectable")
            tabBar.items?[0].image = UIImage(named: "My_Pack_Unslectable")
            
            tabBar.items?[1].selectedImage = UIImage(named: "Howl_Selectable")
            tabBar.items?[1].image = UIImage(named: "Howl_Unslectable")
            
            tabBar.items?[2].selectedImage = UIImage(named: "More_Selectable")
            tabBar.items?[2].image = UIImage(named: "More_Unselectable")
        } else{
            tabBar.items?[0].selectedImage = UIImage(named: "MyPack_select")
            tabBar.items?[0].image = UIImage(named: "MyPack_unselect")
            
            tabBar.items?[1].selectedImage = UIImage(named: "Howl_select")
            tabBar.items?[1].image = UIImage(named: "Howl_unselect")
            
            tabBar.items?[2].selectedImage = UIImage(named: "More_select")
            tabBar.items?[2].image = UIImage(named: "More_unselect")
        }
        
    }
    
    private func createTabBarItem(title: String, imageName: String) -> UITabBarItem {
            let tabBarItem = UITabBarItem(title: title, image: UIImage(named: imageName), selectedImage: nil)
            return tabBarItem
        }
    


}
extension UITabBarItem {
    func setCustomTitlePosition(offset: UIOffset) {
        titlePositionAdjustment = offset
    }
}
