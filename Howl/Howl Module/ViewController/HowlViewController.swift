//
//  HowlViewController.swift
//  Howl
//
//  Created by apple on 16/08/23.
//

import UIKit
import Lottie
import Firebase

class HowlViewController: UIViewController {
//MARK: - Outlet
    
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var monitorLocationBtn: UIButton!
    
    @IBOutlet weak var dogVarietyCollectionView: UICollectionView!
    @IBOutlet weak var addNewDogBtn: UIButton!
    @IBOutlet weak var arrowIcons: UIImageView!
   // @IBOutlet weak var petTitle: UILabel!
    @IBOutlet weak var petImageView: UIImageView!
    
    //MARK: - Variable
    let dataManager = DogDataManager.shared
    var dogVarietyArr = ["simba","Rocky", "Polly", "Monster", "Aster", "Monk", "Bella", "Marlo", "Pablo", "Bruno", "Penny"]
    var selectedDogIndex: Int?
    
   
    
    //MARK: - LIfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
       instructionVc()
        animationView()
        registerCollectionView()
        delegateMethod()
        _SetUpUi()
        let databaseRef = Database.database().reference().child("your_data_node")

        databaseRef.observe(.childAdded) { snapshot in
            if let data = snapshot.value as? [String: Any],
               let walkID = data["walkID"] as? String {
                print("Walk ID: \(walkID)")
                self.dataManager.walkMonitor = walkID
//                self.walkMonitor = walkID
                //kDataManager.walkId = walkID
            }
        }
  }
    
    override func viewWillAppear(_ animated: Bool) {
//       tabBarItem.image = UIImage(named: "Howl_Selectable")
        self.tabBarController?.tabBar.isHidden = false
        dogVarietyCollectionView.reloadData()
        let retriveVlaue = UserDefaults.standard.string(forKey: "MonitorIds")
        if retriveVlaue != nil {
            monitorLocationBtn.isHidden = true
        }else{
            monitorLocationBtn.isHidden = false
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        let screenHeight = UIScreen.main.bounds.size.height
        let isiPhoneSE = screenHeight <= 667
        if isiPhoneSE {
           self.tabBarController?.tabBar.frame.size.height = 47
           // print(self.tabBarController?.tabBar.frame.size.height)
        }else{
            self.tabBarController?.tabBar.frame.size.height = 100
        }
    }
    
//    MARK: - Launch Instruction VC
    func instructionVc(){
        let hasAppLaunchedBefore = UserDefaults.standard.bool(forKey: StringConstant.hasAppLaunchedBeforeKey)
        if !hasAppLaunchedBefore {
            let storyboard = AppStoryboard.Main.instance
            let instructionVc = storyboard.instantiateViewController(withIdentifier: "InstructionViewController") as! InstructionViewController
            self.navigationController?.pushViewController(instructionVc, animated: true)
            
        }else{
            print("Same controller")
        }
    }
    
    //MARK: - Delegate Method
    func delegateMethod(){
        dogVarietyCollectionView.delegate = self
        dogVarietyCollectionView.dataSource = self
    }
    
    //MARK: - Datasource Method
    func registerCollectionView(){
        dogVarietyCollectionView.registerNib(of: NewDogVarietyCell.self)
    }
    
    //MARK: - SetupUI
    
    func _SetUpUi(){
        navigationView.layer.shadowColor = UIColor.black.cgColor
        navigationView.layer.shadowOpacity = 0.2
        navigationView.layer.shadowOffset = CGSize(width: 0, height: 5)
        navigationView.layer.shadowRadius = 2
        let layout = UICollectionViewFlowLayout()
        dogVarietyCollectionView.collectionViewLayout = layout
        let layoutCollectionView = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
      //  dogVarietyCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    }
    
    //MARK: - Animation
    func animationView(){
        let jsonName = "animation_1"
        let animation = LottieAnimation.named(jsonName)
        let animationView = LottieAnimationView(animation: animation)
        if isSmallDevice() {
            animationView.frame = CGRect(x: 45, y: -35, width: 315, height: 280)
        }else{
            animationView.frame = CGRect(x: 50, y: 25, width: 315, height: 280)
        }
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        petImageView.addSubview(animationView)
        animationView.play()
    }
    
    //MARK: - Device Extension
    func isSmallDevice() -> Bool {
           let screenSize = UIScreen.main.bounds.size
           let maxWidth: CGFloat = 375
           
           return screenSize.width <= maxWidth
       }
    
    //MARK: -Button Action
    
    @IBAction func trackDogBtn(_ sender: UIButton) {
       // let retrive = UserDefaults.standard.string(forKey: "WalkIDs")
        
//        if retrive != nil{
        let monitorme = UserDefaults.standard.string(forKey: "MonitorIds")
        let monitorOutput = UserDefaults.standard.string(forKey: "MonitorOutPut")
        
        if  monitorOutput != nil{
            let storyboard = AppStoryboard.Main.instance
            let trackerVc = storyboard.instantiateViewController(withIdentifier: "TrackWalkerVc") as! TrackWalkerVc
            self.navigationController?.pushViewController(trackerVc, animated: true)
        }else{
            AlertManager.sharedInstance.showAlert(title: "ID Required", message: "Set a monitoring ID by clicking the hyperlink passed to you by the dog walker when their walk began")
        }
    }
    
    
    @IBAction func addNewDog(_ sender: UIButton) {
        let storyboard = AppStoryboard.Main.instance
        let addNewDogVc = storyboard.instantiateViewController(withIdentifier: "DogListingViewController") as! DogListingViewController
        self.navigationController?.pushViewController(addNewDogVc, animated: true)
    }
    
    
    @IBAction func shopBtnPress(_ sender: Any) {
        let newViewController = ShopVc(nibName: "ShopVc", bundle: nil)
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    
    @IBAction func tipsBtnPress(_ sender: UIButton) {
        let newViewController = TipsViewController(nibName: "TipsViewController", bundle: nil)
               self.navigationController?.pushViewController(newViewController, animated: true)
    }
    

}
//MARK: - Delegates and datsource Method
extension HowlViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return dataManager.dogs.count
       // return dogVarietyArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.getCell(indexPath: indexPath) as NewDogVarietyCell
        if let dogImageData = dataManager.dogs[indexPath.row].dogImage {
            if let dogImage = UIImage(data: dogImageData) {
                cell.dogImgView.image = dogImage
            }
        }
        cell.dogNameLbl.text = dataManager.dogs[indexPath.row].dogName
//        cell.dogImgView?.image = UIImage(named: "\(dogVarietyArr[indexPath.row])")
//        cell.dogNameLbl.text = dogVarietyArr[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedDogIndex == indexPath.row {
            let storyboard = AppStoryboard.Main.instance
            let dogWalkingVC = storyboard.instantiateViewController(withIdentifier: "DogWalkingViewController") as! DogWalkingViewController
            let item = dataManager.dogs[indexPath.row]
            dogWalkingVC.dogNameLbl = item.dogName
            dogWalkingVC.index = selectedDogIndex
            dogWalkingVC.dogImgItem = item.dogImage
            
            self.navigationController?.pushViewController(dogWalkingVC, animated: true)
        } else {
            selectedDogIndex = indexPath.row
            if let retriveValue = UserDefaults.standard.string(forKey: "MonitorIds") {
                AlertManager.sharedInstance.showAlert(title: "HOWL", message: "You already have an active walk")
            } else {
                let storyboard = AppStoryboard.Main.instance
                let dogWalkingVC = storyboard.instantiateViewController(withIdentifier: "DogWalkingViewController") as! DogWalkingViewController
                let item = dataManager.dogs[indexPath.row]
                dogWalkingVC.dogNameLbl = item.dogName
                dogWalkingVC.dogImgItem = item.dogImage
                dogWalkingVC.index = selectedDogIndex
                self.navigationController?.pushViewController(dogWalkingVC, animated: true)
            }
        }
    }
}

//MARK: - DelegateFlowLayout

extension HowlViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isiPhoneSE(){
            return CGSize(width: (collectionView.frame.width / 4.3) - 2, height: (collectionView.frame.height))
        }else{
            return CGSize(width: (collectionView.frame.width / 4.5) - 2, height: (collectionView.frame.height))
        }
       
    }
}
