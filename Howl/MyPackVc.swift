//
//  ViewController.swift
//  Howl
//
//  Created by apple on 16/08/23.
//

import UIKit

class MyPackVc: UIViewController  {
    
    //MARK: - OUTLET
    
    @IBOutlet weak var profileButtonView: UIView!
    @IBOutlet weak var notificationBtn: UIView!
    @IBOutlet weak var dogCollectionView: UICollectionView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var BANNERIMG: UIImageView!
    
    @IBOutlet weak var navigationView: UIView!
    
    //MARK: - Variable
    var interactionLayer: UIView!
    var dogArr = ["simba","Rocky", "Polly", "Monster", "Aster", "Monk", "Bella", "Marlo", "Pablo", "Bruno", "Penny"]
    
    //MARK: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.layer.shadowColor = UIColor.black.cgColor
        navigationView.layer.shadowOpacity = 0.2
        navigationView.layer.shadowOffset = CGSize(width: 0, height: 5)
        navigationView.layer.shadowRadius = 2
        tabBarItem.selectedImage = UIImage(named: "My_Pack_Selectable")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.image = UIImage(named: "My_Pack_Unslectable")
        setUpUI()
        setUpDelegate()
        registerCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - Delegate
    func setUpDelegate(){
        dogCollectionView.delegate = self
        dogCollectionView.dataSource = self
    }
    
    //MARK: - Register collectionView
    func registerCollectionView(){
        dogCollectionView.registerNib(of: DogVarietyCollectionViewCell.self)
    }
    
    //MARK: - SetupUI
    func setUpUI(){
        notificationBtn.layer.borderColor = UIColor(displayP3Red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1).cgColor
        notificationBtn.layer.borderWidth = 2.0
        notificationBtn.layer.cornerRadius = notificationBtn.frame.width/2
        notificationBtn.clipsToBounds = true
        profileButtonView.layer.borderColor = UIColor(displayP3Red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1).cgColor
        profileButtonView.layer.borderWidth = 2.0
        profileButtonView.layer.cornerRadius = notificationBtn.frame.width/2
        profileButtonView.clipsToBounds = true
        let layout = UICollectionViewFlowLayout()
        dogCollectionView.collectionViewLayout = layout
        dogCollectionView.backgroundColor = UIColor(displayP3Red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        dogCollectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    
    @IBAction func addProfileBtnPress(_ sender: UIButton) {
        let storyboard = AppStoryboard.Main.instance
        let addNewDogVc = storyboard.instantiateViewController(withIdentifier: "PersonListingVC") as! PersonListingVC
        self.navigationController?.pushViewController(addNewDogVc, animated: true)
    }
}

//MARK: - Delegate and DataSource Method

extension MyPackVc: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.getCell(indexPath: indexPath) as DogVarietyCollectionViewCell
//        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
//           let image = UIImage(named: "Add_New")
//            cell.dogImg.image = image
//            cell.dogName.text = "Add New"
//        }else{
            cell.dogImg?.image = UIImage(named: "\(dogArr[indexPath.row])")
            cell.dogName.text = dogArr[indexPath.row]
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1{
//            let storyboard = AppStoryboard.Main.instance
//            let addDogVc = storyboard.instantiateViewController(withIdentifier: "AddDogVc") as! AddDogVc
//            self.navigationController?.pushViewController(addDogVc, animated: true)
//        }
    }
}

//MARK: - DelegateFlowLayout

extension MyPackVc: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 4

           let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

           let totalSpace = flowLayout.sectionInset.left
               + flowLayout.sectionInset.right
               + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

           let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

           return CGSize(width: size, height: size)
    }
    
}
