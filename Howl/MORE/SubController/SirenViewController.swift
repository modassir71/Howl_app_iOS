//
//  SirenViewController.swift
//  Howl
//
//  Created by apple on 07/09/23.
//

import UIKit
import Foundation

class SirenViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
//MARK: - Outlet
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var sirenPickerView: UIPickerView!
    @IBOutlet weak var playStopBtn: UIButton!
    @IBOutlet weak var setBtn: UIButton!
    
    //    MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        sirenPickerView.delegate = self
        _setUi()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
//    MARK: - SetUp UI
    func _setUi(){
        navigationView.layer.shadowColor = UIColor.black.cgColor
        navigationView.layer.shadowOpacity = 0.2
        navigationView.layer.shadowOffset = CGSize(width: 0, height: 5)
        navigationView.layer.shadowRadius = 2
        playStopBtn.layer.cornerRadius = 10.0
        playStopBtn.clipsToBounds = true
        setBtn.layer.cornerRadius = 10.0
        setBtn.clipsToBounds = true
    }
    
//    MARK: - Button Action
    
    @IBAction func backBtnPress(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func playBtnPress(_ sender: UIButton) {
        // If nothing to play, return
        let kSoundManager = SoundManager.sharedInstance
        if sirenPickerView.selectedRow(inComponent: 0) == 8 {
            return
        }
        
        if kSoundManager.audioPlayer == nil {
            
            kSoundManager.playSiren(index: sirenPickerView.selectedRow(inComponent: 0),
                                    volume: 0.3,
                                    testing: true)
        } else {
            
            if kSoundManager.audioPlayer.isPlaying {
                
                kSoundManager.stopSiren()
            } else {
                kSoundManager.playSiren(index: sirenPickerView.selectedRow(inComponent: 0),
                                        volume: 0.3,
                                        testing: true)
            }
        }

    }
    
    
    @IBAction func setBtnPress(_ sender: UIButton) {
    }
    
    // MARK: SIREN PICKER
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return 9
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label = UILabel()
        if let v = view {
            label = v as! UILabel
        }
        
        switch row {
            
        case 0...7:
            label.text = "Siren \(row)"
        default: // IMPOSSIBLE
            label.text = "Video Only"
        }
        
        label.font = UIFont (name: "Helvetica Neue", size: 35)
        label.textAlignment = .center
        
        return label
    }
    

}
