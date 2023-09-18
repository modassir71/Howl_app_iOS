//
//  DogVarietyCollectionViewCell.swift
//  Howl
//
//  Created by apple on 17/08/23.
//

import UIKit

class DogVarietyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dogName: UILabel!
    @IBOutlet weak var dogImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        
      
    }
    
    func setupView(){
        dogName.font = UIFont.appFont(Font.AileronBold, size: 15.0)
        dogName.textColor = UIColor.black
        dogImg.layer.cornerRadius = dogImg.frame.width/2
        dogImg.clipsToBounds = true
        dogImg.layer.borderWidth = 1.0
        dogImg.layer.borderColor = UIColor(displayP3Red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
    }

}
