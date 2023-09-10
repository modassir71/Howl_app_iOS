//
//  ConcernCell.swift
//  Howl
//
//  Created by apple on 24/08/23.
//

import UIKit

class ConcernCell: UITableViewCell {

    @IBOutlet weak var fillBtn: UIButton!
    @IBOutlet weak var issueLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        _setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func _setUI(){
        issueLbl.font = .appFont(.AileronBold, size: 18.0)
        issueLbl.textColor = UIColor(displayP3Red: 31/255, green: 29/255, blue: 30/255, alpha: 1.0)
        
    }
    
}
