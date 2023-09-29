//
//  NewDogVarietyCell.swift
//  Howl
//
//  Created by apple on 18/08/23.
//

import UIKit

class NewDogVarietyCell: UICollectionViewCell {
//MARK: - Outlet
    @IBOutlet weak var dogNameLbl: UILabel!
    @IBOutlet weak var dogImgView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    //MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        _setUpUI()
      
    }
    
    //MARK: - SetUpUI
    func _setUpUI(){
        dogNameLbl.font = UIFont.appFont(.AileronBold, size: 13.0)
        dogImgView.contentMode = .scaleToFill
        containerView.layer.cornerRadius = 30
        containerView.clipsToBounds = true
        dogImgView.layer.cornerRadius = 30
        dogImgView.clipsToBounds = true
        
    }

}
