//
//  ConcernViewController.swift
//  Howl
//
//  Created by apple on 24/08/23.
//

import UIKit

class ConcernViewController: UIViewController {
    
//MARK: - Outlet
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var concernTblView: UITableView!
    @IBOutlet weak var dragView: UIView!
    @IBOutlet weak var archiveBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var baseView: UIView!
    
    var selectedIndexPath: IndexPath? = nil
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _setUI()
        tableViewDelegates()
        registerCell()
        concernTblView.allowsMultipleSelection = false
    }
// MARK: - Delegates
    func tableViewDelegates(){
        concernTblView.delegate = self
        concernTblView.dataSource = self
    }
    
//MARK: - Register cell
    func registerCell(){
        concernTblView.registerNib(of: ConcernCell.self)
    }

//MARK: - Setup UI
    func _setUI(){
        dragView.layer.cornerRadius = 5.0
        dragView.clipsToBounds = true
       // archiveBtn.setTitle("ARCHIVE", for: .normal)
       // archiveBtn.titleLabel?.font = .appFont(.AileronBold, size: 15.0)
       // shareBtn.setTitle("SHARE", for: .normal)
      //  shareBtn.titleLabel?.font = .appFont(.AileronBold, size: 15.0)
        emailBtn.setTitle("Done", for: .normal)
        emailBtn.titleLabel?.font = .appFont(.AileronBold, size: 15.0)
        shareBtn.backgroundColor = .white
        emailBtn.backgroundColor = .lightGray
      //  archiveBtn.backgroundColor = .white
    }
    
//MARK: - Button Action
    
    @IBAction func archiveBtnPress(_ sender: UIButton) {
    }
    
    @IBAction func emailBtnPress(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func shareBtnPress(_ sender: UIButton) {
    }
}
// MARK: - Tableview Delgates and datasource

extension ConcernViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DogIssues.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.getCell() as ConcernCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.issueLbl.text = DogIssues.allCases[indexPath.row].rawValue
        if (selectedIndexPath == indexPath) {
            cell.fillBtn.setImage(UIImage(named: "radio_Btn"),for:.normal)
        } else {
            cell.fillBtn.setImage(UIImage(named: "empt_Img"),for:.normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedIndexPath = selectedIndexPath, selectedIndexPath == indexPath {
            self.selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
      
}
