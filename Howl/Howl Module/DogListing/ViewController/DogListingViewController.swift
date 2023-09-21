//
//  DogListingViewController.swift
//  Howl
//
//  Created by apple on 20/09/23.
//

import UIKit

class DogListingViewController: UIViewController {

//  MARK:- Outlet
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var dogTblView: UITableView!
    
    var instance  = DogDataManager.shared
//    MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _setUI()
        _delegateMethod()
        registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dogTblView.reloadData()
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
        return instance.dogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.getCell() as PersonListingTableViewCell
        let items = instance.dogs[indexPath.row]
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
                                          message: DogConstantString.warningMsg,
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

    
    
}
