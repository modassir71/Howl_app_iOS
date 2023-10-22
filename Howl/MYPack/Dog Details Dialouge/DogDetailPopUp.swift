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
    @IBOutlet weak var genderTpeLbl: UILabel!
    @IBOutlet weak var uniqueNoLbl: UILabel!
    @IBOutlet weak var featureLbl: UILabel!
    
//    MARK: - Variables
    var dogName = String()
    var dogImages: Data?
    var dob = String()
    var color = String()
    var breed = String()
    var gender = String()
    var type = String()
    var uniqueNo = String()
    var feature = String()
    
//    MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _setUpUi()
    }
//    MARK: - SetUpUi
    func _setUpUi(){
        popupView.layer.cornerRadius = 10.0
        popupView.clipsToBounds = true
        dogImage.layer.cornerRadius = dogImage.frame.width/2
        dogImage.clipsToBounds = true
        dogImage.contentMode = .scaleAspectFill
        setData()
    }
    
//    MARK: - SetData
    func setData(){
        featureLbl.text = feature
        uniqueNoLbl.text = uniqueNo
        let combinedText = gender + " / " + type
        genderTpeLbl.text = combinedText
        breedLbl.text = breed
        colorLbl.text = color
        dobLbl.text = dob
        dogNameLbl.text = dogName
        if let imageData = dogImages {
            let image = UIImage(data: imageData) // Convert the image data back to a UIImage
            dogImage.image = image // Set the UIImage to the UIImageView
        }
        
    }
    
//   MARK: - Button Action
    @IBAction func cancelBtnPress(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func backBtnPress(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    
}
