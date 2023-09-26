//
//  HowlViewController.swift
//  Howl
//
//  Created by apple on 16/08/23.
//

import UIKit
import Lottie

class HowlViewController: UIViewController {
//MARK: - Outlet
    
    @IBOutlet weak var navigationView: UIView!
    
    @IBOutlet weak var dogVarietyCollectionView: UICollectionView!
    @IBOutlet weak var addNewDogBtn: UIButton!
    @IBOutlet weak var arrowIcons: UIImageView!
   // @IBOutlet weak var petTitle: UILabel!
    @IBOutlet weak var petImageView: UIImageView!
    
    //MARK: - Variable
    let dataManager = DogDataManager.shared
    var dogVarietyArr = ["simba","Rocky", "Polly", "Monster", "Aster", "Monk", "Bella", "Marlo", "Pablo", "Bruno", "Penny"]
    let screenHeight = UIScreen.main.bounds.size.height
    let hasAppLaunchedBeforeKey = "HasAppLaunchedBefore"
   
    
    //MARK: - LIfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
       instructionVc()
        animationView()
        registerCollectionView()
        delegateMethod()
        _SetUpUi()
  }
    
    override func viewWillAppear(_ animated: Bool) {
//       tabBarItem.image = UIImage(named: "Howl_Selectable")
        self.tabBarController?.tabBar.isHidden = false
        dogVarietyCollectionView.reloadData()
        
    }
    
    override func viewWillLayoutSubviews() {
        let isiPhoneSE = screenHeight <= 667
        if isiPhoneSE {
           self.tabBarController?.tabBar.frame.size.height = 47
            print(self.tabBarController?.tabBar.frame.size.height)
        }else{
            self.tabBarController?.tabBar.frame.size.height = 100
        }
    }
    
//    MARK: - Launch Instruction VC
    func instructionVc(){
        let hasAppLaunchedBefore = UserDefaults.standard.bool(forKey: hasAppLaunchedBeforeKey)
      //  if !hasAppLaunchedBefore {
            let storyboard = AppStoryboard.Main.instance
            let instructionVc = storyboard.instantiateViewController(withIdentifier: "InstructionViewController") as! InstructionViewController
           // instructionVc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(instructionVc, animated: true)
//            UserDefaults.standard.set(true, forKey: hasAppLaunchedBeforeKey)
//        }else{
//            print("Same controller")
//        }
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
    
    @IBAction func addNewDog(_ sender: UIButton) {
        let storyboard = AppStoryboard.Main.instance
        let addNewDogVc = storyboard.instantiateViewController(withIdentifier: "DogListingViewController") as! DogListingViewController
        self.navigationController?.pushViewController(addNewDogVc, animated: true)
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
        let storyboard = AppStoryboard.Main.instance
        let dogWalkingVC = storyboard.instantiateViewController(withIdentifier: "DogWalkingViewController") as! DogWalkingViewController
        let item = dataManager.dogs[indexPath.row]
        dogWalkingVC.dogNameLbl = item.dogName
        dogWalkingVC.dogImgItem = item.dogImage
         
        self.navigationController?.pushViewController(dogWalkingVC, animated: true)
    }
}

//MARK: - DelegateFlowLayout

extension HowlViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 4.8) - 2, height: (collectionView.frame.height))
    }
}
