//
//  AddNewPersonVc.swift
//  Howl
//
//  Created by apple on 04/09/23.
//

import UIKit
import SKCountryPicker
import ContactsUI
import W3WSwiftApi

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
    
//    MARK: - Variable
    var iscomeFromInstruction: Bool?
    let color = UIColor(red: 220/255, green: 2/255, blue: 65/255, alpha:  0.5)
    var dailingCode: String?
    var countryCode: String?
    var imagePicker = UIImagePickerController()
    let vm: InitialInfoDelegate = AddPersonVm()
    var personImageData: Data!
    var isEdit: Bool?
    var profileImge: Data!
    var name: String?
    var nickName: String?
    var contryCode: String?
    var phoneNumber: String?
    //    MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUPUI()
        _setData()
        _txtFldDelegates()
        _setupCountryCode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //_SetData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if iscomeFromInstruction == true{
            let alert = UIAlertController(title: DogConstantString.personAlertTitle, message: DogConstantString.personAlertMsg, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
//    MARK: - setup country code
    private func _setupCountryCode() {
        let locale = Locale.current
        let code = locale.regionCode
        let country = Country(countryCode: code ?? "")
        countryCode = code ?? ""
        countryCodeLbl.text = country.dialingCode
        dailingCode = country.dialingCode
    }
    
//    MARK: - Textfield delegates
    func _txtFldDelegates(){
        let textfield = [nickNameTxtFld, nameTxtFld, phoneNoTxtFld]
        for textField in textfield{
            textField?.delegate = self
            textField?.autocapitalizationType = .words
        }
    }
//    MARK: - SetUp ui
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
        let name = DogConstantString.name
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: color]
        let attributedPlaceholder = NSAttributedString(string: name, attributes: attributes)
        nameTxtFld.attributedPlaceholder = attributedPlaceholder
        let nickName = DogConstantString.nickName
        let attributesNickName: [NSAttributedString.Key: Any] = [.foregroundColor: color]
        let attributedNickNamePlaceHolder = NSAttributedString(string: nickName, attributes: attributesNickName)
        nickNameTxtFld.attributedPlaceholder = attributedNickNamePlaceHolder
        let phoneNo = DogConstantString.phoneNumber
        let attributesPhoneNo: [NSAttributedString.Key: Any] = [.foregroundColor: color]
        let attributedPhoneNoPlaceHolder = NSAttributedString(string: phoneNo, attributes: attributesPhoneNo)
        phoneNoTxtFld.attributedPlaceholder = attributedPhoneNoPlaceHolder
        phoneNumberView.layer.borderWidth = 1.0
        phoneNumberView.layer.borderColor = color.cgColor
        nickNameTxtFld.layer.borderWidth = 1.0
        nickNameTxtFld.layer.borderColor = color.cgColor
        contactsBtn.layer.cornerRadius = 10.0
        contactsBtn.backgroundColor = TxtFldColor.greenColor
        whatsAppBtn.layer.cornerRadius = 10.0
        createBtn.layer.cornerRadius = 10.0
        contactsBtn.clipsToBounds = true
        createBtn.backgroundColor = TxtFldColor.greenColor
        whatsAppBtn.clipsToBounds = true
        createBtn.clipsToBounds = true
        phoneNoTxtFld.keyboardType = .numberPad
        if isEdit == true{
            createBtn.setTitle(DogConstantString.update, for: .normal)
        }else{
            createBtn.setTitle(DogConstantString.create, for: .normal)
        }
        addProfileBtn.layer.cornerRadius = addProfileBtn.frame.width/2
        addProfileBtn.clipsToBounds = true
    }
    
//    MARK: - SetData
    func _setData(){
        if isEdit == true{
            if let imageData = profilePicImg {
                let image = UIImage(data: profileImge)
                 profilePicImg.image = image
            }
            nameTxtFld.text = name
            nickNameTxtFld.text = nickName
            countryCodeLbl.text = contryCode
            phoneNoTxtFld.text = phoneNumber
        }
    }
    
    //MARK: - Button Action
    
    @IBAction func contactBtnPress(_ sender: UIButton) {
        let contactPicker = CNContactPickerViewController()
               contactPicker.delegate = self
               present(contactPicker, animated: true, completion: nil)
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
            let newPerson = Person(name: nameTxtFld.text ?? "", nickname: nickNameTxtFld.text ?? "", countryCode: countryCodeLbl.text ?? "", mobileNumber: phoneNoTxtFld.text ?? "", notificationType: "WHATSAPP", image: personImageData)
            if isEdit == true {
                //Update data
                AddPeopleDataManager.sharedInstance.people.remove(at: AddPeopleDataManager.sharedInstance.selectedIndex)
                AddPeopleDataManager.sharedInstance.people.insert(newPerson, at: AddPeopleDataManager.sharedInstance.selectedIndex)
            }else{
                //Save new data
                AddPeopleDataManager.sharedInstance.people.append(newPerson)
            }
            if AddPeopleDataManager.sharedInstance.savePeople() {
          //      switch UserDefaults.standard.bool(forKey: "firstloadcompleted") {
                    
                //case true:
                if iscomeFromInstruction == true{
                    let storyboard = AppStoryboard.Main.instance
                    let sirenVc = storyboard.instantiateViewController(withIdentifier: "SirenViewController") as! SirenViewController
                    sirenVc.iscomeFromInstruction = true
                    self.navigationController?.pushViewController(sirenVc, animated: true)
                }else{
                    self.navigationController?.popViewController(animated: true)
                }
                    
//                case false:
//                    self.navigationController?.popViewController(animated: true)
//                    DispatchQueue.main.async {
//                        self.performSegue(withIdentifier: "personToSiren", sender: self)
//                    }
                  //  print("Not Saved")
               // }
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
        
       // _updateUserImage(image: image)
        picker.dismiss(animated: true,completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancel Tapped")
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
//MARK: - Textfield delegates
extension AddNewPersonVc: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTxtFld{
            resignFirstResponder()
            nickNameTxtFld.becomeFirstResponder()
        }
        if textField == nickNameTxtFld{
            resignFirstResponder()
            phoneNoTxtFld.becomeFirstResponder()
        }
        if textField == phoneNoTxtFld{
            resignFirstResponder()
        }
        return true
    }
    
}
//MARK: - Contact picker extension
extension AddNewPersonVc: CNContactPickerDelegate{
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        nameTxtFld.text = CNContactFormatter.string(from: contact, style: .fullName)

        if let phoneNumber = contact.phoneNumbers.first?.value {
            let phoneNumberString = phoneNumber.stringValue
            
            // Remove non-digit characters
            let digits = phoneNumberString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            phoneNoTxtFld.text = digits
        }

        dismiss(animated: true, completion: nil)
    }


        func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
            dismiss(animated: true, completion: nil)
        }
}
