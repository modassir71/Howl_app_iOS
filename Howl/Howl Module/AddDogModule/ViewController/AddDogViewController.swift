//
//  AddDogViewController.swift
//  Howl
//
//  Created by apple on 01/09/23.
//

import UIKit

class AddDogViewController: UIViewController {
//MARK: - Outlet
    
    @IBOutlet weak var picImgBtn: UIButton!
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
//    MARK: - Variable
    var iscomeFromInstruction: Bool?
    var imagePicker = UIImagePickerController()
    let vm: InitialDogInfoDelegate = AddDogVm()
    var dogImageData: Data!
    var isUpdate: Bool?
    var dogName: String?
    var breed: String?
    var color: String?
    var dob: String?
    var microchipDb: String?
    var microchipNumber: String?
    var feature: String?
    var profileImage: Data!
    var genderType: String?
    var dogType: String?
    let datePicker = UIDatePicker()
    var type: Bool?
//    MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateMethod()
        self.setUI()
        _setData()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
        if type == true{
            if genderType == "MALE"{
                maleBtn.setImage(UIImage(named: "radio_Btn"), for: .normal)
                femaleBtn.setImage(UIImage(named: "empt_Img"), for: .normal)
            }else{
                maleBtn.setImage(UIImage(named: "empt_Img"), for: .normal)
                femaleBtn.setImage(UIImage(named: "radio_Btn"), for: .normal)
            }
            if dogType == "INTACT"{
                inatactBtn.setImage(UIImage(named: "radio_Btn"), for: .normal)
                neuteredBtn.setImage(UIImage(named: "empt_Img"), for: .normal)
            }else{
                inatactBtn.setImage(UIImage(named: "empt_Img"), for: .normal)
                neuteredBtn.setImage(UIImage(named: "radio_Btn"), for: .normal)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if iscomeFromInstruction == true{
            let alert = UIAlertController(title: DogConstantString.dogAlertTitle, message: DogConstantString.dogAlertMsg, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
//    MARK: - TextField Delegate
    func delegateMethod(){
        let textFields = [
            microchipNumberTxtFld,
            dateOfBirthTxtFld,
            microchipDatabaseTxtFld,
            colorTxtFld,
            bredextFld,
            dogNameTxtFld,
            districtiveFeature
        ]
        for textField in textFields {
            textField?.delegate = self
            textField?.autocapitalizationType = .words
            if textField == dateOfBirthTxtFld {
                setUpDatePicker(for: dateOfBirthTxtFld)
            }
        }
    }
//    MARK: - Setup datepicker for dob
    func setUpDatePicker(for textField: UITextField) {
        if #available(iOS 13.4, *) {
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            datePicker.datePickerMode = .date
        }

        // Set maximum date to the current date to prevent selecting future dates
        datePicker.maximumDate = Date()

        textField.inputView = datePicker

        // Add a toolbar with a "Done" button to dismiss the date picker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(datePickerDoneButtonTapped))
        toolbar.setItems([doneButton], animated: false)

        textField.inputAccessoryView = toolbar
    }

    
    @objc func datePickerDoneButtonTapped() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateOfBirthTxtFld.text = dateFormatter.string(from: datePicker.date)
            dateOfBirthTxtFld.resignFirstResponder()
        }
//    MARK: - SetData
    func _setData(){
        if isUpdate == true{
            dogNameTxtFld.text = dogName
            bredextFld.text = breed
            colorTxtFld.text = color
            dateOfBirthTxtFld.text = dob
            microchipDatabaseTxtFld.text = microchipDb
            microchipNumberTxtFld.text = microchipNumber
            districtiveFeature.text = feature
            if let imageData = profileImage {
                let image = UIImage(data: profileImage)
                profileImg.image = image
            }
        }
    }
//    MARK: - Set up UI
   func setUI(){
        navigationView.layer.shadowColor = UIColor.black.cgColor
        navigationView.layer.shadowOpacity = 0.2
        navigationView.layer.shadowOffset = CGSize(width: 0, height: 5)
        navigationView.layer.shadowRadius = 2
        profileImg.layer.cornerRadius = profileImg.frame.width/2
        profileImg.layer.borderColor = TxtFldColor.primaryColor.cgColor
        profileImg.layer.borderWidth = 1
        profileImg.clipsToBounds = true
        createBtn.layer.cornerRadius = 10.0
        createBtn.backgroundColor = TxtFldColor.greenColor
        customizeTxtFld(to: dogNameTxtFld, string: DogConstantString.dogName)
        customizeTxtFld(to: bredextFld, string: DogConstantString.breed)
        customizeTxtFld(to: colorTxtFld, string: DogConstantString.color)
        customizeTxtFld(to: dateOfBirthTxtFld, string: DogConstantString.dob)
        customizeTxtFld(to: microchipNumberTxtFld, string: DogConstantString.microchipNumber)
        customizeTxtFld(to: microchipDatabaseTxtFld, string: DogConstantString.microchipDatabase)
        customizeTxtFld(to: districtiveFeature, string: DogConstantString.distrinctiveFeature)
        femaleBtn.setImage(UIImage(named: "empt_Img"), for: .normal)
        maleBtn.setImage(UIImage(named: "empt_Img"), for: .normal)
        inatactBtn.setImage(UIImage(named: "empt_Img"), for: .normal)
        neuteredBtn.setImage(UIImage(named: "empt_Img"), for: .normal)
       picImgBtn.layer.cornerRadius = picImgBtn.frame.width/2
       picImgBtn.clipsToBounds = true
       if isUpdate == true{
           createBtn.setTitle(DogConstantString.update, for: .normal)
       }else{
           createBtn.setTitle(DogConstantString.create, for: .normal)
       }
       colorTxtFld.placeholder = "Colour"
       microchipNumberTxtFld.placeholder = "Microchip Number"
       districtiveFeature.placeholder = "Distinctive Features"
       
    }
//    MARK: - Customize text field
    func customizeTxtFld(to txtFld: UITextField, string: String){
        txtFld.layer.borderColor = TxtFldColor.primaryColor.cgColor
        txtFld.layer.borderWidth = 1
        txtFld.layer.cornerRadius = 5.0
        txtFld.textColor = .black//TxtFldColor.secondaryColor
        txtFld.tintColor = .black
        let attributes = [NSAttributedString.Key.foregroundColor: TxtFldColor.primaryColor]
        txtFld.attributedPlaceholder = NSAttributedString(string: string, attributes: attributes)
    }
//MARK: - Button Action
    @IBAction func addProfilePicBtn(_ sender: UIButton) {
       // openActionSheetForUploadImage()
        let permissionManager = PermissionManager.shared
            
            let alertController = UIAlertController(
                title: "Choose Image Source",
                message: nil,
                preferredStyle: .actionSheet
            )
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
                permissionManager.requestCameraPermission { granted in
                    if granted {
                        self.openCamera()
                    } else {
                        // Handle denied access
                        print("Camera access denied.")
                    }
                }
            }
            
            let galleryAction = UIAlertAction(title: "Gallery", style: .default) { _ in
                permissionManager.requestGalleryPermission { granted in
                    if granted {
                        self.openGallary()
                    } else {
                        // Handle denied access
                        print("Gallery access denied.")
                    }
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }

            alertController.addAction(cameraAction)
            alertController.addAction(galleryAction)
            alertController.addAction(cancelAction)

            present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func backBtnPress(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func maleBtnPress(_ sender: UIButton) {
        maleBtn.setImage(UIImage(named: "radio_Btn"), for: .normal)
        femaleBtn.setImage(UIImage(named: "empt_Img"), for: .normal)
        genderType = "MALE"
    }
    
    
    @IBAction func intactBtnPress(_ sender: UIButton) {
        inatactBtn.setImage(UIImage(named: "radio_Btn"), for: .normal)
        neuteredBtn.setImage(UIImage(named: "empt_Img"), for: .normal)
        dogType = "INTACT"
        
    }
    
    
    
    @IBAction func femaleBtnPress(_ sender: UIButton) {
        femaleBtn.setImage(UIImage(named: "radio_Btn"), for: .normal)
        maleBtn.setImage(UIImage(named: "empt_Img"), for: .normal)
        genderType = "FEMALE"
        
    }
    
    
    @IBAction func neuteredBtnPress(_ sender: UIButton) {
        neuteredBtn.setImage(UIImage(named: "radio_Btn"), for: .normal)
        inatactBtn.setImage(UIImage(named: "empt_Img"), for: .normal)
        dogType = "SPAYED"
    }
    
    
    @IBAction func createdBtnOPress(_ sender: UIButton) {
        let validationResult = vm.initialDogInfoVlaidate(dogName: dogNameTxtFld.text ?? "", breed: bredextFld.text ?? "", color: colorTxtFld.text ?? "", gender: genderType ?? "", type: dogType ?? "")
        let status = validationResult.0
        let message = validationResult.1
            if status == true{
                createDog()
            }else{
                alert("Alert", message: message)
            }
    }
    
//    MARK: - Create a Dog
    func createDog(){
        if let dogImage = profileImg.image {
            
            dogImageData = dogImage.jpegData(compressionQuality: 1)
        } else {
            dogImageData = Data()
        }
        let newDog = Dog(name: dogNameTxtFld.text ?? "", sex: genderType ?? "" , breed: bredextFld.text ?? "", colour: colorTxtFld.text ?? "", dob: dateOfBirthTxtFld.text ?? "", neuteredOrSpayed: dogType ?? "" , distinctiveFeatures: districtiveFeature.text ?? "", microchipNumber: microchipNumberTxtFld.text ?? "", microchipSupplier: microchipDatabaseTxtFld.text ?? "", stolen: false, image: dogImageData, incident: [WalkFetch]())
        if isUpdate == true{
            DogDataManager.shared.dogs.remove(at: DogDataManager.shared.selectedIndex)
            DogDataManager.shared.dogs.insert(newDog, at: DogDataManager.shared.selectedIndex)
            print(DogDataManager.shared.selectedIndex!)
        }else{
            DogDataManager.shared.dogs.append(newDog)
        }
       
        if DogDataManager.shared.saveDogs() {
            
           // switch UserDefaults.standard.bool(forKey: "firstloadcompleted") {
                
          //  case true:
            if iscomeFromInstruction == true{
                let storyboard = AppStoryboard.Main.instance
                let peopleVc = storyboard.instantiateViewController(withIdentifier: "AddNewPersonVc") as! AddNewPersonVc
                peopleVc.iscomeFromInstruction = iscomeFromInstruction
                self.navigationController?.pushViewController(peopleVc, animated: true)
            }else{
                self.navigationController?.popViewController(animated: true)
            }
                
         //   case false:
              //  print("Not Added Error")
          //  }
        }else{
            print("Eroor")
        }
        
    }
}
//MARK: - ImagePicker delegate method extension
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
        DispatchQueue.main.async {
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
               
            }
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
//MARK: - Textfield extension
extension AddDogViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == dogNameTxtFld{
            textField.resignFirstResponder()
            bredextFld.becomeFirstResponder()
        }
        if textField == bredextFld{
            textField.resignFirstResponder()
        }
        if textField == colorTxtFld{
            textField.resignFirstResponder()
           dateOfBirthTxtFld.becomeFirstResponder()
        }
        if textField == dateOfBirthTxtFld{
            textField.resignFirstResponder()
            microchipDatabaseTxtFld.becomeFirstResponder()
        }
        if textField == microchipDatabaseTxtFld{
            textField.resignFirstResponder()
            microchipNumberTxtFld.becomeFirstResponder()
        }
        if textField == microchipNumberTxtFld{
            textField.resignFirstResponder()
            districtiveFeature.becomeFirstResponder()
        }
        if textField == districtiveFeature{
            textField.resignFirstResponder()
        }
        return true
    }
}
