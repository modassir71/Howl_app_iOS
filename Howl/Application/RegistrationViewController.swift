import UIKit
import Firebase
import FirebaseMessaging

class RegistrationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTxtFld: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var phoneTxtFld: UITextField!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var containerView: UIStackView!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var setUpBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    var istrue: Bool?
    
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
        let namePlaceholderText = "Name"
               let attributes0: [NSAttributedString.Key: Any] = [
                .foregroundColor: ColorConstant.pinkColor,
                   .font: UIFont.systemFont(ofSize: 14)
               ]
               nameTxtFld.attributedPlaceholder = NSAttributedString(string: namePlaceholderText, attributes: attributes0)
        let phonePlaceholderText = "Phone Number"
               let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: ColorConstant.pinkColor,
                   .font: UIFont.systemFont(ofSize: 14)
               ]
               phoneTxtFld.attributedPlaceholder = NSAttributedString(string: phonePlaceholderText, attributes: attributes)
        nameTxtFld.layer.cornerRadius = 2.0
        nameTxtFld.layer.borderColor = ColorConstant.pinkColor.cgColor
        nameTxtFld.layer.borderWidth = 1.0
        phoneTxtFld.layer.cornerRadius = 2.0
        phoneTxtFld.layer.borderColor = ColorConstant.pinkColor.cgColor
        phoneTxtFld.layer.borderWidth = 1.0
        phoneTxtFld.keyboardType = .numberPad
        skipBtn.layer.cornerRadius = 5.0
        skipBtn.clipsToBounds = true
        setUpBtn.layer.cornerRadius = 5.0
        setUpBtn.clipsToBounds = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        if istrue == true{
            containerView.isHidden = true
            backBtn.isHidden = false
        }else{
            containerView.isHidden = false
            backBtn.isHidden = true
        }
    }

    @IBAction func submitBtnPress(_ sender: UIButton) {
        sendDataToDb()
    }
    
    func sendDataToDb(){
        guard let name = nameTxtFld.text, let mobileNumber = phoneTxtFld.text else {
            return
        }
        if nameTxtFld.text == ""{
            AlertManager.sharedInstance.showAlert(title: "HOWL", message: "Please enter your name")
            return
        }
        if phoneTxtFld.text == ""{
            AlertManager.sharedInstance.showAlert(title: "HOWL", message: "Please enter your phone number")
            return
        }
        let token = UserDefaults.standard.string(forKey: "FirebaseToken")
            let user = [
                "name": name,
                "number": mobileNumber,
                "token": token ?? "simulated_firebase_token"
            ]
            let userRef = Database.database().reference().child("users").child(mobileNumber)
            userRef.setValue(user) { error, _ in
                if let error = error {
                    print("Error writing user data to Firebase: \(error.localizedDescription)")
                } else {
                    print("User data successfully written to Firebase")
                    let alert = UIAlertController(title: "HOWL",
                                                  message: "Profile created successfully",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
                        let storyboard = AppStoryboard.Main.instance
                        let instructionVc = storyboard.instantiateViewController(withIdentifier: "InstructionViewController") as! InstructionViewController
                        if self.istrue == true{
                            self.navigationController?.popViewController(animated: true)
                        }else{
                            self.navigationController?.pushViewController(instructionVc, animated: true)
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
    }
    
    @IBAction func skipBtnPress(_ sender: UIButton) {
        let storyboard = AppStoryboard.Main.instance
        let permissionVc = storyboard.instantiateViewController(withIdentifier: "InstructionViewController") as! InstructionViewController
        self.navigationController?.pushViewController(permissionVc, animated: true)
    }
    
    @IBAction func setUpBtnPress(_ sender: UIButton) {
        sendDataToDb()
    }
    
    @IBAction func backBtnPress(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
