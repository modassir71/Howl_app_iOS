//
//  AddDogViewController.swift
//  Howl
//
//  Created by apple on 01/09/23.
//

import UIKit

class AddDogViewController: UIViewController {

    @IBOutlet weak var districtiveFeature: UITextField!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var microchipNumberTxtFld: UITextField!
    @IBOutlet weak var dateOfBirthTxtFld: UITextField!
    @IBOutlet weak var microchipDatabaseTxtFld: UITextField!
    @IBOutlet weak var colorTxtFld: UITextField!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var neuteredBtn: UIButton!
    @IBOutlet weak var inatactBtn: UIButton!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var bredextFld: UITextField!
    @IBOutlet weak var dogNameTxtFld: UITextField!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var navigationView: UIView!
    
    var imagePicker = UIImagePickerController()
    let color = UIColor(red: 220/255, green: 2/255, blue: 65/255, alpha: 0.5)
    let color3 = UIColor(red: 220/255, green: 2/255, blue: 65/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.setUI()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
    }
   
   func setUI(){
        navigationView.layer.shadowColor = UIColor.black.cgColor
        navigationView.layer.shadowOpacity = 0.2
        navigationView.layer.shadowOffset = CGSize(width: 0, height: 5)
        navigationView.layer.shadowRadius = 2
        profileImg.layer.cornerRadius = profileImg.frame.width/2
        profileImg.layer.borderColor = UIColor(red: 220/255, green: 2/255, blue: 65/255, alpha:  0.5).cgColor
        profileImg.layer.borderWidth = 1
        profileImg.clipsToBounds = true
        createBtn.layer.cornerRadius = 10.0
        dogNameTxtFld.layer.borderColor = UIColor(red: 220/255, green: 2/255, blue: 65/255, alpha:  0.5).cgColor
        dogNameTxtFld.layer.borderWidth = 1.0
        dogNameTxtFld.layer.cornerRadius = 5.0
        bredextFld.layer.borderColor = UIColor(red: 220/255, green: 2/255, blue: 65/255, alpha:  0.5).cgColor
        bredextFld.layer.borderWidth = 1.0
        bredextFld.layer.cornerRadius = 5.0
        colorTxtFld.layer.borderColor = UIColor(red: 220/255, green: 2/255, blue: 65/255, alpha:  0.5).cgColor
        colorTxtFld.layer.borderWidth = 1.0
        colorTxtFld.layer.cornerRadius = 5.0
        dateOfBirthTxtFld.layer.borderColor = UIColor(red: 220/255, green: 2/255, blue: 65/255, alpha:  0.5).cgColor
        dateOfBirthTxtFld.layer.borderWidth = 1.0
        dateOfBirthTxtFld.layer.cornerRadius = 5.0
        microchipDatabaseTxtFld.layer.borderColor = UIColor(red: 220/255, green: 2/255, blue: 65/255, alpha:  0.5).cgColor
        microchipDatabaseTxtFld.layer.borderWidth = 1.0
        microchipDatabaseTxtFld.layer.cornerRadius = 5.0
        microchipNumberTxtFld.layer.borderColor = UIColor(red: 220/255, green: 2/255, blue: 65/255, alpha:  0.5).cgColor
        microchipNumberTxtFld.layer.borderWidth = 1.0
        microchipNumberTxtFld.layer.cornerRadius = 5.0
        districtiveFeature.layer.borderColor = UIColor(red: 220/255, green: 2/255, blue: 65/255, alpha:  0.5).cgColor
        districtiveFeature.layer.borderWidth = 1.0
        districtiveFeature.layer.cornerRadius = 5.0
        dogNameTxtFld.textColor = color3
        bredextFld.textColor = color3
        colorTxtFld.textColor = color3
        dateOfBirthTxtFld.textColor = color3
        microchipDatabaseTxtFld.textColor = color3
        microchipNumberTxtFld.textColor = color3
        districtiveFeature.textColor = color3
        let dog = "Dog Name"
        let breed = "Breed"
        let color1 = "Color"
        let dob = "Date of Birth"
        let microchipNumber = "Microchip Number"
        let microchipDatabase = "Microchip Database"
        let districtiveFeaturee = "Districtive Feature"
        let attributes = [NSAttributedString.Key.foregroundColor: color]
        dogNameTxtFld.attributedPlaceholder = NSAttributedString(string: dog, attributes: attributes)
        let attributes1 = [NSAttributedString.Key.foregroundColor: color]
        bredextFld.attributedPlaceholder = NSAttributedString(string: breed, attributes: attributes1)
        let attributes2 = [NSAttributedString.Key.foregroundColor: color]
        colorTxtFld.attributedPlaceholder = NSAttributedString(string: color1, attributes: attributes2)
        let attributes3 = [NSAttributedString.Key.foregroundColor: color]
        dateOfBirthTxtFld.attributedPlaceholder = NSAttributedString(string: dob, attributes: attributes3)
        let attributes4 = [NSAttributedString.Key.foregroundColor: color]
        microchipNumberTxtFld.attributedPlaceholder = NSAttributedString(string: microchipNumber, attributes: attributes4)
        let attributes5 = [NSAttributedString.Key.foregroundColor: color]
        microchipDatabaseTxtFld.attributedPlaceholder = NSAttributedString(string: microchipDatabase, attributes: attributes5)
        let attributes6 = [NSAttributedString.Key.foregroundColor: color]
        districtiveFeature.attributedPlaceholder = NSAttributedString(string: districtiveFeaturee, attributes: attributes6)
       femaleBtn.setImage(UIImage(named: "empt_Img"), for: .normal)
       maleBtn.setImage(UIImage(named: "empt_Img"), for: .normal)
       inatactBtn.setImage(UIImage(named: "empt_Img"), for: .normal)
       neuteredBtn.setImage(UIImage(named: "empt_Img"), for: .normal)
    }

    @IBAction func addProfilePicBtn(_ sender: UIButton) {
        openActionSheetForUploadImage()
    }
    
    
    @IBAction func backBtnPress(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func maleBtnPress(_ sender: UIButton) {
        maleBtn.setImage(UIImage(named: "radio_Btn"), for: .normal)
        femaleBtn.setImage(UIImage(named: "empt_Img"), for: .normal)
    }
    
    
    @IBAction func intactBtnPress(_ sender: UIButton) {
        inatactBtn.setImage(UIImage(named: "radio_Btn"), for: .normal)
        neuteredBtn.setImage(UIImage(named: "empt_Img"), for: .normal)
    }
    
    
    
    @IBAction func femaleBtnPress(_ sender: UIButton) {
        femaleBtn.setImage(UIImage(named: "radio_Btn"), for: .normal)
        maleBtn.setImage(UIImage(named: "empt_Img"), for: .normal)
    }
    
    
    @IBAction func neuteredBtnPress(_ sender: UIButton) {
        neuteredBtn.setImage(UIImage(named: "radio_Btn"), for: .normal)
        inatactBtn.setImage(UIImage(named: "empt_Img"), for: .normal)
    }
    
    
    @IBAction func createdBtnOPress(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
//    @IBAction func backBtnPress(_ sender: UIButton) {
//        self.navigationController?.popViewController(animated: true)
//    }
}
extension AddDogViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openActionSheetForUploadImage(){
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default){
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default){
            UIAlertAction in
            self.openGallary()
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel){
            UIAlertAction in
        }
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
       // alert.addAction(removeImageAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
           
        }
    }
    
    func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image : UIImage!
        
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            image = img
            profileImg.image = image
        }
        else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            image = img
            profileImg.image = image
        }
        
      //  _updateUserImage(image: image)
        picker.dismiss(animated: true,completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancel Tapped")
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
