//
//  AddNewDogVc.swift
//  Howl
//
//  Created by apple on 30/08/23.
//

import UIKit
import IQKeyboardManagerSwift

class AddNewDogVc: UIViewController, UITextFieldDelegate {
//    MARK: - Outlet
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var colorTxtFld: UITextField!
    @IBOutlet weak var distinctiveTxtFld: UITextField!
    @IBOutlet weak var microchipNumberTxtFld: UITextField!
    @IBOutlet weak var microchipDatabaseTypeTxtFld: UITextField!
    @IBOutlet weak var dobTxtFld: UITextField!
    @IBOutlet weak var breedTxtFld: UITextField!
    @IBOutlet weak var dogNameTxtFld: UITextField!
    @IBOutlet weak var neuteredBtn: UIButton!
    @IBOutlet weak var intactBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var addProfileImg: UIImageView!
    
//    MARK: - variable
    var imagePicker = UIImagePickerController()
//    MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _setUi()
        txtFldDeleagte()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
//MARK: - TextField Delegates
    func txtFldDeleagte(){
        colorTxtFld.delegate = self
        distinctiveTxtFld.delegate = self
        microchipNumberTxtFld.delegate = self
        microchipDatabaseTypeTxtFld.delegate = self
        dobTxtFld.delegate = self
        breedTxtFld.delegate = self
        dogNameTxtFld.delegate = self
    }
//MARK: - Setup UI
    func _setUi(){
        navigationBarView.layer.shadowColor = UIColor.black.cgColor
        navigationBarView.layer.shadowOpacity = 0.5
        navigationBarView.layer.shadowOffset = CGSize(width: 0, height: 5)
        navigationBarView.layer.shadowRadius = 5
        createBtn.layer.cornerRadius = 5.0
        createBtn.clipsToBounds = true
        addProfileImg.layer.cornerRadius = 10.0
        addProfileImg.clipsToBounds = true
    }
    
//MARK: - Button Action
    
    @IBAction func backBtnPress(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func createBtnPress(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func maleBtnPress(_ sender: Any) {
        maleBtn.setImage(UIImage(named: "radio_Btn"), for: .normal)
        femaleBtn.setImage(UIImage(named: "empt_Img"), for: .normal)
    }
    
    @IBAction func femaleBtnPress(_ sender: UIButton) {
        femaleBtn.setImage(UIImage(named: "radio_Btn"), for: .normal)
        maleBtn.setImage(UIImage(named: "empt_Img"), for: .normal)
    }
    
    @IBAction func intactBtnPress(_ sender: UIButton) {
        intactBtn.setImage(UIImage(named: "radio_Btn"), for: .normal)
        neuteredBtn.setImage(UIImage(named: "empt_Img"), for: .normal)
    }
    
    
    @IBAction func sprayedBtnPress(_ sender: UIButton) {
        neuteredBtn.setImage(UIImage(named: "radio_Btn"), for: .normal)
        intactBtn.setImage(UIImage(named: "empt_Img"), for: .normal)
    }
    
    
    @IBAction func addPrfilePicBtnPress(_ sender: UIButton) {
        openActionSheetForUploadImage()
    }
}
//MARK: - ImagePicker Extension
extension AddNewDogVc: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            addProfileImg.image = image
        }
        else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            image = img
            addProfileImg.image = image
        }
        
      //  _updateUserImage(image: image)
        picker.dismiss(animated: true,completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancel Tapped")
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
