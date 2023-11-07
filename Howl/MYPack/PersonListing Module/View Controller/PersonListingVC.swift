//
//  PersonListingVC.swift
//  Howl
//
//  Created by apple on 06/09/23.
//

import UIKit
import Lottie

class PersonListingVC: UIViewController {

//    MARK: - Outlet
    @IBOutlet weak var personListingTblView: UITableView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var addPersonBtn: UIButton!
    @IBOutlet weak var animationContainer: UIView!
    
    var animationView = LottieAnimationView()
    var peopleDataManager = AddPeopleDataManager.sharedInstance
    let emptyLabel = UILabel()
    
//    MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _setUI()
        delegateMethod()
        registerCell()
        personListingTblView.separatorColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
        floatingBtn()
        personListingTblView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        personListingTblView.reloadData()
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
            let addNewDogVc = storyboard.instantiateViewController(withIdentifier: "AddNewPersonVc") as! AddNewPersonVc
            self.navigationController?.pushViewController(addNewDogVc, animated: true)
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
        addPersonBtn.isHidden = true
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
//MARK: - Table view Delegates and datasource method
extension PersonListingVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if peopleDataManager.people.count == 0{
            animationViewStart()
            animationContainer.isHidden = false
            emptyLabel.isHidden = false
        }else{
            emptyLabel.removeFromSuperview()
            emptyLabel.isHidden = true
            animationView.removeFromSuperview()
            animationContainer.isHidden = true
        }
        return peopleDataManager.people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.getCell() as PersonListingTableViewCell
        animationView.isHidden = true
        emptyLabel.isHidden = true
        cell.nameLbl.text = peopleDataManager.people[indexPath.row].personMobileNumber
        cell.nickNameLbl.text = peopleDataManager.people[indexPath.row].personName
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = self.peopleDataManager.people[indexPath.row]
        
        let alert = UIAlertController(title: DogConstantString.warningTitle,
                                      message: DogConstantString.editMsg,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: DogConstantString.proceedTitle, style: .default, handler: { _ in
            let storyBoard = AppStoryboard.Main.instance
            let addNewVc = storyBoard.instantiateViewController(withIdentifier: "AddNewPersonVc") as! AddNewPersonVc
            self.peopleDataManager.selectedIndex = indexPath.row
            addNewVc.isEdit = true
            addNewVc.name = selectedItem.personName
            addNewVc.profileImge = selectedItem.personImage
            addNewVc.contryCode = selectedItem.personCountryCode
            addNewVc.type = true
            addNewVc.senderType = selectedItem.personNotificationType
            addNewVc.phoneNumber = selectedItem.personMobileNumber
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(addNewVc, animated: true)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: DogConstantString.deleteTitle) { (contextualAction, view, boolValue) in
            let alert = UIAlertController(title: DogConstantString.warningTitle,
                                          message: DogConstantString.warningMsg,
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: DogConstantString.proceedTitle, style: .default, handler: { _ in
                self.deletePeople(index: indexPath.row)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        delete.backgroundColor = UIColor.red
        
        let swipeActions = UISwipeActionsConfiguration(actions: [delete])
        
        return swipeActions
    }

    
//    MARK: - Delete People method
    func deletePeople(index: Int!){
        peopleDataManager.people.remove(at: index)
        if !peopleDataManager.savePeople() == true {
            let alert = UIAlertController(title: DogConstantString.peopleDeleteErrorTitle, message: DogConstantString.peopleDeleteError, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        personListingTblView.reloadData()
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
        emptyLblMsg()
        animationView.play()
    }
    
    func emptyLblMsg(){
        
        emptyLabel.text = "This part of your pack is empty.\nAdd a contact"
        emptyLabel.textColor = UIColor.gray
        emptyLabel.numberOfLines = 2
        emptyLabel.font = UIFont.systemFont(ofSize: 18)
       // label.backgroundColor = .red
        emptyLabel.textAlignment = .center
        let centerX = view.bounds.width / 2.0
        let centerY = view.bounds.height / 2.0
        let viewWidth: CGFloat = 284
        let viewHeight: CGFloat = 60
        emptyLabel.frame = CGRect(x: centerX - viewWidth / 2.0, y: centerY - viewHeight / 2.0 - 120, width: viewWidth, height: viewHeight)
        view.addSubview(emptyLabel)
    }
}
