//
//  AddDogViewController.swift
//  Howl
//
//  Created by apple on 01/09/23.
//

import UIKit

class AddDogViewController: UIViewController {
//MARK: - Outlet
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
    var imagePicker = UIImagePickerController()
    let vm: InitialDogInfoDelegate = AddDogVm()
    var dogImageData: Data!
//    MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateMethod()
        self.setUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
    }
//    MARK: - TextField Delegate
    func delegateMethod(){
        districtiveFeature.delegate = self
        microchipDatabaseTxtFld.delegate = self
        dateOfBirthTxtFld.delegate = self
        microchipNumberTxtFld.delegate = self
        colorTxtFld.delegate = self
        bredextFld.delegate = self
        dogNameTxtFld.delegate = self
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
        customizeTxtFld(to: dogNameTxtFld, string: DogConstantString.dogName)
        customizeTxtFld(to: bredextFld, string: DogConstantString.breed)
        customizeTxtFld(to: colorTxtFld, string: DogConstantString.color)
        customizeTxtFld(to: dateOfBirthTxtFld, string: DogConstantString.dob)
        customizeTxtFld(to: microchipNumberTxtFld, string: DogConstantString.microchipNumber)
        customizeTxtFld(to: microchipDatabaseTxtFld, string: DogConstantString.microchipDatabase)
        customizeTxtFld(to: districtiveFeature, string: DogConstantString.distrinctiveFeature)
        femaleBtn.setImage(UIImage(named: "empt_Img"), for: .normal)
        maleBtn.setImage(UIImage(named: "radio_Btn"), for: .normal)
        inatactBtn.setImage(UIImage(named: "radio_Btn"), for: .normal)
        neuteredBtn.setImage(UIImage(named: "empt_Img"), for: .normal)
    }
//    MARK: - Customize text field
    func customizeTxtFld(to txtFld: UITextField, string: String){
        txtFld.layer.borderColor = TxtFldColor.primaryColor.cgColor
        txtFld.layer.borderWidth = 1
        txtFld.layer.cornerRadius = 5.0
        txtFld.textColor = TxtFldColor.secondaryColor
        let attributes = [NSAttributedString.Key.foregroundColor: TxtFldColor.primaryColor]
        txtFld.attributedPlaceholder = NSAttributedString(string: string, attributes: attributes)
    }
//MARK: - Button Action
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
        let validationResult = vm.initialDogInfoVlaidate(dogName: dogNameTxtFld.text ?? "", breed: bredextFld.text ?? "", color: colorTxtFld.text ?? "", dob: dogNameTxtFld.text ?? "", microchipDb: microchipDatabaseTxtFld.text ?? "", microchipNo: microchipNumberTxtFld.text ?? "", districtiveFeature: districtiveFeature.text ?? "")
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
        let newDog = Dog(name: dogNameTxtFld.text ?? "", sex: "Male", breed: bredextFld.text ?? "", colour: colorTxtFld.text ?? "", dob: dateOfBirthTxtFld.text ?? "", neuteredOrSpayed: true, distinctiveFeatures: districtiveFeature.text ?? "", microchipNumber: microchipNumberTxtFld.text ?? "", microchipSupplier: microchipDatabaseTxtFld.text ?? "", stolen: false, image: dogImageData, incident: [WalkUpdate]())
        DogDataManager.shared.dogs.append(newDog)
        if DogDataManager.shared.saveDogs() {
            
            switch UserDefaults.standard.bool(forKey: "firstloadcompleted") {
                
            case true:
                
                self.navigationController?.popViewController(animated: true)
                
            case false:
                print("Not Added Error")
            }
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
