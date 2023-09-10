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
    }

}
