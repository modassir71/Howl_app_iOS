//
//  RegistrationViewController.swift
//  Howl
//
//  Created by apple on 21/11/23.
//
import UIKit
import Firebase
//import FirebaseMessaging


class RegistrationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTxtFld: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var phoneTxtFld: UITextField!
    @IBOutlet weak var topView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        topView.layer.shadowColor = UIColor.black.cgColor
        topView.layer.shadowOpacity = 0.2
        topView.layer.shadowOffset = CGSize(width: 0, height: 5)
        topView.layer.shadowRadius = 2
        nameTxtFld.delegate = self
        phoneTxtFld.delegate = self
        submitBtn.layer.cornerRadius = 10.0
        submitBtn.clipsToBounds = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    @IBAction func submitBtnPress(_ sender: UIButton) {
        
        // Navigate to the next view controller
        let storyboard = AppStoryboard.Main.instance
        let instructionVc = storyboard.instantiateViewController(withIdentifier: "InstructionViewController") as! InstructionViewController
        self.navigationController?.pushViewController(instructionVc, animated: true)
    }
    
}
