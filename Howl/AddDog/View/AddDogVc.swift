//
//  AddDogVc.swift
//  Howl
//
//  Created by apple on 29/08/23.
//

import UIKit

class AddDogVc: UIViewController {
    
//MARK: - Outlet
    @IBOutlet weak var dogTblView: UITableView!
    @IBOutlet weak var peopleTitle: UILabel!
    @IBOutlet weak var swipeUpPersonTile: UILabel!
    @IBOutlet weak var swipeUpTile: UILabel!
    @IBOutlet weak var dogTitleLbl: UILabel!
    @IBOutlet weak var addDogBtn: UIButton!
    @IBOutlet weak var importBtn: UIButton!
    @IBOutlet weak var packSlectionControl: UISegmentedControl!
    @IBOutlet weak var addPeopleBtn: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var dogView: UIView!
    @IBOutlet weak var personView: UIView!
    
//MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _setUI()
        _setDelegate()
        registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
//MARK: - Delegates Method
    func _setDelegate(){
        dogTblView.delegate = self
        dogTblView.dataSource = self
    }
    
//MARK: - Register cell
    func registerCell(){
        dogTblView.registerNib(of: DogTblViewCell.self)
    }
    
//MARK: - SetUpUI
    func _setUI(){
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        let items = ["Dogs", "People"]
        for (index, title) in items.enumerated() {
            packSlectionControl.setTitle(title, forSegmentAt: index)
        }
        addPeopleBtn.layer.cornerRadius = 10.0
        addPeopleBtn.clipsToBounds = true
        importBtn.layer.cornerRadius = 10.0
        addDogBtn.layer.cornerRadius = 10.0
        addDogBtn.clipsToBounds = true
        dogTitleLbl.layoutIfNeeded()
        dogTitleLbl.roundCorners([.topLeft, .topRight], radius: 8.0)
        peopleTitle.layoutIfNeeded()
        peopleTitle.roundCorners([.topLeft, .topRight], radius: 8.0)
        
    }
    
//MARK: - Button Action
    @IBAction func packSegmentTap(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            dogView.isHidden = false
            personView.isHidden = true
            dogTblView.reloadData()
        case 1:
            dogView.isHidden = true
            personView.isHidden = false
            dogTblView.reloadData()
        default:
            break
        }
        
    }
    

    @IBAction func addPeopleBtnPress(_ sender: UIButton) {
        
    }
    
    
    @IBAction func importBtnPress(_ sender: UIButton) {
        
    }
    
    @IBAction func addDogBtnPress(_ sender: UIButton) {
        let storyboard = AppStoryboard.Main.instance
        let addNewDogVc = storyboard.instantiateViewController(withIdentifier: "AddDogViewController") as! AddDogViewController
        self.navigationController?.pushViewController(addNewDogVc, animated: true)
    }
    
}

//MARK: - Delegates and Datasource
extension AddDogVc: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.getCell() as DogTblViewCell
        let selectedSegment = packSlectionControl.selectedSegmentIndex
        print("selectedSegment", selectedSegment)
        if selectedSegment == 0{
            cell.profileImg.image = UIImage(named: "dogProfile_img")
            cell.profileLbl.text = "Karan Sawant"
            cell.profileDob.text = "October 24, 1996"
        }else{
            cell.profileImg.image = UIImage(named: "person_profile")
            cell.profileLbl.text = "Modassir Siddiqui"
            cell.profileDob.text = "September 29, 1999"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
}
