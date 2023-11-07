//
//  ViewController.swift
//  Howl
//
//  Created by apple on 16/08/23.
//

import UIKit

class MyPackVc: UIViewController  {
    
    //MARK: - OUTLET
    
    @IBOutlet weak var monitorLocationView: UIView!
    @IBOutlet weak var viewUpdate: UIButton!
    @IBOutlet weak var profileButtonView: UIView!
    @IBOutlet weak var notificationBtn: UIView!
    @IBOutlet weak var dogCollectionView: UICollectionView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var BANNERIMG: UIImageView!
    
    @IBOutlet weak var navigationView: UIView!
    
    //MARK: - Variable
    var interactionLayer: UIView!
    var dogArr = ["simba","Rocky", "Polly", "Monster", "Aster", "Monk", "Bella", "Marlo", "Pablo", "Bruno", "Penny"]
    var instance = DogDataManager.shared
    let noDataLabel = UILabel()
    let noDataDesLbl = UILabel()
    //MARK: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.layer.shadowColor = UIColor.black.cgColor
        navigationView.layer.shadowOpacity = 0.2
        navigationView.layer.shadowOffset = CGSize(width: 0, height: 5)
        navigationView.layer.shadowRadius = 2
//        tabBarItem.selectedImage = UIImage(named: "My_Pack_Selectable")?.withRenderingMode(.alwaysOriginal)
//        tabBarItem.image = UIImage(named: "My_Pack_Unslectable")
        setUpUI()
        setUpDelegate()
        registerCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dogCollectionView.reloadData()
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = false
        let retriveVlaue = UserDefaults.standard.string(forKey: "MonitorIds")
        if retriveVlaue != nil{
            monitorLocationView.isHidden = true
        }else{
            monitorLocationView.isHidden = false
        }
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
//        profileButtonView.layer.borderColor = UIColor(displayP3Red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1).cgColor
//        profileButtonView.layer.borderWidth = 2.0
//        profileButtonView.layer.cornerRadius = profileButtonView.frame.width/2
//        profileButtonView.clipsToBounds = true
        let layout = UICollectionViewFlowLayout()
        dogCollectionView.collectionViewLayout = layout
        dogCollectionView.backgroundColor = UIColor(displayP3Red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        dogCollectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        viewUpdate.layer.cornerRadius = 5.0
        viewUpdate.clipsToBounds = true
    }
    
    
    @IBAction func monitorLocationBtnPress(_ sender: UIButton) {
        let monitorOutput = UserDefaults.standard.string(forKey: "MonitorOutPut")
        if monitorOutput != nil{
            let storyboard = AppStoryboard.Main.instance
            let trackerVc = storyboard.instantiateViewController(withIdentifier: "TrackWalkerVc") as! TrackWalkerVc
            self.navigationController?.pushViewController(trackerVc, animated: true)
        }else{
            AlertManager.sharedInstance.showAlert(title: "ID Required", message: "Set a monitoring ID by clicking the hyperlink passed to you by the dog walker when their walk began")
        }
    }
    
    
    @IBAction func addProfileBtnPress(_ sender: UIButton) {
        let storyboard = AppStoryboard.Main.instance
        let addNewDogVc = storyboard.instantiateViewController(withIdentifier: "PersonListingVC") as! PersonListingVC
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

//MARK: - Delegate and DataSource Method

extension MyPackVc: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if instance.dogs.count == 0{
            noDataLabel.text = "No Data Found"
            noDataLabel.textAlignment = .center
            noDataLabel.textColor = .gray
            noDataLabel.font = UIFont.appFont(.AileronBold, size: 20.0)
            let centerX = dogCollectionView.bounds.width / 2.0
            let centerY = dogCollectionView.bounds.height / 2.0
            let viewWidth: CGFloat = 150
            let viewHeight: CGFloat = 100
            noDataLabel.frame = CGRect(x: centerX - viewWidth / 2.0, y: centerY - viewHeight / 2.0 - 60, width: viewWidth, height: viewHeight)
            self.dogCollectionView.addSubview(noDataLabel)
            //Des Lbl
            noDataDesLbl.text = "There is no any data as for now, please add \nthe data first"
            noDataDesLbl.textAlignment = .center
            noDataDesLbl.textColor = .gray
            noDataDesLbl.numberOfLines = 2
            noDataDesLbl.font = UIFont.appFont(.AileronSemiBold, size: 14.0)
            let lblWidth: CGFloat = 340
            let lblHeight: CGFloat = 500
            noDataDesLbl.frame = CGRect(x: centerX - lblWidth / 2.0, y: centerY - lblHeight / 2.0 - 20, width: lblWidth, height: lblHeight)
            self.dogCollectionView.addSubview(noDataDesLbl)
        }else{
            noDataLabel.removeFromSuperview()
            noDataDesLbl.removeFromSuperview()
        }
        return instance.dogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.getCell(indexPath: indexPath) as DogVarietyCollectionViewCell
        cell.dogName.text = instance.dogs[indexPath.row].dogName
        if let dogImageData = instance.dogs[indexPath.row].dogImage {
            if let dogImage = UIImage(data: dogImageData) {
                cell.dogImg.image = dogImage
                
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DogDetailPopUp(nibName: DogDetailPopUp.className, bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        let item = instance.dogs[indexPath.row]
        vc.dogName = item.dogName
        vc.dogImages = item.dogImage
        vc.dob = item.dogDOB
        vc.color = item.dogColour
        vc.breed = item.dogBreed
        vc.gender = item.dogSex
        vc.type = item.dogNeuteredOrSpayed
        vc.uniqueNo = item.dogMicrochipNumber
        vc.feature = item.dogDistinctiveFeatures
        self.present(vc, animated: true)
        
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
