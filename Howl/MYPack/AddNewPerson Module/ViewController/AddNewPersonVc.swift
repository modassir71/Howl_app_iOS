//
//  AddNewPersonVc.swift
//  Howl
//
//  Created by apple on 04/09/23.
//

import UIKit
import SKCountryPicker

class AddNewPersonVc: UIViewController {
    //MARK: - Outlet
    @IBOutlet weak var dropDownBtn: UIButton!
    @IBOutlet weak var countryCodeLbl: UILabel!
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var nickNameTxtFld: UITextField!
    @IBOutlet weak var nameTxtFld: UITextField!
    @IBOutlet weak var addProfileBtn: UIButton!
    @IBOutlet weak var profilePicImg: UIImageView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var whatsAppBtn: UIButton!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var contactsBtn: UIButton!
    @IBOutlet weak var phoneNoTxtFld: UITextField!
    
    let color = UIColor(red: 220/255, green: 2/255, blue: 65/255, alpha:  0.5)
    var dailingCode: String?
    var countryCode: String?
    var imagePicker = UIImagePickerController()
    let vm: InitialInfoDelegate = AddPersonVm()
    var personImageData: Data!
    //    MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUPUI()
        
    }
    
    func setUPUI(){
        navigationView.layer.shadowColor = UIColor.black.cgColor
        navigationView.layer.shadowOpacity = 0.2
        navigationView.layer.shadowOffset = CGSize(width: 0, height: 5)
        navigationView.layer.shadowRadius = 2
        profilePicImg.layer.cornerRadius = profilePicImg.frame.width/2
        profilePicImg.layer.borderColor = UIColor(red: 220/255, green: 2/255, blue: 65/255, alpha:  0.5).cgColor
        profilePicImg.layer.borderWidth = 1
        profilePicImg.clipsToBounds = true
        nameTxtFld.layer.borderWidth = 1
        nameTxtFld.layer.borderColor = color.cgColor
        let name = "Name"
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: color]
        let attributedPlaceholder = NSAttributedString(string: name, attributes: attributes)
        nameTxtFld.attributedPlaceholder = attributedPlaceholder
        let nickName = "Nick Name"
        let attributesNickName: [NSAttributedString.Key: Any] = [.foregroundColor: color]
        let attributedNickNamePlaceHolder = NSAttributedString(string: nickName, attributes: attributesNickName)
        nickNameTxtFld.attributedPlaceholder = attributedNickNamePlaceHolder
        let phoneNo = "Phone Number"
        let attributesPhoneNo: [NSAttributedString.Key: Any] = [.foregroundColor: color]
        let attributedPhoneNoPlaceHolder = NSAttributedString(string: phoneNo, attributes: attributesPhoneNo)
        phoneNoTxtFld.attributedPlaceholder = attributedPhoneNoPlaceHolder
        phoneNumberView.layer.borderWidth = 1.0
        phoneNumberView.layer.borderColor = color.cgColor
        nickNameTxtFld.layer.borderWidth = 1.0
        nickNameTxtFld.layer.borderColor = color.cgColor
        contactsBtn.layer.cornerRadius = 10.0
        whatsAppBtn.layer.cornerRadius = 10.0
        createBtn.layer.cornerRadius = 10.0
        contactsBtn.clipsToBounds = true
        whatsAppBtn.clipsToBounds = true
        createBtn.clipsToBounds = true
        phoneNoTxtFld.keyboardType = .numberPad
        
    }
    
    //MARK: - Button Action
    
    @IBAction func contactBtnPress(_ sender: UIButton) {
    }
    
    @IBAction func whatsappBtnPress(_ sender: UIButton) {
    }
    
    
    @IBAction func createBtnPress(_ sender: UIButton) {
        let validationResult = vm.initialBasicInfoVlaidate(name: nameTxtFld.text ?? "", nickName: nickNameTxtFld.text ?? "", mobileNumber: phoneNoTxtFld.text ?? "")
        let status = validationResult.0
        let message = validationResult.1
        if status == true{
            if let personImage = profilePicImg.image {
                
                personImageData = personImage.jpegData(compressionQuality: 1)
            } else {
                personImageData = Data()
            }
            let newPerson = Person(name: nameTxtFld.text ?? "", nickname: nickNameTxtFld.text ?? "", countryDialCode: countryCodeLbl.text ?? "", countryCode: countryCodeLbl.text ?? "", mobileNumber: phoneNoTxtFld.text ?? "", notificationType: "WHATSAPP", image: personImageData)
            AddPeopleDataManager.sharedInstance.people.append(newPerson)
            if AddPeopleDataManager.sharedInstance.savePeople() {
                switch UserDefaults.standard.bool(forKey: "firstloadcompleted") {
                    
                case true:
                    
                    self.navigationController?.popViewController(animated: true)
                    
                case false:
//                    DispatchQueue.main.async {
//                        self.performSegue(withIdentifier: "personToSiren", sender: self)
//                    }
                    print("Not Saved")
                }
            }else{
                print("Error")
            }
           
        }else{
            alert("Alert", message: message)
        }
        
    }
    
    @IBAction func backBtnPress(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addProfilePic(_ sender: UIButton) {
        openActionSheetForUploadImage()
    }
    
    
    @IBAction func countryCodeBtnPress(_ sender: UIButton) {
        let countryPickerVC = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country) in
            guard let self = self else { return }
            self.countryCodeLbl.text = country.dialingCode
            self.dailingCode = country.dialingCode
            self.countryCode = country.countryCode
            self.phoneNoTxtFld.becomeFirstResponder()
        }
      //countryPickerVC.detailColor = UIColor.red
        
        
    }
}
extension AddNewPersonVc: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            profilePicImg.image = image
        }
        else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            image = img
            profilePicImg.image = image
        }
        
      //  _updateUserImage(image: image)
        picker.dismiss(animated: true,completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancel Tapped")
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
