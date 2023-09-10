//
//  DogTblViewCell.swift
//  Howl
//
//  Created by apple on 29/08/23.
//

import UIKit

class DogTblViewCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var profileDob: UILabel!
    @IBOutlet weak var profileLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       _setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func _setUI(){
        profileLbl.font = .appFont(.AileronSemiBold, size: 20.0)
        profileDob.font = .appFont(.AileronSemiBold, size: 20.0)
    }
    
}
