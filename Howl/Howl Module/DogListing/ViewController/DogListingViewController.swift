//
//  DogListingViewController.swift
//  Howl
//
//  Created by apple on 20/09/23.
//

import UIKit
import Lottie

class DogListingViewController: UIViewController {

//  MARK:- Outlet
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var dogTblView: UITableView!
    @IBOutlet weak var addDogBtn: UIButton!
    @IBOutlet weak var animationContainer: UIView!
    //    MARK: - Variable
        var animationView = LottieAnimationView()
        var instance  = DogDataManager.shared
    //    MARK: - Life cycle
        override func viewDidLoad() {
            super.viewDidLoad()
            _setUI()
            _delegateMethod()
            registerCell()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            tabBarController?.tabBar.isHidden = true
            dogTblView.reloadData()
            floatingBtn()
            //updateView()
        }
        
    //    MARK: - Floating Buttton
        func floatingBtn(){
            let floatingButton = UIButton(type: .custom)
            floatingButton.setTitle("Tap", for: .normal)
            floatingButton.setImage(UIImage(named: "Plus_Img"), for: .normal)
            floatingButton.setTitleColor(.white, for: .normal)
            floatingButton.backgroundColor = UIColor(displayP3Red: 221.0/255.0, green: 0/255.0, blue: 65.0/255.0, alpha: 1.0)
            floatingButton.layer.cornerRadius = 30
            if isiPhoneSE(){
                floatingButton.frame = CGRect(x: 295, y: 570, width: 60, height: 60)
            }else{
                floatingButton.frame = CGRect(x: 300, y: 700, width: 60, height: 60)
            }
            floatingButton.layer.shadowColor = UIColor.black.cgColor
            floatingButton.layer.shadowOffset = CGSize(width: 0, height: 4)
            floatingButton.layer.shadowOpacity = 0.3
            floatingButton.layer.shadowRadius = 4
            floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
            view.addSubview(floatingButton)
        }
        
        @objc func floatingButtonTapped() {
            let storyboard = AppStoryboard.Main.instance
            let addNewDogVc = storyboard.instantiateViewController(withIdentifier: "AddDogViewController") as! AddDogViewController
            self.navigationController?.pushViewController(addNewDogVc, animated: true)
            }
    //MARK: - Delegates confirm
        func _delegateMethod(){
            dogTblView.delegate = self
            dogTblView.dataSource = self
        }
        
        //    MARK: - Register cell
            func registerCell(){
                dogTblView.registerNib(of: PersonListingTableViewCell.self)
            }
        
    //    MARK: - SetUp UI
        func _setUI(){
            navigationView.layer.shadowColor = UIColor.black.cgColor
            navigationView.layer.shadowOpacity = 0.2
            navigationView.layer.shadowOffset = CGSize(width: 0, height: 5)
            navigationView.layer.shadowRadius = 2
            addDogBtn.isHidden = true
            
        }
    //MARK: - Button Action
        @IBAction func backBtnPress(_ sender: UIButton) {
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        @IBAction func addDogBtnPress(_ sender: Any) {
            let storyboard = AppStoryboard.Main.instance
            let addNewDogVc = storyboard.instantiateViewController(withIdentifier: "AddDogViewController") as! AddDogViewController
            self.navigationController?.pushViewController(addNewDogVc, animated: true)
        }
        
    }

    //MARK: - Delegates and datsource method
    extension DogListingViewController: UITableViewDelegate, UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if instance.dogs.count == 0{
                animationViewStart()
                animationContainer.isHidden = false
            }else{
                animationView.removeFromSuperview()
                animationContainer.isHidden = true
            }
            return instance.dogs.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.getCell() as PersonListingTableViewCell
            let items = instance.dogs[indexPath.row]
            self.animationView.isHidden = true
            cell.nameTitle.text = DogConstantString.breedName
            cell.nickNameTitle.text = DogConstantString.dog
            cell.nickNameLbl.text = items.dogName
            cell.nameLbl.text = items.dogBreed
            if let dogImageData = items.dogImage {
                if let dogImage = UIImage(data: dogImageData) {
                    cell.profileImg.image = dogImage
                }
            }
            return cell
        }

        
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            var delete: UIContextualAction!
            var swipeActions = [UIContextualAction]()
            var edit: UIContextualAction!
            //var status: UIContextualAction!
            delete = UIContextualAction(style: .normal, title: DogConstantString.deleteTitle) {  (contextualAction, view, boolValue) in
                
                let alert = UIAlertController(title: DogConstantString.warningTitle,
                                              message: DogConstantString.warningMsg,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: DogConstantString.proceedTitle,
                                              style: .default,
                                              handler: { _ in
                    self.deleteDog(index: indexPath.row)
                }))
                self.present(alert, animated: true, completion: nil)
                
            }
            edit = UIContextualAction(style: .normal, title: "Edit") {  (contextualAction, view, boolValue) in
                
                let alert = UIAlertController(title: DogConstantString.warningTitle,
                                              message: DogConstantString.editMsg,
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
                
                alert.addAction(UIAlertAction(title: DogConstantString.proceedTitle,
                                              style: .default,
                                              handler: { _ in
                    let storyBoard = AppStoryboard.Main.instance
                    let editDogVc = storyBoard.instantiateViewController(withIdentifier: "AddDogViewController") as! AddDogViewController
                    let items = self.instance.dogs[indexPath.row]
                    self.instance.selectedIndex = indexPath.row
                    editDogVc.isUpdate = true
                    editDogVc.dogName = items.dogName
                    editDogVc.profileImage =  items.dogImage
                    editDogVc.breed = items.dogBreed
                    editDogVc.color = items.dogColour
                    editDogVc.dob = items.dogDOB
                    editDogVc.microchipDb = items.dogMicrochipSupplier
                    editDogVc.microchipNumber = items.dogMicrochipNumber
                    editDogVc.feature = items.dogDistinctiveFeatures
                    editDogVc.genderType = items.dogSex
                    editDogVc.dogType = items.dogNeuteredOrSpayed
                    print(items.dogSex ?? "")
                    print(items.dogNeuteredOrSpayed ?? "")
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(editDogVc, animated: true)
                    }
                }))
                self.present(alert, animated: true, completion: nil)
             //   edit.backgroundColor = UIColor.lightGray
            }
            delete.backgroundColor = UIColor.red
            edit.backgroundColor = UIColor.lightGray
            
            
            swipeActions = [delete, edit]
            
            return UISwipeActionsConfiguration(actions: swipeActions)
        }
        
        func deleteDog(index: Int!){
            instance.dogs.remove(at: index)
            if !instance.saveDogs() == true {
                let alert = UIAlertController(title: DogConstantString.peopleDeleteErrorTitle, message: DogConstantString.peopleDeleteError, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            dogTblView.reloadData()
        }
        
        func animationViewStart(){
            let jsonName = "dogData"
            let animation = LottieAnimation.named(jsonName)
            animationView = LottieAnimationView(animation: animation)
            let centerX = view.bounds.width / 2.0
            let centerY = view.bounds.height / 2.0
            let viewWidth: CGFloat = 225
            let viewHeight: CGFloat = 225
            animationView.frame = CGRect(x: centerX - viewWidth / 2.0, y: centerY - viewHeight / 2.0, width: viewWidth, height: viewHeight)
            animationView.contentMode = .scaleAspectFill
            animationView.backgroundColor = .white
            animationView.loopMode = .loop
            animationView.animationSpeed = 1
            self.animationContainer.addSubview(animationView)
            animationView.play()
        }
        
        
    }
