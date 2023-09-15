//
//  PersonListingTableViewCell.swift
//  Howl
//
//  Created by apple on 06/09/23.
//

import UIKit

class PersonListingTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var nickNameLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    
    let color = UIColor(red: 220/255, green: 2/255, blue: 65/255, alpha: 0.5)
    override func awakeFromNib() {
        super.awakeFromNib()
        setUi()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUi(){
        profileImg.layer.cornerRadius = profileImg.frame.width/2
        profileImg.clipsToBounds = true
        profileImg.layer.borderColor = color.cgColor
        profileImg.layer.borderWidth = 2.0
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 3, height: 3)
        containerView.layer.shadowRadius = 5
        containerView.layer.cornerRadius = 10.0
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        selectedBackgroundView = backgroundView
    }
    
}
