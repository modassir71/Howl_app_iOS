//
//  DogWalkingViewController.swift
//  Howl
//
//  Created by apple on 20/08/23.
//

import UIKit
import Lottie

class DogWalkingViewController: UIViewController {
    
//MARK: - Outlet
    
    @IBOutlet weak var concernBtn: UIButton!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var redBtn: UIButton!
    @IBOutlet weak var dogAnimationView: UIImageView!
    @IBOutlet weak var streetImg: UIImageView!
    @IBOutlet weak var dogStopImg: UIImageView!
    @IBOutlet weak var dogAnimateView: UIImageView!
    @IBOutlet weak var swipeSlider: DSSlider!
    @IBOutlet weak var startWalkBtn: TGFlingActionButton!
    @IBOutlet weak var backAction: UIButton!
    @IBOutlet weak var dogOwnerName: UILabel!
    @IBOutlet weak var dogName: UILabel!
    @IBOutlet weak var titleImg: UIImageView!
    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var crossBtn: UIButton!
    
    //MARK: - Variable
    var dogNameLbl = String()
    var dogOwnerNameLbl = String()
    var dogImgItem = UIImage()
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUi()
        DispatchQueue.main.async {
         self._setupSliderView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - SetUi
    func setUi(){
     dogImage.layer.borderWidth = 1.0
     dogImage.layer.borderColor = UIColor(displayP3Red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1).cgColor
     dogImage.layer.cornerRadius = dogName.frame.width/2
     dogImage.clipsToBounds = true
     dogImage.contentMode = .scaleAspectFit
     dogName.text = dogNameLbl
     dogImage.image = UIImage(named: dogNameLbl)
     dogImage.contentMode = .scaleAspectFit
     streetImg.isHidden = true
     redBtn.layer.cornerRadius = redBtn.frame.width/2
     redBtn.clipsToBounds = true
     shadowView.layer.cornerRadius = shadowView.frame.width/2
     shadowView.clipsToBounds = true
     shadowView.isHidden = true
     redBtn.isHidden = true
     concernBtn.layer.cornerRadius = 26.0
     concernBtn.clipsToBounds = true
     concernBtn.isHidden = true
     concernBtn.layer.borderColor = UIColor(displayP3Red: 31/255, green: 31/255, blue: 31/255, alpha: 1.0).cgColor
    concernBtn.layer.borderWidth = 2.0
    concernBtn.setTitle("Raise a Cocern Related", for: .normal)
    concernBtn.setTitleColor(.black, for: .normal)
        concernBtn.titleLabel?.font = .appFont(.AileronBold, size: 20)
    }
    //MARK: - Action
    
    @IBAction func crossBtnPress(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func backPress(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - Setup Swipe Button
    private func _setupSliderView() {
      //  let slider = DSSlider(frame: animationSliderView.bounds, delegate: self)
        swipeSlider.comeFromStartRide = ""
        swipeSlider.isDoubleSideEnabled = true
        swipeSlider.isImageViewRotating = true
        swipeSlider.isTextChangeAnimating = true
        swipeSlider.isDebugPrintEnabled = false
        swipeSlider.isShowSliderText = true
        swipeSlider.isEnabled = true
        swipeSlider.sliderAnimationVelocity = 0.2
        swipeSlider.sliderViewTopDistance = 0.0
        swipeSlider.sliderImageViewTopDistance = 5
        swipeSlider.sliderImageViewStartingDistance = 5
        swipeSlider.sliderTextLabelLeadingDistance = 0
        swipeSlider.sliderCornerRadius = swipeSlider.frame.height / 2
        swipeSlider.sliderBackgroundColor =  UIColor(red: 255/255, green: 36/255, blue: 109/255, alpha: 1)
        swipeSlider.sliderBackgroundViewTextColor = .white
        swipeSlider.sliderDraggedViewTextColor = .white
        swipeSlider.sliderDraggedViewBackgroundColor = UIColor(red: 31/255, green: 29/255, blue: 23/255, alpha: 1)
        if swipeSlider.sliderPosition == .left{
            swipeSlider.sliderImageViewBackgroundColor = UIColor(red: 255/255, green: 36/255, blue: 109/255, alpha: 1)
        }
        if swipeSlider.sliderPosition == .rigth{
            swipeSlider.sliderImageViewBackgroundColor = UIColor(red: 31/255, green: 29/255, blue: 23/255, alpha: 1)
        }
        swipeSlider.delegate = self
        swipeSlider.sliderTextFont = .appFont(.AileronBold, size: 25)
     //   swipeSlider.sliderImageView.image = UIImage(named: "arrow-icon")
        swipeSlider.sliderBackgroundViewTextLabel.text = "START WALKING"
        swipeSlider.sliderDraggedViewTextLabel.text = "STOP WALKING"
    }

    //MARK: - Button Action
    
    @IBAction func concernBtnPress(_ sender: UIButton) {
        let storyboard = AppStoryboard.Main.instance
        let concernVc = storyboard.instantiateViewController(withIdentifier: "ConcernViewController") as! ConcernViewController
      //  concernVc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(concernVc, animated: true)
    }
    
    
    
    
}
//MARK: - Swipe Button
extension DogWalkingViewController: DSSliderDelegate{
    func sliderDidFinishSliding(_ slider: DSSlider, at position: DSSliderPosition) {
        if position == .left{
            DispatchQueue.main.async {
                for subview in self.dogAnimationView.subviews {
                    subview.removeFromSuperview()
                }
                self.dogAnimationView.isHidden = true
            }
            dogStopImg.isHidden = false
            streetImg.isHidden = true
            self.tabBarController?.tabBar.isHidden = false
            self.shadowView.isHidden = true
            self.redBtn.isHidden = true
            self.concernBtn.isHidden = true
        }else{
            dogStopImg.isHidden = true
            streetImg.isHidden = false
            DispatchQueue.main.async {
                self.animationView()
                self.dogAnimationView.isHidden = false
                self.tabBarController?.tabBar.isHidden = true
                self.shadowView.isHidden = false
                self.redBtn.isHidden = false
                self.concernBtn.isHidden = false
            }
        }
    }
    
// MARK: - Animation View
    func animationView(){
        let jsonName = "animation_dogWalk"
        let animation = LottieAnimation.named(jsonName)
        let animationView = LottieAnimationView(animation: animation)
        animationView.frame = CGRect(x: 30, y: 0, width: 225, height: 225)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.animationSpeed = 2
        dogAnimationView.addSubview(animationView)
        animationView.play()
    }
}
