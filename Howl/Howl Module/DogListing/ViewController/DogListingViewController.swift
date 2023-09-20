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
    

    
    
}
