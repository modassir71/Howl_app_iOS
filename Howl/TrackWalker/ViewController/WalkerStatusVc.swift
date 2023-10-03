//
//  WalkerStatusVc.swift
//  Howl
//
//  Created by apple on 03/10/23.
//

import UIKit

class WalkerStatusVc: UIViewController {
//MARK: - Oultets
    @IBOutlet weak var walkerListTbLview: UITableView!
    
//    MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _delegatesMethod()
        _registerCell()
        _setUI()
    }
    
//    MARK: - Tbl view Delegates
    func _delegatesMethod(){
        walkerListTbLview.delegate = self
        walkerListTbLview.dataSource = self
    }
    
//    MARK: - Register cell
    func _registerCell(){
        walkerListTbLview.registerNib(of: PersonListingTableViewCell.self)
    }
    
//    MARK: - Set UI
    func _setUI(){
        walkerListTbLview.separatorColor = UIColor(cgColor: .init(red: 255.0/255.0, green: 0/255.0, blue: 68.0/255.0, alpha: 1.0))
    }
    
}

//MARK: - Extension of Tableview

extension WalkerStatusVc: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.getCell() as PersonListingTableViewCell
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
   
    }
    
    
