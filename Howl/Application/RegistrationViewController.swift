import UIKit
import Firebase
import FirebaseMessaging

class RegistrationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTxtFld: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var phoneTxtFld: UITextField!
    @IBOutlet weak var topView: UIView!

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
        


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    @IBAction func submitBtnPress(_ sender: UIButton) {
        guard let name = nameTxtFld.text, let mobileNumber = phoneTxtFld.text else {
            return
        }

//        Messaging.messaging().token { token, error in
//            if let error = error {
//                print("Error fetching FCM token: \(error.localizedDescription)")
//                return
//            }

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
                }
            }
            let storyboard = AppStoryboard.Main.instance
            let instructionVc = storyboard.instantiateViewController(withIdentifier: "InstructionViewController") as! InstructionViewController
            self.navigationController?.pushViewController(instructionVc, animated: true)
//        }
    }

    
}
