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
import Firebase

class AddNewPersonVc: UIViewController {
    //MARK: - Outlet
    
    @IBOutlet weak var dropDownBtn: UIButton!
    @IBOutlet weak var countryCodeLbl: UILabel!
    @IBOutlet weak var phoneNumberView: UIView!
//    @IBOutlet weak var nickNameTxtFld: UITextField!
    @IBOutlet weak var nameTxtFld: UITextField!
    @IBOutlet weak var addProfileBtn: UIButton!
    @IBOutlet weak var profilePicImg: UIImageView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var whatsAppBtn: UIButton!
    
    @IBOutlet weak var txtMsgBtn: UIButton!
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
    var messageType: String?
    var senderType: String?
    var type: Bool?
    //    MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUPUI()
        _setData()
        _txtFldDelegates()
        _setupCountryCode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        whatsAppBtn.setImage(UIImage(named: "empt_Img"), for: .normal)
        txtMsgBtn.setImage(UIImage(named: "empt_Img"), for: .normal)
        if type == true{
            messageType = senderType
            if senderType == "WHATSAPP"{
                whatsAppBtn.setImage(UIImage(named: "radio_Btn"), for: .normal)
                txtMsgBtn.setImage(UIImage(named: "empt_Img"), for: .normal)
            }else{
                whatsAppBtn.setImage(UIImage(named: "empt_Img"), for: .normal)
                txtMsgBtn.setImage(UIImage(named: "radio_Btn"), for: .normal)
            }
        }
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
        let textfield = [nameTxtFld, phoneNoTxtFld]
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
       // nickNameTxtFld.attributedPlaceholder = attributedNickNamePlaceHolder
        let phoneNo = DogConstantString.phoneNumber
        let attributesPhoneNo: [NSAttributedString.Key: Any] = [.foregroundColor: color]
        let attributedPhoneNoPlaceHolder = NSAttributedString(string: phoneNo, attributes: attributesPhoneNo)
        phoneNoTxtFld.attributedPlaceholder = attributedPhoneNoPlaceHolder
        phoneNumberView.layer.borderWidth = 1.0
        phoneNumberView.layer.borderColor = color.cgColor
//        nickNameTxtFld.layer.borderWidth = 1.0
//        nickNameTxtFld.layer.borderColor = color.cgColor
        contactsBtn.layer.cornerRadius = 10.0
        contactsBtn.backgroundColor = TxtFldColor.greenColor
      //  whatsAppBtn.layer.cornerRadius = 10.0
        createBtn.layer.cornerRadius = 10.0
        contactsBtn.clipsToBounds = true
        createBtn.backgroundColor = TxtFldColor.greenColor
//      whatsAppBtn.clipsToBounds = true
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
//            nickNameTxtFld.text = nickName
            countryCodeLbl.text = contryCode
            phoneNoTxtFld.text = phoneNumber
        }
    }
    
    //MARK: - Button Action
    
    @IBAction func contactBtnPress(_ sender: UIButton) {
        let contactStore = CNContactStore()

            switch CNContactStore.authorizationStatus(for: .contacts) {
            case .authorized:
                showContactPicker()
            case .notDetermined:
                contactStore.requestAccess(for: .contacts) { [weak self] (granted, error) in
                    if granted {
                        self?.showContactPicker()
                    } else {
                        // Handle denied access
                        print("Access to contacts denied.")
                    }
                }
            case .denied, .restricted:
                // Handle denied or restricted access
                print("Access to contacts denied or restricted.")
            @unknown default:
                break
            }
    }
    
    func showContactPicker() {
        DispatchQueue.main.async {
            let contactPicker = CNContactPickerViewController()
            contactPicker.delegate = self
            self.present(contactPicker, animated: true, completion: nil)
        }
    }

    
    @IBAction func whatsappBtnPress(_ sender: UIButton) {
        messageType = "WHATSAPP"
        whatsAppBtn.setImage(UIImage(named: "radio_Btn"), for: .normal)
        txtMsgBtn.setImage(UIImage(named: "empt_Img"), for: .normal)
//        sender.isSelected = !sender.isSelected
//        if nameTxtFld.text == ""{
//            AlertManager.sharedInstance.showAlert(title: "Howl", message: "You should first enter your name")
//        }else if phoneNoTxtFld.text == ""{
//            AlertManager.sharedInstance.showAlert(title: "Howl", message: "You should first enter your phone number")
//        }else{
//            if sender.isSelected {
//                whatsAppBtn.backgroundColor = ColorConstant.greenColor
//                messageType = "WHATSAPP"
//            }else{
//                whatsAppBtn.backgroundColor = ColorConstant.pinkColor
//                messageType = "iMessage"
//            }
//
//        }
    }
    
    
    @IBAction func textBtnPress(_ sender: UIButton) {
        messageType = "iMessage"
        whatsAppBtn.setImage(UIImage(named: "empt_Img"), for: .normal)
        txtMsgBtn.setImage(UIImage(named: "radio_Btn"), for: .normal)
    }
    
    
    @IBAction func createBtnPress(_ sender: UIButton) {
        checkMobileNumberExists(phoneNoTxtFld.text ?? "") { exists in
            if exists {
                let validationResult = self.vm.initialBasicInfoVlaidate(name: self.nameTxtFld.text ?? "", mobileNumber: self.phoneNoTxtFld.text ?? "", notificationType: self.messageType ?? "")
                let status = validationResult.0
                let message = validationResult.1
                if status == true{
                    if let personImage = self.profilePicImg.image {
                        self.personImageData = personImage.jpegData(compressionQuality: 1)
                    } else {
                        self.personImageData = Data()
                    }
                    if self.messageType == nil{
                        self.messageType = "iMessage"
                    }
                    print("PhoneNumber", self.messageType!)
                    let newPerson = Person(name: self.nameTxtFld.text ?? "", countryCode: self.countryCodeLbl.text ?? "", mobileNumber: self.phoneNoTxtFld.text ?? "", notificationType: self.messageType ?? "", image: self.personImageData)
                    if self.isEdit == true {
                        //Update data
                        print(AddPeopleDataManager.sharedInstance.selectedIndex!)
                        AddPeopleDataManager.sharedInstance.people.remove(at: AddPeopleDataManager.sharedInstance.selectedIndex)
                        AddPeopleDataManager.sharedInstance.people.insert(newPerson, at: AddPeopleDataManager.sharedInstance.selectedIndex)
                    }else{
                        //Save new data
                        AddPeopleDataManager.sharedInstance.people.append(newPerson)
                    }
                    if AddPeopleDataManager.sharedInstance.savePeople() {
                        //      switch UserDefaults.standard.bool(forKey: "firstloadcompleted") {
                        
                        //case true:
                        if self.iscomeFromInstruction == true{
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
                    self.alert("Alert", message: message)
                }
            }else{
                self.alert("Howl", message: "Number not registered")
            }
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
    
    func checkMobileNumberExists(_ mobileNumber: String, completion: @escaping (Bool) -> Void) {
        let dbRef = Database.database().reference().child("users")
        
        dbRef.child(mobileNumber).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
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
            phoneNoTxtFld.becomeFirstResponder()
        }
        if textField == phoneNoTxtFld{
            resignFirstResponder()
            //phoneNoTxtFld.becomeFirstResponder()
        }
//        if textField == phoneNoTxtFld{
//            resignFirstResponder()
//        }
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
