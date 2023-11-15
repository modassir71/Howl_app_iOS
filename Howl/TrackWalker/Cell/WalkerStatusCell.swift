//
//  WalkerStatusCell.swift
//  Howl
//
//  Created by apple on 03/10/23.
//

import UIKit

class WalkerStatusCell: UITableViewCell {

    @IBOutlet weak var monitorId: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var batteryLbl: UILabel!
    
    @IBOutlet weak var w3wLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        _setUi()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    func _setUi(){
//        containerView.layer.cornerRadius = 10.0
//        containerView.clipsToBounds = true
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 3, height: 3)
        containerView.layer.shadowRadius = 5
        containerView.layer.cornerRadius = 10.0
    }
    
}
