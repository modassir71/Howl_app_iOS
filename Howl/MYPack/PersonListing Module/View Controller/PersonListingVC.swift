//
//  PersonListingVC.swift
//  Howl
//
//  Created by apple on 06/09/23.
//

import UIKit

class PersonListingVC: UIViewController {

//    MARK: - Outlet
    @IBOutlet weak var personListingTblView: UITableView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var addPersonBtn: UIButton!
    
    
    var peopleDataManager = AddPeopleDataManager.sharedInstance
    
//    MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _setUI()
        delegateMethod()
        registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
        personListingTblView.reloadData()
    }
    
//    MARK: - Delegate Method
    func delegateMethod(){
        personListingTblView.delegate = self
        personListingTblView.dataSource = self
    }
    
//    MARK: - Register cell
    func registerCell(){
        personListingTblView.registerNib(of: PersonListingTableViewCell.self)
    }
    
//    MARK: - Setup UI
    func _setUI(){
        navigationView.layer.shadowColor = UIColor.black.cgColor
        navigationView.layer.shadowOpacity = 0.2
        navigationView.layer.shadowOffset = CGSize(width: 0, height: 5)
        navigationView.layer.shadowRadius = 2
    }

//  MARK: - Button Action
    @IBAction func addPersonBtnPress(_ sender: UIButton) {
        let storyboard = AppStoryboard.Main.instance
        let addNewDogVc = storyboard.instantiateViewController(withIdentifier: "AddNewPersonVc") as! AddNewPersonVc
        self.navigationController?.pushViewController(addNewDogVc, animated: true)
    }
    
    
    @IBAction func backBtnPress(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension PersonListingVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleDataManager.people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.getCell() as PersonListingTableViewCell
        cell.nameLbl.text = peopleDataManager.people[indexPath.row].personName
        cell.nickNameLbl.text = peopleDataManager.people[indexPath.row].personNickname
        if let dogImageData = peopleDataManager.people[indexPath.row].personImage {
            if let dogImage = UIImage(data: dogImageData) {
                cell.profileImg.image = dogImage
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    
}
