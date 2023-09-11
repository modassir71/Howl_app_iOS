//
//  DogDetailPopUp.swift
//  Howl
//
//  Created by apple on 11/09/23.
//

import UIKit

class DogDetailPopUp: UIViewController {
//    MARK: - Outlet
    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var breedLbl: UILabel!
    @IBOutlet weak var colorLbl: UILabel!
    @IBOutlet weak var dobLbl: UILabel!
    @IBOutlet weak var dogNameLbl: UILabel!
    
    
//    MARK: - Variables
    var dogName = String()
    
//    MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _setUpUi()
    }
//    MARK: - SetUpUi
    func _setUpUi(){
        popupView.layer.cornerRadius = 10.0
        popupView.clipsToBounds = true
        dogNameLbl.text = dogName
        dogImage.image = UIImage(named: dogName)
    }
    
//   MARK: - Button Action
    @IBAction func cancelBtnPress(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func backBtnPress(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    
}
