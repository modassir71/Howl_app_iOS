//
//  InstructionViewController.swift
//  Howl
//
//  Created by apple on 20/09/23.
//

import UIKit

class InstructionViewController: UIViewController {
//MARK: - Outlet
    @IBOutlet weak var setupBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var instructionTxtView: UITextView!
    @IBOutlet weak var navigationView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        _setUi()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        let screenHeight = UIScreen.main.bounds.size.height
        let isiPhoneSE = screenHeight <= 667
        if isiPhoneSE {
           self.tabBarController?.tabBar.frame.size.height = 47
           // print(self.tabBarController?.tabBar.frame.size.height)
        }else{
            self.tabBarController?.tabBar.frame.size.height = 100
        }
    }
//    MARK: - SetUp UI
    func _setUi(){
        navigationView.layer.shadowColor = UIColor.black.cgColor
        navigationView.layer.shadowOpacity = 0.2
        navigationView.layer.shadowOffset = CGSize(width: 0, height: 5)
        navigationView.layer.shadowRadius = 2
        instructionTxtView.text = DogConstantString.howlInstruction
        skipBtn.layer.cornerRadius = 10.0
        skipBtn.clipsToBounds = true
        setupBtn.layer.cornerRadius = 10.0
        skipBtn.clipsToBounds = true
    }
//    MARK: - Button Action
    @IBAction func skipBtnPress(_ sender: UIButton) {
        let storyboard = AppStoryboard.Main.instance
        let permissionVc = storyboard.instantiateViewController(withIdentifier: "PermissionViewController") as! PermissionViewController
        self.navigationController?.pushViewController(permissionVc, animated: true)
    }
    
    
    @IBAction func setUpBtnPress(_ sender: UIButton) {
        let storyboard = AppStoryboard.Main.instance
        let vc = storyboard.instantiateViewController(withIdentifier: "AddDogViewController") as! AddDogViewController
        vc.iscomeFromInstruction = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

}
